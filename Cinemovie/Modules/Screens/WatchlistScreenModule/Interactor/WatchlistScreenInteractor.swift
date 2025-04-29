//
//  WatchlistScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol WatchlistScreenInteractorProtocol: AnyObject {}

final class WatchlistScreenInteractor: WatchlistScreenInteractorProtocol {
    weak var presenter: WatchlistScreenPresenterProtocol?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService? = nil) {
        self.tmdbService = tmdbService
    }
}
