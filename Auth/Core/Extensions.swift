//
//  Extensions.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import Combine

extension Set where Element == AnyCancellable {
    mutating func cancelAll() {
        for cancellable in self {
            cancellable.cancel()
        }
        removeAll()
    }
}
