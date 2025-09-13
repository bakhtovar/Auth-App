//
//  MockAuthRepository.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import Combine
import Foundation

final class MockAuthRepository: AuthRepository {
    var didLogin = false
    var shouldFail = false  
    
    func login(email: String, password: String) -> AnyPublisher<UserProfile, Error> {
        didLogin = true
        if shouldFail {
            return Fail(error: NSError(domain: "Test", code: 1))
                .eraseToAnyPublisher()
        } else {
            let user = UserProfile(
                id: UUID(),
                name: "Bakhtovar",
                email: email,
                phone: nil,
                birthDate: nil,
                avatarURL: nil,
                updatedAt: Date()
            )
            return Just(user)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func register(_ input: RegisterInput) -> AnyPublisher<UserProfile, Error> {
        return Fail(error: AuthError.invalidCredentials).eraseToAnyPublisher()
    }

    func resetPassword(email: String, newPassword: String) -> AnyPublisher<Void, Error> {
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
