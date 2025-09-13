//
//  ProfileMapping.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import Foundation

struct ProfileMapper {
    func toDomain(_ entity: ProfileEntity) -> UserProfile {
        UserProfile(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            email: entity.email ?? "",
            phone: entity.phone,
            birthDate: entity.birthDate,
            avatarURL: entity.avatarURL,
            updatedAt: entity.updatedAt ?? Date()
        )
    }
    
    func apply(_ profile: UserProfile, to entity: ProfileEntity) {
        entity.id = profile.id
        entity.name = profile.name
        entity.email = profile.email
        entity.phone = profile.phone
        entity.birthDate = profile.birthDate
        entity.avatarURL = profile.avatarURL
        entity.updatedAt = profile.updatedAt
    }
}
