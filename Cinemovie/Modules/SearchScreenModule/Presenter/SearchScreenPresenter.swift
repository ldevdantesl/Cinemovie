//
//  SearchScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol SearchScreenPresenterProtocol: AnyObject {
}

final class SearchScreenPresenter {
    weak var view: SearchScreenViewProtocol?
    var router: SearchScreenRouterProtocol
    var interactor: SearchScreenInteractorProtocol

    init(interactor: SearchScreenInteractorProtocol, router: SearchScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension SearchScreenPresenter: SearchScreenPresenterProtocol {
}
