//
//  PersonDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit

protocol PersonDetailsScreenInteractorProtocol: AnyObject {
    func getPersonDetails()
}

final class PersonDetailsScreenInteractor: PersonDetailsScreenInteractorProtocol {
    weak var presenter: PersonDetailsScreenPresenterProtocol?
    weak var tmdbService: TMDBService?
    private let creditID: String
    
    init(creditID: String, tmdbService: TMDBService?) {
        self.creditID = creditID
        self.tmdbService = tmdbService
    }
    
    func getPersonDetails() {
        tmdbService?.getPersonID(creditID: creditID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response): getPersonDetails(personID: response.person.id)
            case .failure(let failure): presenter?.didRecieveError(failure)
            }
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func getPersonDetails(personID: Int) {
        tmdbService?.getPersonDetails(personID: personID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let details): presenter?.didGetPersonDetails(details)
            case .failure(let failure): presenter?.didRecieveError(failure)
            }
        }
    }
}
