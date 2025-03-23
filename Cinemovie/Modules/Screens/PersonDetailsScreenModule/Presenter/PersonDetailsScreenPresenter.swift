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
    func didTapLogoImage(sourceID: String, sourceType: ExternalSource.SourceTypes)
    func didTapMovie(movie: Movie)
    func didTapTVSeries(series: TVSeries)
    
    func didGetPersonID(_ id: Int)
    func didGetPersonDetails(_ details: PersonDetails)
    func didGetPersonExternalSources(_ sources: ExternalSource)
    func didGetPersonMovies(_ movies: [Movie])
    func didGetPersonTVShows(_ tvShows: [TVSeries])
    func didRecieveError(_ error: Error)
}

final class PersonDetailsScreenPresenter {
    weak var view: PersonDetailsScreenViewProtocol?
    var router: PersonDetailsScreenRouterProtocol
    var interactor: PersonDetailsScreenInteractorProtocol
    
    private var personID: Int?
    private var personDetails: PersonDetails?
    private var personExternalSources: ExternalSource?
    private var personMovies: [Movie] = []
    private var personTVShows: [TVSeries] = []
    private let downloadGroup = DispatchGroup()

    init(interactor: PersonDetailsScreenInteractorProtocol, router: PersonDetailsScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension PersonDetailsScreenPresenter: PersonDetailsScreenPresenterProtocol {
    func didTapTVSeries(series: TVSeries) {
        print("SeriesID", series.id )
        router.navigateToSeries(seriesID: series.id)
    }
    
    func viewDidLoad() {
        downloadGroup.enter()
        interactor.getPersonID()
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            guard let personDetails = personDetails else { self.view?.didRecieveError("Something went wrong with person details"); return }
            guard let personExternalSources = personExternalSources else { self.view?.didRecieveError("Something went wrong with external sources"); return }
            self.view?.didGetAllPersonData(personDetails, sources: personExternalSources, movies: personMovies, tvShows: personTVShows)
        }
    }
    
    func didRecieveError(_ error: any Error) {
        view?.didRecieveError(error.localizedDescription)
    }
    
    func didGetPersonID(_ id: Int) {
        print("PersonID: \(id)")
        self.personID = id
        
        downloadGroup.enter()
        self.interactor.getPersonDetails(personID: id)
        
        downloadGroup.enter()
        self.interactor.getPersonExternalSources(personID: id)
        
        downloadGroup.enter()
        self.interactor.getPersonMovies(personID: id)
        
        downloadGroup.enter()
        self.interactor.getPersonTVShows(personID: id)
        
        downloadGroup.leave()
    }
    
    func didGetPersonDetails(_ details: PersonDetails) {
        self.personDetails = details
        downloadGroup.leave()
    }
    
    func didGetPersonExternalSources(_ sources: ExternalSource) {
        self.personExternalSources = sources
        downloadGroup.leave()
    }
    
    func didTapBackButton() {
        router.goBack()
    }
    
    func didTapLogoImage(sourceID: String, sourceType: ExternalSource.SourceTypes) {
        router.openSource(sourceID: sourceID, sourceType: sourceType)
    }
    
    func didGetPersonMovies(_ movies: [Movie]) {
        self.personMovies = movies
        downloadGroup.leave()
    }
    
    func didGetPersonTVShows(_ tvShows: [TVSeries]) {
        self.personTVShows = tvShows
        downloadGroup.leave()
    }
    
    func didTapMovie(movie: Movie) {
        router.navigateToMovie(movieID: movie.id)
    }
}
