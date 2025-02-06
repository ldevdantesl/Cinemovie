//
//  HomeScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol HomeScreenPresenterProtocol: AnyObject {
    // MARK: - STARTING
    func viewDidLoaded()
    
    // MARK: - FINISHING
    func didDownloadPopularMovies(queryMovies: [QueryMovie])
    func didDownloadPopularMovies(withError error: NetworkError)
}

final class HomeScreenPresenter {
    weak var view: HomeScreenViewProtocol?
    var router: HomeScreenRouterProtocol
    var interactor: HomeScreenInteractorProtocol

    init(interactor: HomeScreenInteractorProtocol, router: HomeScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension HomeScreenPresenter: HomeScreenPresenterProtocol {
    // MARK: - STARTING
    func viewDidLoaded() {
        interactor.downloadPopularMovies()
    }

    // MARK: - FINISHING
    func didDownloadPopularMovies(queryMovies: [QueryMovie]) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecieveMovies(queryMovies)
        }
    }
    
    func didDownloadPopularMovies(withError error: NetworkError) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecieveError(error.localizedDescription)
        }
    }
}
