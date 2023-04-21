//
//  HomeViewModel.swift
//  giphyAppTestTask
//
//  Created by Stefan Boblic on 21.04.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    func fetchGIFs(with offset: Int) async throws -> ([GiphyData]?, Pagenation?, String?)
}

class HomeViewModel: HomeViewModelProtocol {

    let networkService: NetworkWorkerProtocol

    init(networkService: NetworkWorkerProtocol) {
        self.networkService = networkService
    }

    func fetchGIFs(with offset: Int) async throws -> ([GiphyData]?, Pagenation?, String?) {
        do {
            let result = try await networkService.sendRequest(type: GiphyListModel.self, urlRequest: TrendingRouter.fetchGIFs.createURLRequest(offset: offset))
            return (result.data, result.pagination, nil)
        } catch {
            return (nil, nil, error.localizedDescription)
        }
    }
}
