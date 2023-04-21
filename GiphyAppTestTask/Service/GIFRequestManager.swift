//
//  GIFRequestManager.swift
//  giphyAppTestTask
//
//  Created by Stefan Boblic on 21.04.2023.
//

import Foundation

protocol NetworkWorkerProtocol {
    func sendRequest<T: Decodable>(type: T.Type, urlRequest: URLRequest) async throws -> T
}

final class NetworkWorker: NetworkWorkerProtocol {

    private let urlSession: URLSession

    init(session: URLSession = URLSession.shared) {
        urlSession = session
    }

    func sendRequest<T: Decodable>(type: T.Type, urlRequest: URLRequest) async throws -> T {
        let (data, response) = try await urlSession.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.badRequest
        }
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkError.jsonConversionFailure
        }
    }
}
