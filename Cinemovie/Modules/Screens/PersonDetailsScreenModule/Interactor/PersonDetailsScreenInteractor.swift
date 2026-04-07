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
    func getPersonImages(personID: Int)
}

final class PersonDetailsScreenInteractor: PersonDetailsScreenInteractorProtocol {
    weak var presenter: PersonDetailsScreenPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getPersonID(creditID: String) {
        Task {
            do {
                let result = try await networkService.person.getPersonID(creditID: creditID)
                self.presenter?.didGetPersonID(result.person.id)
            } catch {
                presenter?.didRecieveError(error)
            }
        }
    }
    
    func getPersonDetails(personID: Int) {
        Task {
            do {
                let result = try await networkService.person.details(personID: personID)
                self.presenter?.didGetPersonDetails(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getPersonExternalSources(personID: Int) {
        Task {
            do {
                let result = try await networkService.person.externalSources(personID: personID)
                self.presenter?.didGetPersonExternalSources(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getPersonMovies(personID: Int) {
        Task {
            do {
                let result = try await networkService.person.movieCredits(personID: personID)
                self.presenter?.didGetPersonMovies(result.cast)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getPersonTVShows(personID: Int) {
        Task {
            do {
                let result = try await networkService.person.tvCredits(personID: personID)
                self.presenter?.didGetPersonTVShows(result.cast)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getPersonImages(personID: Int) {
        Task {
            do {
                let result = try await networkService.person.images(personID: personID)
                self.presenter?.didGetPersonImages(result)
            } catch {
                self.presenter?.didGetPersonImages([])
            }
        }
    }
}
