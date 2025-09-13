//
//  ProfileRepository.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import Combine

protocol ProfileRepository {
    func saveLocal(_ profile: UserProfile) -> AnyPublisher<Void, Error>
    func fetchLocal(byEmail email: String?) -> AnyPublisher<UserProfile?, Never>
    func clearAll() -> AnyPublisher<Void, Error>
}

final class DummyProfileRepo: ProfileRepository {
    func clearAll() -> AnyPublisher<Void, Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchLocal(byEmail: String?) -> AnyPublisher<UserProfile?, Never> {
        Just(nil).eraseToAnyPublisher()
    }
    
    func saveLocal(_ profile: UserProfile) -> AnyPublisher<Void, Error> {
        Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
