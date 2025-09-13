//
//  ResetPasswordViewModel.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import Combine
import Foundation
import Resolver

final class ResetPasswordViewModel: ViewModel {
    // MARK: - Inputs
    @Published var email: String = ""
    @Published var newPassword: String = ""
    
    // MARK: - Outputs
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var done = false

    // MARK: - Dependencies
    private let reset: ResetPasswordUseCaseProtocol

    // MARK: - Init
    init(reset: ResetPasswordUseCaseProtocol = Resolver.resolve()) {
        self.reset = reset
    }
    
    // MARK: - Public
    func submit() {
        errorMessage = nil
        
        guard validateInputs() else { return }
        
        performReset()
    }
}

// MARK: - Validation
private extension ResetPasswordViewModel {
    func validateInputs() -> Bool {
        guard Validators.isValidEmail(email) else {
            errorMessage = "Invalid email"
            return false
        }
        guard Validators.isValidPassword(newPassword) else {
            errorMessage = "Password must be at least 6 characters"
            return false
        }
        return true
    }
}

// MARK: - Reset Logic
private extension ResetPasswordViewModel {
    func performReset() {
        isLoading = true
        reset.execute(email: email, newPassword: newPassword)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.handleCompletion(completion)
            } receiveValue: { [weak self] in
                self?.handleSuccess()
            }
            .store(in: &subscriptions)
    }
    
    func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        isLoading = false
        if case let .failure(error) = completion {
            print("❌ [ResetPassword] \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
    
    func handleSuccess() {
        done = true
    }
}
