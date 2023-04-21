//
//  HomeViewModel.swift
//  giphyAppTestTask
//
//  Created by Stefan Boblic on 21.04.2023.
//

import Foundation

struct GiphyResponse {
    let giphyData: [GiphyData]?
    let pagination: Pagenation?
    let error: String?
}

protocol HomeViewModelProtocol {
    func fetchGIFs(with offset: Int) async throws -> GiphyResponse
}

class HomeViewModel: HomeViewModelProtocol {

    let networkService: NetworkWorkerProtocol

    init(networkService: NetworkWorkerProtocol) {
        self.networkService = networkService
    }

    func fetchGIFs(with offset: Int) async throws -> GiphyResponse {
        do {
            let result = try await networkService.sendRequest(type: GiphyListModel.self, urlRequest: TrendingRouter.fetchGIFs.createURLRequest(offset: offset))
            return GiphyResponse(giphyData: result.data, pagination: result.pagination, error: nil)
        } catch {
            return GiphyResponse(giphyData: nil, pagination: nil, error: error.localizedDescription)
        }
    }
}
