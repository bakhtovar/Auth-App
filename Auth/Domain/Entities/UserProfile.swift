//
//  UserProfile.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import Foundation

struct UserProfile: Identifiable, Equatable {
    let id: UUID
    var name: String
    var email: String
    var phone: String?
    var birthDate: Date?
    var avatarURL: String?
    var updatedAt: Date
}

extension UserProfile {
    static func mock(
        name: String = "Bakhtovar",
        email: String = "test@gmail.com"
    ) -> UserProfile {
        .init(
            id: UUID(),
            name: name,
            email: email,
            phone: nil,
            birthDate: nil,
            avatarURL: nil,
            updatedAt: Date()
        )
    }
}
