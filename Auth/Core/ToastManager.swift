//
//  ToastManager.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import SwiftUI
import Combine

final class ToastBannerManager: ObservableObject {
    @Published var message: String? = nil

    func show(_ text: String, duration: TimeInterval = 3.0) {
        message = text
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                self.message = nil
            }
        }
    }
}
