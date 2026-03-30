//
//  TVSeriesDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit

protocol TVSeriesDetailsScreenPresenterProtocol: AnyObject {
    // MARK: - LIFECYCLE
    func viewDidLoad()
    
    // MARK: - USER INITIATED
    func didTapMedia(media: MediaProtocol)
    func didTapShareButton()
    func didTapRateButton()
    func didTapBackButton()
    func didTapTooltipView(sendedBy view: UIView, withMessage text: String)
    func didTapHomepage(homepage: String)
    func didTapFavoriteButton(adding: Bool)
    func didTapWatchlistButton(adding: Bool)
    func didSelectActor(_ actor: Cast)
    func didSelectSeason(_ season: TVSeason)
    func didTapAddToList()
    
    // MARK: - PROGRAMMATIC
    func didGetTVSeriesDetails(_ details: TVSeriesDetails)
    func didGetTVSeriesCast(_ cast: [Cast], crew: [Cast])
    func didGetTVSeriesVideos(_ videos: [Video])
    func didGetTVSeriesReviews(_ reviews: [Review])
    func didGetTVSeriesRecommends(_ series: [TVSeries])
    func didGetTVSeasonDetails(_ details: TVSeasonDetails)
    func didGetTVSeriesAccountStates(_ accountStates: MediaAccountStatesAPIResponse)
    func didGetUserLists(_ userLists: [UserList])
    
    func didAddOrRemoveFromWatchlist(message: String)
    func didAddOrRemoveFromFavorites(message: String)
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: Error)
    
    // MARK: - PROPERTIES
    var userLists: [UserList] { get }
}

final class TVSeriesDetailsScreenPresenter {
    // MARK: - VIPER
    weak var view: TVSeriesDetailsScreenViewProtocol?
    var router: TVSeriesDetailsScreenRouterProtocol
    var interactor: TVSeriesDetailsScreenInteractorProtocol
    
    // MARK: - INJECTED PROPERTIES
    private var seriesID: Int
    private var authContext: AuthContextProtocol
    
    // MARK: - PROPERTIES
    private var downloadGroup = DispatchGroup()
    private var seriesDetails: TVSeriesDetails?
    private var seriesCast: [Cast] = []
    private var seriesCrew: [Cast] = []
    private var seriesVideos: [Video] = []
    private var seriesRecommends: [TVSeries] = []
    private var seriesSimilars: [TVSeries] = []
    private var seriesReviews: [Review] = []
    var userLists: [UserList] = []
    private var seriesAccountStates: MediaAccountStatesAPIResponse = .empty

    init(seriesID: Int, authContext: AuthContextProtocol, interactor: TVSeriesDetailsScreenInteractorProtocol, router: TVSeriesDetailsScreenRouterProtocol) {
        self.seriesID = seriesID
        self.interactor = interactor
        self.router = router
        self.authContext = authContext
    }
}

extension TVSeriesDetailsScreenPresenter: TVSeriesDetailsScreenPresenterProtocol {
    // MARK: - LIFECYCLE
    func viewDidLoad() {
        print("SeriesID: ", seriesID)
        downloadGroup.enter()
        interactor.getTVSeriesDetails(seriesID: seriesID)
        
        downloadGroup.enter()
        interactor.getTVSeriesCast(seriesID: seriesID)
        
        downloadGroup.enter()
        interactor.getTVSeriesReviews(seriesID: seriesID)
        
        downloadGroup.enter()
        interactor.getTVSeriesRecommendations(seriesID: seriesID)
        
        if !authContext.isGuest {
            downloadGroup.enter()
            interactor.getTVSeriesAccountStates(seriesID: seriesID)
            
            downloadGroup.enter()
            interactor.getUserLists()
        }
        
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self, let details = self.seriesDetails else { return }
            self.view?.didGetAllTVSeriesData(
                details, cast: seriesCast, crew: seriesCrew,
                videos: seriesVideos, reviews: seriesReviews,
                recommends: seriesRecommends, accountStates: seriesAccountStates
            )
        }
    }
    
    // MARK: - USER INITIATED
    func didTapMedia(media: MediaProtocol) {
        switch media {
        case let movie as Movie: router.navigateToMovie(movie: movie)
        case let series as TVSeries: router.navigateToAnotherTVSeries(series: series)
        default: break
        }
    }
    
    func didTapRateButton() {
        print("DID tap rate button")
    }
    
    func didTapShareButton() {
        guard let details = self.seriesDetails else { return }
        router.presentShareView(details: details)
    }
    
    func didTapBackButton() {
        router.goBack()
    }
    
    func didTapTooltipView(sendedBy view: UIView, withMessage text: String) {
        router.showTooltipView(sendedBy: view, message: text)
    }
    
    func didTapHomepage(homepage: String) {
        router.openHomepage(homepage: homepage)
    }
    
    func didSelectActor(_ actor: Cast) {
        router.showActorPopUp(actor: actor)
    }
    
    func didSelectSeason(_ season: TVSeason) {
        interactor.getTVSeasonDetails(seriesID: seriesID, seasonNumber: season.seasonNumber)
    }
    
    func didTapFavoriteButton(adding: Bool) {
        interactor.addOrRemoveInFavorites(seriesID: seriesID, adding: adding)
    }
    
    func didTapWatchlistButton(adding: Bool) {
        interactor.addOrRemoveInWatchlist(seriesID: seriesID, adding: adding)
    }
    
    func didAddOrRemoveFromFavorites(message: String) {
        print("Successfully done operation: \(message)")
    }
    
    func didAddOrRemoveFromWatchlist(message: String) {
        print("Successfully done operation: \(message)")
    }
    
    func didTapAddToList() {
        router.presentAddToListModal(seriesID: seriesID)
    }
    
    // MARK: - PROGRAMMATIC
    func didGetTVSeriesCast(_ cast: [Cast], crew: [Cast]) {
        self.seriesCast = cast
        self.seriesCrew = crew
        downloadGroup.leave()
    }
    
    func didGetTVSeriesVideos(_ videos: [Video]) {
        self.seriesVideos = videos
        downloadGroup.leave()
    }
    
    func didGetTVSeriesDetails(_ details: TVSeriesDetails) {
        self.seriesDetails = details
        downloadGroup.leave()
    }
    
    func didGetTVSeriesReviews(_ reviews: [Review]) {
        self.seriesReviews = reviews
        downloadGroup.leave()
    }
    
    func didGetTVSeriesRecommends(_ series: [TVSeries]) {
        self.seriesRecommends = series.removingMediaWithoutPoster().sortByPopularity()
        downloadGroup.leave()
    }
    
    func didGetTVSeasonDetails(_ details: TVSeasonDetails) {
        router.showSeasonPopUp(seasonDetails: details)
    }

    func didGetTVSeriesAccountStates(_ accountStates: MediaAccountStatesAPIResponse) {
        self.seriesAccountStates = accountStates
        downloadGroup.leave()
    }
    
    func didGetUserLists(_ userLists: [UserList]) {
        self.userLists = userLists
        downloadGroup.leave()
    }
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: any Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecieveError(error.localizedDescription)
        }
    }
}
