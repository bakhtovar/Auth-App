//
//  ViewModel.swift
//  AuthApp
//
//  Created by Bakhtovar Umarov on 9/13/25.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()

    deinit {
        subscriptions.cancelAll()
    }
}
