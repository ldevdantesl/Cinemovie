//
//  SearchScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 13.06.2025
//

import UIKit

protocol SearchScreenInteractorProtocol: AnyObject {
    func getRecentSearches()
    func getRecentKeywords()
}

final class SearchScreenInteractor: SearchScreenInteractorProtocol {
    weak var presenter: SearchScreenPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    
    func getRecentKeywords() {
        
    }
    
    func getRecentSearches() {
        
    }
}
