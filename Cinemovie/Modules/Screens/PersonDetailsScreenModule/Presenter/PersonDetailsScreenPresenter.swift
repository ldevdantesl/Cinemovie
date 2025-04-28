//
//  PersonDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit

protocol PersonDetailsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    // MARK: - USER INITIATED
    func didTapBackButton()
    func didTapLogoImage(sourceID: String, sourceType: SourceTypes)
    func didTapMedia(media: any Media)
    
    // MARK: - PROGRAMMATIC
    func didGetPersonID(_ id: Int)
    func didGetPersonDetails(_ details: PersonDetails)
    func didGetPersonExternalSources(_ sources: ExternalSource)
    func didGetPersonMovies(_ movies: [Movie])
    func didGetPersonTVShows(_ tvShows: [TVSeries])
    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: Error)
}

final class PersonDetailsScreenPresenter {
    weak var view: PersonDetailsScreenViewProtocol?
    var router: PersonDetailsScreenRouterProtocol
    var interactor: PersonDetailsScreenInteractorProtocol
    
    private let downloadGroup = DispatchGroup()
    private let creditID: String?
    private var personID: Int?
    
    private var personDetails: PersonDetails?
    private var personExternalSources: ExternalSource?
    private var personMovies: [Movie] = []
    private var personTVSeries: [TVSeries] = []

    init(creditID: String, interactor: PersonDetailsScreenInteractorProtocol, router: PersonDetailsScreenRouterProtocol) {
        self.creditID = creditID
        self.personID = nil
        self.interactor = interactor
        self.router = router
    }
    
    init(personID: Int, interactor: PersonDetailsScreenInteractorProtocol, router: PersonDetailsScreenRouterProtocol) {
        print("PersonID: ", personID)
        self.creditID = nil
        self.personID = personID
        self.interactor = interactor
        self.router = router
    }
}

extension PersonDetailsScreenPresenter: PersonDetailsScreenPresenterProtocol {
    func viewDidLoad() {
        defer {
            downloadGroup.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                guard let personDetails = personDetails else { self.view?.didRecieveError("Something went wrong with person details"); return }
                guard let personExternalSources = personExternalSources else { self.view?.didRecieveError("Something went wrong with external sources"); return }
                self.view?.didGetAllPersonData(personDetails, sources: personExternalSources, movies: personMovies, tvSeries: personTVSeries)
            }
        }
        
        guard let personID = personID else {
            let creditID = self.creditID ?? ""
            downloadGroup.enter()
            interactor.getPersonID(creditID: creditID)
            return
        }
        
        downloadGroup.enter()
        self.interactor.getPersonDetails(personID: personID)
        
        downloadGroup.enter()
        self.interactor.getPersonExternalSources(personID: personID)
        
        downloadGroup.enter()
        self.interactor.getPersonMovies(personID: personID)
        
        downloadGroup.enter()
        self.interactor.getPersonTVShows(personID: personID)
    }
    
    // MARK: - USER INITIATED
    func didTapBackButton() {
        print("Presenter Did Tap backbutton called")
        router.goBack()
    }
    
    func didTapLogoImage(sourceID: String, sourceType: SourceTypes) {
        router.openSource(sourceID: sourceID, sourceType: sourceType)
    }
    
    func didTapMedia(media: any Media) {
        switch media {
        case let movie as Movie: router.navigateToMovie(movieID: movie.id)
        case let series as TVSeries: router.navigateToSeries(seriesID: series.id)
        default: break
        }
    }
    
    // MARK: - PROGRAMMATIC
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
    
    func didGetPersonMovies(_ movies: [Movie]) {
        self.personMovies = movies.removingMediaWithoutPoster().filteringByMinimumPopularity()
        downloadGroup.leave()
    }
    
    func didGetPersonTVShows(_ tvShows: [TVSeries]) {
        let talkGenreId = GenreHelper.shared.getSeriesGenreID(for: .talk)
        let realityGenreID = GenreHelper.shared.getSeriesGenreID(for: .reality)
        let warPoliticsGenreId = GenreHelper.shared.getSeriesGenreID(for: .warPolitics)
        let newsGenreId = GenreHelper.shared.getSeriesGenreID(for: .news)
        self.personTVSeries = tvShows.filter { !$0.genreIDS.isEmpty }.filter {
            !$0.genreIDS.contains(where: { $0 == talkGenreId || $0 == realityGenreID || $0 == warPoliticsGenreId || $0 == newsGenreId })
        }.removingMediaWithoutPoster().sortByPopularity()
        downloadGroup.leave()
    }
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: any Error) {
        view?.didRecieveError(error.localizedDescription)
    }
}
