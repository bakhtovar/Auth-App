//
//  OfflineBanner.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import SwiftUI
import Resolver

struct ToastBanner: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.callout)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
    }
}

struct ToastBannerModifier: ViewModifier {
    @InjectedObject var banner: ToastBannerManager

    func body(content: Content) -> some View {
        ZStack {
            content
            if let msg = banner.message {
                VStack {
                    ToastBanner(text: msg)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    Spacer()
                }
                .zIndex(1)
            }
        }
        .animation(.easeInOut, value: banner.message)
    }
}

extension View {
    func toastBanner() -> some View {
        self.modifier(ToastBannerModifier())
    }
}
