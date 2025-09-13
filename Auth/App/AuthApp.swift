//
//  AuthApp.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import SwiftUI
import Resolver
 

@main
struct TOApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var net: NetworkMonitor

    init() {
        DI.setup()
        _net = StateObject(wrappedValue: Resolver.resolve())
    }

    var body: some Scene {
        WindowGroup {
            RouterView()
                .environmentObject(appState)
                .environmentObject(net)
                .toastBanner()
                .onChange(of: net.isReachable) { oldValue, isReachable in
                    if !isReachable {
                        Resolver.resolve(ToastBannerManager.self)
                            .show("⚠️ Нет подключения к сети")
                    }
                }
        }
    }
}
