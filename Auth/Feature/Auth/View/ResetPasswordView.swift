//
//
//  ResetPasswordView.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var vm: ResetPasswordViewModel
    @FocusState private var focus: Field?
    @State private var showPassword = false
    
    init(viewModel: ResetPasswordViewModel = .init()) {
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    private enum Field { case email, password }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Top bar
            TopBar(title: "Reset Password") {
                appState.route = .login
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Enter your email and set a new password")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 8)
                    
                    // Fields
                    EmailField(
                        text: $vm.email,
                        placeholder: "email@example.com",
                        identifier: "reset_email"
                    )
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focus = .password }
                    
                    PasswordField(
                        text: $vm.newPassword,
                        isVisible: $showPassword,
                        title: "New Password",
                        identifier: "reset_password"
                    )
                    .focused($focus, equals: .password)
                    .submitLabel(.go)
                    .onSubmit { submit() }
                    
                    // Error / Success
                    if let err = vm.errorMessage {
                        Text(err)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                    if vm.done && vm.errorMessage == nil {
                        Label("Password updated. You can log in now.", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.footnote)
                            .accessibilityIdentifier("success_message")
                    }
                    
                    // Primary action
                    PrimaryActionButton(title: "Set New Password", isLoading: vm.isLoading) {
                        submit()
                    }
                    .disabled(vm.email.isEmpty || vm.newPassword.count < 6 || vm.isLoading)
                    
                    Spacer(minLength: 20)
                }
                .padding(20)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func submit() {
        vm.submit()
    }
}

#Preview {
    ResetPasswordView()
        .environmentObject(AppState())
}

// MARK: - Subviews

private struct TopBar: View {
    var title: String
    var onBack: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .font(.headline)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        
        Text(title)
            .font(.system(size: 32, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 8)
    }
}
