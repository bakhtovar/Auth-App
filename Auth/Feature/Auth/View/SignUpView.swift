//
//  SignUpView.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import SwiftUI
import PhotosUI
import Resolver

struct SignUpView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: SignUpViewModel
    @EnvironmentObject var net: NetworkMonitor
    @Injected var banner: ToastBannerManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Back button
                BackButton { appState.route = .login }
                
                // Header
                Text("Sign up")
                    .font(.largeTitle).bold()
                Text("Create an account to continue!")
                    .foregroundStyle(.secondary)
                
                // Avatar picker
                AvatarPicker(
                    imageData: viewModel.selectedImageData,
                    photoItem: $viewModel.photoItem
                ) {
                    viewModel.pickChanged()
                }
                .padding(.top, 8)
                
                // Fields
                FullNameField(text: $viewModel.fullName)
                EmailField(text: $viewModel.email,
                           placeholder: "name@example.com",
                           identifier: "signup_email")
                BirthDateField(date: $viewModel.birthDate)
                PhoneField(text: $viewModel.phone)
                PasswordField(
                    text: $viewModel.password,
                    isVisible: $viewModel.isPasswordVisible,
                    title: "Set Password",
                    identifier: "signup_password"
                )
                
                // Error
                if let err = viewModel.errorMessage {
                    Text(err)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }
                
                // Register button
                PrimaryActionButton(title: "Register", isLoading: viewModel.isLoading) {
                    if !net.isReachable {
                        banner.show("⚠️ Нет подключения к сети")
                        return
                    }
                    viewModel.submit()
                }
                .accessibilityIdentifier("signup_register")
                
                // Already have account
                BottomLink(
                    text: "Already have an account?",
                    linkText: "Login"
                ) { appState.route = .login }
                .accessibilityIdentifier("signup_login")
            }
            .padding(20)
        }
    }
}

#Preview {
    SignUpView(viewModel: .init(appState: AppState()))
        .environmentObject(AppState())
}

// MARK: Subviews

private struct BackButton: View {
    var action: () -> Void
    var body: some View {
        HStack {
            Button(action: action) {
                Image(systemName: "chevron.left")
            }
            Spacer()
        }
        .padding(.bottom, 4)
    }
}

private struct AvatarPicker: View {
    var imageData: Data?
    @Binding var photoItem: PhotosPickerItem?
    var onChange: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                if let data = imageData, let uiimg = UIImage(data: data) {
                    Image(uiImage: uiimg)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(12)
                        .foregroundStyle(.gray.opacity(0.6))
                }
            }
            .frame(width: 72, height: 72)
            .background(Circle().fill(.gray.opacity(0.12)))
            
            PhotosPicker(selection: $photoItem, matching: .images) {
                Text("Add photo")
            }
            .onChange(of: photoItem) { onChange() }
        }
    }
}

private struct FullNameField: View {
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Full Name")
                .font(.subheadline).foregroundStyle(.secondary)
            TextField("Lois Becket", text: $text)
                .textFieldStyle(SoftFieldStyle())
                .accessibilityIdentifier("signup_fullName")
        }
    }
}

private struct BirthDateField: View {
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Date of Birth")
                .font(.subheadline).foregroundStyle(.secondary)
            HStack {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .accessibilityIdentifier("signup_birthDate")
                Spacer()
                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.gray.opacity(0.25))
            )
        }
    }
}

private struct PhoneField: View {
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Phone Number")
                .font(.subheadline).foregroundStyle(.secondary)
            HStack(spacing: 8) {
                Text("🇬🇧 +44")
                    .padding(.leading, 8)
                Divider()
                TextField("(454) 726-0592", text: $text)
                    .keyboardType(.phonePad)
                    .accessibilityIdentifier("signup_phone")
            }
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.gray.opacity(0.25))
            )
        }
    }
}
