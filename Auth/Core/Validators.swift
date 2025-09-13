//
//  Validators.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import Foundation

enum Validators {
    static func isValidEmail(_ s: String) -> Bool {
        s.range(of: #"^\S+@\S+\.\S+$"#, options: .regularExpression) != nil
    }
    static func isValidPassword(_ s: String) -> Bool { s.count >= 6 }
}
