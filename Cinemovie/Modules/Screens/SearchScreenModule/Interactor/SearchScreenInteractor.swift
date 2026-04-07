//
//  SearchScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 13.06.2025
//

import UIKit

protocol SearchScreenInteractorProtocol: AnyObject {
    func didSearch(searchText: String)
}

final class SearchScreenInteractor: SearchScreenInteractorProtocol {
    weak var presenter: SearchScreenPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    
    func didSearch(searchText: String) {
        Task {
            do {
                let movies = try await networkService.search.getMovieSearchResults(query: searchText, page: 1)
                let series = try await networkService.search.getTVSeriesSearchResults(query: searchText, page: 1)
                await MainActor.run {
                    presenter?.didReceiveSearchResults(movies + series)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didRecieveError(error)
                }
            }
        }
    }
}
