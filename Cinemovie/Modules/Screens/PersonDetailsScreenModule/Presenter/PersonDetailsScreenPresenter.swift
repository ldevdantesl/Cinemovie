//
//  PersonDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit

protocol PersonDetailsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    func didTapBackButton()
    
    func didGetPersonDetails(_ details: PersonDetails)
    func didRecieveError(_ error: Error)
}

final class PersonDetailsScreenPresenter {
    weak var view: PersonDetailsScreenViewProtocol?
    var router: PersonDetailsScreenRouterProtocol
    var interactor: PersonDetailsScreenInteractorProtocol

    init(interactor: PersonDetailsScreenInteractorProtocol, router: PersonDetailsScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension PersonDetailsScreenPresenter: PersonDetailsScreenPresenterProtocol {
    func viewDidLoad() {
        interactor.getPersonDetails()
    }
    
    func didRecieveError(_ error: any Error) {
        view?.didRecieveError(error.localizedDescription)
    }
    
    func didGetPersonDetails(_ details: PersonDetails) {
        view?.didGetPersonDetails(details)
    }
    
    func didTapBackButton() {
        router.goBack()
    }
}
