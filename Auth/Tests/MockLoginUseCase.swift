//
//  MockLoginUseCase.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import Combine
import Foundation

final class MockLoginUseCase: LoginUseCaseProtocol {
    var didExecute = false
    var shouldFail = false
    
    func execute(email: String, password: String) -> AnyPublisher<UserProfile, Error> {
        didExecute = true
        
        if shouldFail {
            return Fail(error: NSError(domain: "Test", code: 1))
                .eraseToAnyPublisher()
        } else {
            let user = UserProfile(
                id: UUID(),
                name: "Test User", email: email,
                updatedAt: Date()
            )
            return Just(user)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
