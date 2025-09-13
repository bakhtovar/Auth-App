//
//  EmailField.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/13/25.
//

import SwiftUI

struct EmailField: View {
    @Binding var text: String
    var placeholder: String = "name@example.com"
    var identifier: String = "email_field"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Email")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            TextField(placeholder, text: $text)
                .accessibilityIdentifier(identifier)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textFieldStyle(SoftFieldStyle())
                .frame(height: 46)
        }
    }
}
