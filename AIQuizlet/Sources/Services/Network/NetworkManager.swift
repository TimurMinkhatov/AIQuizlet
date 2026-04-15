//
//  NetworkManager.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation
import Moya

// MARK: - NetworkManagerProtocol

protocol NetworkManagerProtocol {
    func request<T: TargetType, D: Decodable>(target: T) async throws -> D
}

// MARK: - NetworkManager

final class NetworkManager: NetworkManagerProtocol {

    func request<T: TargetType, D: Decodable>(target: T) async throws -> D {
        let provider = MoyaProvider<T>()

        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        let decodedData = try JSONDecoder().decode(D.self, from: filteredResponse.data)
                        continuation.resume(returning: decodedData)
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
