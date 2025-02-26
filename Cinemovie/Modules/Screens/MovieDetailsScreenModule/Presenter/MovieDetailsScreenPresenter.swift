//
//  MovieDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

protocol MovieDetailsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    func didGetMovieDetails(_ details: MovieDetails)
    func didRecieveError(_ error: String)
}

final class MovieDetailsScreenPresenter {
    weak var view: MovieDetailsScreenViewProtocol?
    var router: MovieDetailsScreenRouterProtocol
    var interactor: MovieDetailsScreenInteractorProtocol

    init(interactor: MovieDetailsScreenInteractorProtocol, router: MovieDetailsScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension MovieDetailsScreenPresenter: MovieDetailsScreenPresenterProtocol {
    func viewDidLoad() {
        interactor.getMovieDetails()
    }
    
    func didRecieveError(_ error: String) {
        view?.didRecieveError(error)
    }
    
    func didGetMovieDetails(_ details: MovieDetails) {
        view?.didGetMovieDetails(details)
    }
}
