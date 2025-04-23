//
//  WatchlistScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol WatchlistScreenPresenterProtocol: AnyObject { }

final class WatchlistScreenPresenter {
    weak var view: WatchlistScreenViewProtocol?
    var router: WatchlistScreenRouterProtocol
    var interactor: WatchlistScreenInteractorProtocol

    init(interactor: WatchlistScreenInteractorProtocol, router: WatchlistScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension WatchlistScreenPresenter: WatchlistScreenPresenterProtocol { }
