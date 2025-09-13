//
//  AuthRepositoryImpl.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import Foundation
import Combine

//final class AuthRepositoryImpl: AuthRepository {
//    private let baseURL = URL(string: "https://API.com")! /
//
//    func login(email: String, password: String) -> AnyPublisher<UserProfile, Error> {
//        let endpoint = baseURL.appendingPathComponent("/auth/login")
//        var request = URLRequest(url: endpoint)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let body = LoginRequest(email: email, password: password)
//        request.httpBody = try? JSONEncoder().encode(body)
//
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { data, response -> Data in
//                guard let http = response as? HTTPURLResponse,
//                      (200..<300).contains(http.statusCode) else {
//                    throw AuthError.invalidCredentials
//                }
//                return data
//            }
//            .decode(type: LoginResponse.self, decoder: .iso8601Decoder)
//            .map { dto in
//                UserProfile(id: UUID(), name: dto.name, email: dto.email)
//            }
//            .eraseToAnyPublisher()
//    }
//}
