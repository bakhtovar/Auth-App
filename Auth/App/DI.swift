//
//  DI.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import Resolver

enum DI {
    static func setup() {
        
        // MARK: - CoreData
        Resolver.register { CoreDataStack() }.scope(.application)
        Resolver.register { ProfileMapper() }
        Resolver.register {
            ProfileRepositoryCoreData(
                stack: Resolver.resolve(),
                mapper: Resolver.resolve()
            ) as ProfileRepository
        }

        // MARK: - System services
        Resolver.register { APIClient() as APIClienting }.scope(.application)
        Resolver.register { KeychainService() as KeychainServicing }
        Resolver.register { NetworkMonitor() }.scope(.application)
        Resolver.register { Resolver.resolve(NetworkMonitor.self) as NetworkMonitoring }
            .scope(.application)
        Resolver.register { ToastBannerManager() }.scope(.application)

        // MARK: - Auth
        Resolver.register {
            AuthRepositoryHybrid(
                api: Resolver.resolve(),
                monitor: Resolver.resolve(),
                keychain: Resolver.resolve(),
                profileRepo: Resolver.resolve()
            ) as AuthRepository
        }

        // MARK: - Use cases
        Resolver.register { LoginUseCase(repo: Resolver.resolve()) as LoginUseCaseProtocol }
        Resolver.register { RegisterUseCase(repo: Resolver.resolve()) as RegisterUseCaseProtocol }
        Resolver.register { ResetPasswordUseCase(repo: Resolver.resolve()) as ResetPasswordUseCaseProtocol }
    }
}
