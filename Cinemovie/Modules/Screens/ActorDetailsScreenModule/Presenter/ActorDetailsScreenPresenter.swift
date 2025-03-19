//
//  ActorDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 19.03.2025
//

protocol ActorDetailsScreenPresenterProtocol: AnyObject {
}

final class ActorDetailsScreenPresenter {
    weak var view: ActorDetailsScreenViewProtocol?
    var router: ActorDetailsScreenRouterProtocol
    var interactor: ActorDetailsScreenInteractorProtocol

    init(interactor: ActorDetailsScreenInteractorProtocol, router: ActorDetailsScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension ActorDetailsScreenPresenter: ActorDetailsScreenPresenterProtocol {
}
