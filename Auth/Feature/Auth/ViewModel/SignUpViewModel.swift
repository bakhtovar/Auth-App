//
//  SignUpViewModel.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import Foundation
import SwiftUI
import PhotosUI
import Combine
import Resolver

final class SignUpViewModel: ViewModel {
    // MARK: - Inputs
    @Published var photoItem: PhotosPickerItem?
    @Published var selectedImageData: Data?
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var birthDate: Date = .now
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    
    // MARK: - Outputs
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let register: RegisterUseCaseProtocol
    private let appState: AppState
    
    // MARK: - Init
    init(
        appState: AppState,
        register: RegisterUseCaseProtocol = Resolver.resolve()
    ) {
        self.appState = appState
        self.register = register
    }
    
    // MARK: - Public
    func pickChanged() {
        loadPhotoData()
    }
    
    func submit() {
        errorMessage = nil
        
        guard validateInputs() else { return }
        
        performRegistration()
    }
}

// MARK: - Validation
private extension SignUpViewModel {
    func validateInputs() -> Bool {
        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your name"
            return false
        }
        guard Validators.isValidEmail(email) else {
            errorMessage = "Invalid email address"
            return false
        }
        guard Validators.isValidPassword(password) else {
            errorMessage = "Password must be at least 6 characters"
            return false
        }
        guard !phone.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a phone number"
            return false
        }
        if let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year,
           age < 18 {
            errorMessage = "You must be at least 18 years old"
            return false
        }
        return true
    }
}

// MARK: - Photo Picker
private extension SignUpViewModel {
    func loadPhotoData() {
        guard let item = photoItem else { return }
        
        Task { @MainActor in
            do {
                if let data = try await item.loadTransferable(type: Data.self) {
                    self.selectedImageData = data
                }
            } catch {
                print("❌ [Photo] Failed to load image: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Registration
private extension SignUpViewModel {
    func performRegistration() {
        isLoading = true
        let input = RegisterInput(
            name: fullName,
            email: email,
            phone: phone,
            birthDate: birthDate,
            password: password
        )
        
        register.execute(input)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.handleRegistrationCompletion(completion)
            } receiveValue: { [weak self] user in
                self?.handleRegistrationSuccess(user)
            }
            .store(in: &subscriptions)
    }
    
    func handleRegistrationCompletion(_ completion: Subscribers.Completion<Error>) {
        isLoading = false
        if case let .failure(error) = completion {
            print("❌ [SignUp] \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
    
    func handleRegistrationSuccess(_ user: UserProfile) {
        print("✅ [SignUp] User registered: \(user.email)")
        appState.currentUser = user
        appState.route = .main
    }
}

