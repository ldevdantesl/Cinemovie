//
//  SplashScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol SplashScreenPresenterProtocol: AnyObject {
    func viewDidLoaded()
}

final class SplashScreenPresenter {
    weak var view: SplashScreenViewProtocol?
    var router: SplashScreenRouterProtocol
    var interactor: SplashScreenInteractorProtocol

    init(interactor: SplashScreenInteractorProtocol, router: SplashScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension SplashScreenPresenter: SplashScreenPresenterProtocol {
    func viewDidLoaded() { }
}
