//
//  PersonDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit

protocol PersonDetailsScreenInteractorProtocol: AnyObject {
    func getPersonID(creditID: String)
    func getPersonDetails(personID: Int)
    func getPersonExternalSources(personID: Int)
    func getPersonMovies(personID: Int)
    func getPersonTVShows(personID: Int)
}

final class PersonDetailsScreenInteractor: PersonDetailsScreenInteractorProtocol {
    weak var presenter: PersonDetailsScreenPresenterProtocol?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func getPersonID(creditID: String) {
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
    
    func getPersonMovies(personID: Int) {
        tmdbService?.getPersonMovieCredits(personID: personID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetPersonMovies(success.cast)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getPersonTVShows(personID: Int) {
        tmdbService?.getPersonTVShowCredits(personID: personID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetPersonTVShows(success.cast)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
}
