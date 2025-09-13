//
//  APIClient.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/12/25.
//

import Foundation
import Combine

protocol APIClienting {
    func get(url: URL) -> AnyPublisher<Data, Error>
}

struct APIClient: APIClienting {
    func get(url: URL) -> AnyPublisher<Data, Error> {
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: req)
            .tryMap { data, resp in
                guard let http = resp as? HTTPURLResponse,
                      (200..<300).contains(http.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}
