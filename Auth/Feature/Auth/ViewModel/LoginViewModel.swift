//
//  LoginViewModel.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import Combine
import Foundation
import Resolver

final class LoginViewModel: ViewModel {
    // MARK: - Inputs
    @Published var email: String = ""
    @Published var password: String = ""
    
    // MARK: - Outputs
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let appState: AppState
    private let login: LoginUseCaseProtocol
    private let profileRepo: ProfileRepository
    private let apiClient: APIClienting
    
    // MARK: - Init
    init(
        login: LoginUseCaseProtocol = Resolver.resolve(),
        profileRepo: ProfileRepository = Resolver.resolve(),
        appState: AppState,
        apiClient: APIClienting = Resolver.resolve()
    ) {
        self.login = login
        self.profileRepo = profileRepo
        self.appState = appState
        self.apiClient = apiClient
    }
    
    // MARK: - Public
    func submit() {
        errorMessage = nil
        
        guard validateInputs() else { return }
        
        isLoading = true
        print("🟡 [Login] Попытка входа для: \(email)")
        
        sendTestRequest() // MARK: FOR TESTING, RANDOM DATA
        performLoginFlow()
    }
    
    // MARK: - Private Helpers
    
    private func validateInputs() -> Bool {
        guard Validators.isValidEmail(email) else {
            errorMessage = "Неверный формат email"
            return false
        }
        guard Validators.isValidPassword(password) else {
            errorMessage = "Пароль должен быть не короче 6 символов"
            return false
        }
        return true
    }
    
    private func sendTestRequest() {
        apiClient.get(url: URL(string: "https://randomuser.me/api/")!)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("❌ [TestAPI] Ошибка: \(error.localizedDescription)")
                }
            } receiveValue: { data in
                if let str = String(data: data, encoding: .utf8) {
                    print("📡 [TestAPI] Ответ randomuser.me:\n\(str)")
                }
            }
            .store(in: &subscriptions)
    }
    
    private func performLoginFlow() {
        login.execute(email: email, password: password)
            .handleEvents(receiveOutput: { user in
                print("🟢 [Login] Успешно получен профиль: \(user.email), id: \(user.id)")
            })
            .flatMap { [profileRepo] user in
                profileRepo.saveLocal(user)
                    .handleEvents(receiveOutput: {
                        print("📦 [CoreData] Сохранили профиль в CoreData: \(user.email)")
                    }, receiveCompletion: { result in
                        if case .failure(let error) = result {
                            print("❌ [CoreData] Ошибка при сохранении: \(error.localizedDescription)")
                        }
                    })
                    .map { user }
                    .catch { _ in Just(user) }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.handleLoginCompletion(completion)
            } receiveValue: { [weak self] user in
                self?.handleLoginSuccess(user)
            }
            .store(in: &subscriptions)
    }
    
    private func handleLoginCompletion(_ completion: Subscribers.Completion<Error>) {
        isLoading = false
        if case let .failure(error) = completion {
            print("🔴 [Login] Ошибка входа: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
    
    private func handleLoginSuccess(_ user: UserProfile) {
        print("✅ [AppState] Пользователь вошёл: \(user.email), переход на главный экран")
        appState.currentUser = user
        appState.route = .main
    }
}
