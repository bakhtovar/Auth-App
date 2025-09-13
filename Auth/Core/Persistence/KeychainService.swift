//
//  KeychainService.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import Foundation
import CryptoKit

protocol KeychainServicing {
    func savePasswordHash(email: String, password: String)
    func verify(email: String, password: String) -> Bool
    func setCurrentEmail(_ email: String?)
    func currentEmail() -> String?
}

import Foundation
import Security
import CryptoKit

final class KeychainService: KeychainServicing {
    private let service = "AuthApp.Keychain"

    func savePasswordHash(email: String, password: String) {
        let hash = Self.sha256(password)
        let data = Data(hash.utf8)

        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : email,
            kSecValueData as String   : data
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("❌ [Keychain] Save failed: \(status)")
        }
    }

    func verify(email: String, password: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : email,
            kSecReturnData as String  : true,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else {
            return false
        }

        let stored = String(data: data, encoding: .utf8)
        return stored == Self.sha256(password)
    }

    func setCurrentEmail(_ email: String?) {
        UserDefaults.standard.set(email, forKey: "currentEmail")
    }

    func currentEmail() -> String? {
        UserDefaults.standard.string(forKey: "currentEmail")
    }

    // MARK: - SHA256
    private static func sha256(_ s: String) -> String {
        let digest = SHA256.hash(data: Data(s.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
