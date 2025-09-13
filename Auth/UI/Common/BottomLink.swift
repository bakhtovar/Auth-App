//
//  BottomLink.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/13/25.
//

import SwiftUI

struct BottomLink: View {
    var text: String
    var linkText: String
    var action: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(text)
            Button(action: action) {
                Text(linkText)
                    .fontWeight(.semibold)
            }
        }
        .font(.callout)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 8)
    }
}
