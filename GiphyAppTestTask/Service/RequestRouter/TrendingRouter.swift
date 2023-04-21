//
//  TrendingRouter.swift
//  giphyAppTestTask
//
//  Created by Stefan Boblic on 21.04.2023.
//

import Foundation

enum TrendingRouter: BaseRouter {

    case fetchGIFs

    var path: String {
        switch self {
        case .fetchGIFs:
            return "/v1/gifs/trending"
        }
    }

    var method: HttpMethod {
        switch self {
        case .fetchGIFs:
            return .GET
        }
    }

    var httpBody: Data? {
        switch self {
        case .fetchGIFs:
            return nil
        }
    }

    var httpHeader: [HttpHeader]? {
        switch self {
        case .fetchGIFs:
            return nil
        }
    }
}
