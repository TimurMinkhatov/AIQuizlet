//
//  NetworkManager.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation
import Moya

protocol NetworkManagerProtocol {
    func request<T: Decodable>(target: API) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
    private let provider = MoyaProvider<API>()
    
    func request<T: Decodable>(target: API) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        
                        let decodeData = try JSONDecoder().decode(T.self, from: filteredResponse.data)
                        continuation.resume(returning: decodeData)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
