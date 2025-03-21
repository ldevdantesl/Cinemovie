//
//  PersonDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit

protocol PersonDetailsScreenInteractorProtocol: AnyObject {
    func getPersonID()
    func getPersonDetails(personID: Int)
    func getPersonExternalSources(personID: Int)
}

final class PersonDetailsScreenInteractor: PersonDetailsScreenInteractorProtocol {
    weak var presenter: PersonDetailsScreenPresenterProtocol?
    weak var tmdbService: TMDBService?
    private let creditID: String
    
    init(creditID: String, tmdbService: TMDBService?) {
        self.creditID = creditID
        self.tmdbService = tmdbService
    }
    
    func getPersonID() {
        tmdbService?.getPersonID(creditID: creditID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response): presenter?.didGetPersonID(response.person.id)
            case .failure(let failure): presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getPersonDetails(personID: Int) {
        tmdbService?.getPersonDetails(personID: personID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetPersonDetails(success)
            case .failure(let failure): presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getPersonExternalSources(personID: Int) {
        tmdbService?.getPersonExternalSources(personID: personID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetPersonExternalSources(success)
            case .failure(let failure): presenter?.didRecieveError(failure)
            }
        }
    }
}
