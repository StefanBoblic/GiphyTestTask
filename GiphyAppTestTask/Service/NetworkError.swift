//
//  NetworkError.swift
//  giphyAppTestTask
//
//  Created by Stefan Boblic on 21.04.2023.
//

import Foundation

public enum NetworkError: LocalizedError {
    case badRequest
    case unauthorized
    case jsonConversionFailure

    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return "The server returned an invalid response."
        case .unauthorized:
            return "Unauthorized."
        case .jsonConversionFailure:
            return "Error converting JSON"
        }
    }
}
