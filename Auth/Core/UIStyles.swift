//
//  UIStyles.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(RoundedRectangle(cornerRadius: 12).fill(.blue))
            .foregroundStyle(.white)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct SoftFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(.horizontal, 14).padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 12).strokeBorder(.gray.opacity(0.25)))
    }
}
