//
//  MainView.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: MainViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text(viewModel.greeting).font(.title2)
            Text("Главный экран").foregroundStyle(.secondary)

            Button("Выйти") {
                appState.currentUser = nil
                appState.route = .login
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    MainView(viewModel: .init(user: .mock()))
        .environmentObject(AppState())
}

