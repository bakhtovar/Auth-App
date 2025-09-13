//
//  LoginUseCase.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import Combine

protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) -> AnyPublisher<UserProfile, Error>
}

struct LoginUseCase: LoginUseCaseProtocol {
    let repo: AuthRepository
    func execute(email: String, password: String) -> AnyPublisher<UserProfile, any Error> {
        repo.login(email: email, password: password)
    }
}

protocol RegisterUseCaseProtocol {
    func execute(_ input: RegisterInput) -> AnyPublisher<UserProfile, Error>
}

struct RegisterUseCase: RegisterUseCaseProtocol {
    let repo: AuthRepository
    func execute(_ input: RegisterInput) -> AnyPublisher<UserProfile, Error> {
        repo.register(input)
    }
}

protocol ResetPasswordUseCaseProtocol {
    func execute(email: String, newPassword: String) -> AnyPublisher<Void, Error>
}

struct ResetPasswordUseCase: ResetPasswordUseCaseProtocol {
    let repo: AuthRepository
    func execute(email: String, newPassword: String) -> AnyPublisher<Void, Error> {
        repo.resetPassword(email: email, newPassword: newPassword)
    }
}
