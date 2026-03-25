//
//  MovieDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit

protocol MovieDetailsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()

    // MARK: - USER INITIATED
    func didTapMedia(media: MediaProtocol)
    func didTapIMDBImage()
    func didTapShareButton()
    func didTapRateButton()
    func didTapBackButton()
    func didSelectActor(_ actor: Cast)
    func didTapToSubDetails(sendedBy view: UIView, message: String)
    func didTapAddToWatchlist(adding: Bool)
    func didTapFavoriteButton(adding: Bool)
    func didTapAddToList()
    
    // MARK: - PROGRAMMATIC
    func didGetMovieDetails(_ details: MovieDetails)
    func didGetMovieCast(cast: [Cast], crew: [Cast])
    func didGetMovieRecommendations(queryMovies: [Movie])
    func didGetMovieVideos(videos: [Video])
    func didGetMovieReviews(_ reviews: [Review])
    func didGetMovieBelongsToCollectionDetails(_ details: BelongsToCollectionDetails)
    func didGetMovieAccountStates(_ accountStates: MediaAccountStatesAPIResponse)
    func didGetUserLists(_ userLists: [UserList])
    
    // MARK: - USER INITIATED
    func didAddToWatchlist(_ message: String)
    func didAddToFavorite(_ message: String)
    
    // MARK: - ERROR
    func didRecieveError(_ error: String, goesBack: Bool)
    
    // MARK: - PROPERTIES
    var userLists: [UserList] { get }
}

final class MovieDetailsScreenPresenter {
    // MARK: - VIPER
    weak var view: MovieDetailsScreenViewProtocol?
    var router: MovieDetailsScreenRouterProtocol
    var interactor: MovieDetailsScreenInteractorProtocol
    
    // MARK: - PROPERTIES
    private let movieID: Int
    private let dispatchGroup = DispatchGroup()
    
    private var movieDetails: MovieDetails?
    private var movieVideos: [Video] = []
    private var movieCast: [Cast] = []
    private var movieCrew: [Cast] = []
    private var movieSimilars: [Movie] = []
    private var movieReviews: [Review] = []
    private var movieRecommends: [Movie] = []
    private var belongsToCollectionDetails: BelongsToCollectionDetails?
    var userLists: [UserList] = []
    private var movieAccountStates: MediaAccountStatesAPIResponse = .empty

    init(movieID: Int, interactor: MovieDetailsScreenInteractorProtocol, router: MovieDetailsScreenRouterProtocol) {
        self.movieID = movieID
        self.interactor = interactor
        self.router = router
    }
}

extension MovieDetailsScreenPresenter: MovieDetailsScreenPresenterProtocol {
    // MARK: - LIFECYCLE
    func viewDidLoad() {
        print("MovieID: ", movieID)
        dispatchGroup.enter()
        interactor.getMovieDetails(movieID: movieID)
        
        dispatchGroup.enter()
        interactor.getMovieCast(movieID: movieID)
        
        dispatchGroup.enter()
        interactor.getMovieRecommendations(movieID: movieID)
        
        dispatchGroup.enter()
        interactor.getMovieVideos(movieID: movieID)
        
        dispatchGroup.enter()
        interactor.getMovieReviews(movieID: movieID)
        
        dispatchGroup.enter()
        interactor.getMovieAccountStates(movieID: movieID)
        
        dispatchGroup.enter()
        interactor.getUserLists()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self, let details = self.movieDetails else { return }
            self.view?.didDownloadAllData(
                details: details, videos: movieVideos,
                cast: movieCast, crew: movieCrew,
                recommended: movieRecommends, reviews: movieReviews,
                belongsToCollectionDetails: belongsToCollectionDetails,
                accountStates: movieAccountStates
            )
        }
    }
    
    // MARK: - USER INITIATED
    func didTapMedia(media: MediaProtocol) {
        switch media {
        case let movie as Movie: router.navigateToAnotherMovie(movie: movie)
        case let series as TVSeries: router.navigateToSeries(series: series)
        default: break
        }
    }
    
    func didTapIMDBImage() {
        guard let imdbURL = URLHelper.getImdbURL(withID: movieDetails?.imdbID) else { return }
        AppOpener.openURL(imdbURL)
    }
    
    func didTapRateButton() {
        print("Did tap rate button")
    }
    
    func didTapShareButton() {
        guard let details = self.movieDetails else { return }
        router.presentShareView(movie: details)
    }
    
    func didSelectActor(_ actor: Cast) {
        router.showActorPopUp(actor: actor)
    }
    
    func didTapBackButton() {
        router.goBack()
    }
    
    func didTapToSubDetails(sendedBy view: UIView, message: String) {
        router.showTooltipView(sendedBy: view, message: message)
    }
    
    func didTapAddToWatchlist(adding: Bool) {
        interactor.addOrRemoveInWatchlist(movieID: movieID, adding: adding)
    }
    
    func didTapFavoriteButton(adding: Bool) {
        interactor.addOrRemoveInFavorites(movieID: movieID, adding: adding)
    }
    
    func didTapAddToList() {
        router.presentAddToListModal(movieID: movieID)
    }
    
    // MARK: - PROGRAMMATIC
    func didGetMovieReviews(_ reviews: [Review]) {
        movieReviews = reviews
        dispatchGroup.leave()
    }
    
    func didGetMovieVideos(videos: [Video]) {
        movieVideos = videos
        dispatchGroup.leave()
    }
    
    func didGetMovieDetails(_ details: MovieDetails) {
        movieDetails = details
        guard let belongsToCollection = details.belongsToCollection else { dispatchGroup.leave(); return }
        
        dispatchGroup.enter()
        interactor.getBelongsToCollectionDetails(collectionID: belongsToCollection.id)
        dispatchGroup.leave()
    }
    
    func didGetMovieCast(cast: [Cast], crew: [Cast]) {
        movieCast = cast
        movieCrew = crew
        dispatchGroup.leave()
    }
    
    func didGetMovieRecommendations(queryMovies: [Movie]) {
        self.movieRecommends = queryMovies.removingMediaWithoutPoster().sortByPopularity()
        dispatchGroup.leave()
    }
    
    func didGetMovieBelongsToCollectionDetails(_ details: BelongsToCollectionDetails) {
        self.belongsToCollectionDetails = details
        dispatchGroup.leave()
    }
    
    func didAddToWatchlist(_ message: String) {
        print("Successfully added to watchlist: \(message)")
    }
    
    func didAddToFavorite(_ message: String) {
        print("Successfully added to favorite: \(message)")
    }

    func didGetMovieAccountStates(_ accountStates: MediaAccountStatesAPIResponse) {
        self.movieAccountStates = accountStates
        dispatchGroup.leave()
    }
    
    func didGetUserLists(_ userLists: [UserList]) {
        self.userLists = userLists
        dispatchGroup.leave()
    }
    
    // MARK: - ERROR
    func didRecieveError(_ error: String, goesBack: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecieveError(error, goesBack: goesBack)
        }
    }
}
