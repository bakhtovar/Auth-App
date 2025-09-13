//
//  AuthRepositoryHybrid.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import Combine
import Foundation

struct RegisterInput: Encodable {
    let name: String
    let email: String
    let phone: String?
    let birthDate: Date?
    let password: String
}

enum AuthError: LocalizedError {
    case invalidCredentials
    var errorDescription: String? { "Неверный email или пароль" }
}

protocol AuthRepository {
    func login(email: String, password: String) -> AnyPublisher<UserProfile, Error>
    func register(_ input: RegisterInput) -> AnyPublisher<UserProfile, Error>
    func resetPassword(email: String, newPassword: String) -> AnyPublisher<Void, Error>
}

enum OfflineError: LocalizedError {
    case onlineRequired, noCachedUser
    var errorDescription: String? {
        switch self  {
        case .onlineRequired: "This action requires internet connection"
        case .noCachedUser:  "No cached user for offline login"
        }
    }
}

final class AuthRepositoryHybrid: AuthRepository {
    private let api: APIClienting
    private let monitor: NetworkMonitoring
    private let keychain: KeychainServicing
    private let profileRepo: ProfileRepository

    init(api: APIClienting, monitor: NetworkMonitoring, keychain: KeychainServicing, profileRepo: ProfileRepository) {
        self.api = api
        self.monitor = monitor
        self.keychain = keychain
        self.profileRepo = profileRepo
    }

    // MARK: Login (online/offline)
    func login(email: String, password: String) -> AnyPublisher<UserProfile, Error> {
        guard keychain.verify(email: email, password: password) else {
            return Fail(error: AuthError.invalidCredentials).eraseToAnyPublisher()
        }

        return profileRepo.fetchLocal(byEmail: email)
            .tryMap { cached -> UserProfile in
                if let cached { return cached }
    
                let user = UserProfile(
                    id: UUID(),
                    name: email.components(separatedBy: "@").first ?? "User",
                    email: email,
                    phone: nil,
                    birthDate: nil,
                    avatarURL: nil,
                    updatedAt: Date()
                )
                return user
            }
            .flatMap { [profileRepo] user in
                profileRepo.saveLocal(user).map { user }
            }
            .handleEvents(receiveOutput: { [keychain] _ in
                keychain.setCurrentEmail(email)
            })
            .eraseToAnyPublisher()
    }

    // MARK: Register (offline mock)
    func register(_ input: RegisterInput) -> AnyPublisher<UserProfile, Error> {
        guard monitor.isReachable else {
            return Fail(error: OfflineError.onlineRequired).eraseToAnyPublisher()
        }

        let user = UserProfile(
            id: UUID(),
            name: input.name,
            email: input.email,
            phone: input.phone,
            birthDate: input.birthDate,
            avatarURL: nil,
            updatedAt: Date()
        )

        keychain.savePasswordHash(email: user.email, password: input.password)
        keychain.setCurrentEmail(user.email)

        return profileRepo.saveLocal(user).map { user }.eraseToAnyPublisher()
    }

    // MARK: Reset Password (offline mock)
    func resetPassword(email: String, newPassword: String) -> AnyPublisher<Void, Error> {
        guard monitor.isReachable else {
            return Fail(error: OfflineError.onlineRequired).eraseToAnyPublisher()
        }

        keychain.savePasswordHash(email: email, password: newPassword)
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
