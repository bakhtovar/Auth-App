//
//  PasswordField.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/13/25.
//

import SwiftUI

struct PasswordField: View {
    @Binding var text: String
    @Binding var isVisible: Bool
    var title: String = "Password"
    var identifier: String = "password_field"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                if isVisible {
                    TextField("••••••••", text: $text)
                        .textContentType(.password)
                        .textInputAutocapitalization(.never)
                } else {
                    SecureField("••••••••", text: $text)
                        .textContentType(.password)
                        .accessibilityIdentifier(identifier)
                }
                
                Button { isVisible.toggle() } label: {
                    Image(systemName: isVisible ? "eye" : "eye.slash")
                        .foregroundStyle(.black)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.gray.opacity(0.25))
            )
            .frame(height: 46)
        }
    }
}
