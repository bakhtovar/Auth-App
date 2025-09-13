//
//  LoginView.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import SwiftUI
import Resolver

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: LoginViewModel
    @State private var isPasswordVisible = false
    
    @EnvironmentObject var net: NetworkMonitor
    @Injected var banner: ToastBannerManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Header
                LogoHeader()
                
                // Title
                TitleBlock()
                
                // Email
                EmailField(text: $viewModel.email, placeholder: "Loisbecket@gmail.com", identifier: "login_email")

                // Password
                PasswordField(text: $viewModel.password, isVisible: $isPasswordVisible, title: "Password", identifier: "login_password")

                // Forgot password
                ForgotPasswordButton {
                    if !net.isReachable {
                        banner.show("⚠️ Нет подключения к сети")
                    } else {
                        appState.route = .resetPassword
                    }
                }
                
                // Error
                if let err = viewModel.errorMessage {
                    Text(err)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }
                
                // Log in button
                PrimaryActionButton(title: "Log In", isLoading: viewModel.isLoading) {
                    viewModel.submit()
                }
                .accessibilityIdentifier("login_button")
                
                // Divider
                DividerOr()
                
                // Social buttons
                VStack(spacing: 10) {
                    SocialButton(icon: "googleIcon", text: "Continue with Google") {
                        // TODO: Google auth
                    }
                    SocialButton(icon: "facebookIcon", text: "Continue with Facebook") {
                        // TODO: Facebook auth
                    }
                }
                .buttonStyle(.plain)
                
                // Bottom link
                BottomLink(
                    text: "Don’t have an account?",
                    linkText: "Sign Up"
                ) {
                    appState.route = .signup
                }
                .accessibilityIdentifier("login_signup")
            }
            .padding(20)
        }
    }
}

#Preview {
    LoginView(viewModel: .init(appState: AppState()))
        .environmentObject(AppState())
        .environmentObject(NetworkMonitor())
        .environmentObject(ToastBannerManager())
}

// MARK: - Subviews

private struct LogoHeader: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "shield.fill")
                .foregroundStyle(.blue)
            Text("Logoipsum")
                .font(.headline)
                .foregroundStyle(.blue)
            Spacer()
        }
        .padding(.top, 8)
    }
}

private struct TitleBlock: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Sign in to your")
                .font(.system(size: 34, weight: .bold))
            Text("Account")
                .font(.system(size: 34, weight: .bold))
            Text("Enter your email and password to log in")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 2)
        }
        .padding(.top, 6)
    }
}

private struct ForgotPasswordButton: View {
    var action: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Button("Forgot Password ?") {
                action()
            }
            .accessibilityIdentifier("login_forgot")
            .font(.callout)
        }
    }
}

private struct DividerOr: View {
    var body: some View {
        HStack {
            Rectangle().frame(height: 1).foregroundStyle(.gray.opacity(0.2))
            Text("Or")
                .foregroundStyle(.secondary)
                .font(.subheadline)
            Rectangle().frame(height: 1).foregroundStyle(.gray.opacity(0.2))
        }
        .padding(.vertical, 6)
    }
}

private struct SocialButton: View {
    var icon: String
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                HStack(spacing: 10) {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text(text)
                        .fontWeight(.semibold)
                }
                Spacer()
            }
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.gray.opacity(0.25))
            )
        }
    }
}
