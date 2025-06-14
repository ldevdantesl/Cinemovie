//
//  SearchScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 13.06.2025
//

import UIKit

protocol SearchScreenInteractorProtocol: AnyObject { }

final class SearchScreenInteractor: SearchScreenInteractorProtocol {
    weak var presenter: SearchScreenPresenterProtocol?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
}
