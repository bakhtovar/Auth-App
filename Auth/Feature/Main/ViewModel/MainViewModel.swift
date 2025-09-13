//
//  MainViewModel.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import Foundation
import Resolver

final class MainViewModel: ObservableObject {
    @Published var greeting: String

    init(user: UserProfile?, profileRepo: ProfileRepository = Resolver.resolve()) {
        if let user {
            greeting = "Здравствуйте, \(user.name)!"
        } else {
            greeting = "Здравствуйте!"
            _ = profileRepo.fetchLocal(byEmail: nil)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] local in
                    if let local { self?.greeting = "Здравствуйте, \(local.name)!" }
                }
        }
    }
}
