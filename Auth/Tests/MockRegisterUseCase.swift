//
//  MockRegisterUseCase.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import Combine
import Foundation

final class MockRegisterUseCase: RegisterUseCaseProtocol {
    var didExecute = false
    var shouldFail = false
    
    func execute(_ input: RegisterInput) -> AnyPublisher<UserProfile, Error> {
        didExecute = true
        if shouldFail {
            return Fail(error: NSError(domain: "Test", code: 1))
                .eraseToAnyPublisher()
        } else {
            let user = UserProfile(
                id: UUID(),
                name: "Bakhtovar",
                email: "bakhtovar@gmail.com",
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
}
