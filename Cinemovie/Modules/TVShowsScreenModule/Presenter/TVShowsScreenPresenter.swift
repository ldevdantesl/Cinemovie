//
//  TVShowsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol TVShowsScreenPresenterProtocol: AnyObject {
}

final class TVShowsScreenPresenter {
    weak var view: TVShowsScreenViewProtocol?
    var router: TVShowsScreenRouterProtocol
    var interactor: TVShowsScreenInteractorProtocol

    init(interactor: TVShowsScreenInteractorProtocol, router: TVShowsScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension TVShowsScreenPresenter: TVShowsScreenPresenterProtocol {
}
