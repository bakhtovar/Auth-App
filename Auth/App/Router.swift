//
//  Router.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import SwiftUI

struct RouterView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            switch appState.route {
            case .login:
                LoginView(viewModel: .init(appState: appState))
            case .signup:
                SignUpView(viewModel: .init(appState: appState))
            case .main:
                MainView(viewModel: .init(user: appState.currentUser))
            case .resetPassword:
                ResetPasswordView(viewModel: .init())
                    .environmentObject(appState)
            }
        }
    }
}
