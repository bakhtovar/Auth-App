//
//  PrimaryActionButton.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/13/25.
//

import SwiftUI

struct PrimaryActionButton: View {
    var title: String
    var isLoading: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity)
            } else {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                    )
            }
        }
        .frame(height: 52)
    }
}
