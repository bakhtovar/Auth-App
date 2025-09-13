//
//  NetworkHandle.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import Combine
import Network

import Combine
import Network
import SwiftUI

protocol NetworkMonitoring {
    var isReachable: Bool { get }
    var isReachablePublisher: AnyPublisher<Bool, Never> { get }
}

final class NetworkMonitor: ObservableObject, NetworkMonitoring {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    @Published private(set) var reachable: Bool = true

    var isReachablePublisher: AnyPublisher<Bool, Never> {
        $reachable.eraseToAnyPublisher()
    }

    var isReachable: Bool { reachable }

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.reachable = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
