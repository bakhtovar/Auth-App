//
//  AppState.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import Foundation
import Combine
import Resolver

enum Route: Hashable {
    case login
    case signup
    case main
    case resetPassword
}

final class AppState: ObservableObject {
    @Published var route: Route = .login
    @Published var currentUser: UserProfile?
    
    private var bag = Set<AnyCancellable>()
    @Injected private var profileRepo: ProfileRepository
    
    func bootstrap() {
        profileRepo.fetchLocal(byEmail: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self else { return }
                if let user {
                    self.currentUser = user
                    self.route = .main
                }
            }
            .store(in: &bag)
    }
}
