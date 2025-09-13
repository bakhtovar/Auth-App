//
//  MockResetPasswordUseCase.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import Combine
import Foundation
import Combine

final class MockResetPasswordUseCase: ResetPasswordUseCaseProtocol {
    var didExecute = false
    var shouldFail = false

    init() {
        self.repo = MockAuthRepository()
    }

    let repo: AuthRepository

    func execute(email: String, newPassword: String) -> AnyPublisher<Void, Error> {
        didExecute = true
        if shouldFail {
            return Fail(error: NSError(domain: "Test", code: 1)).eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
