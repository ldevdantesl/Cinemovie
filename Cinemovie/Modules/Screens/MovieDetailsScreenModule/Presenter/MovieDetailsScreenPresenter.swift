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
    private let authContext: AuthContextProtocol
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

    init(movieID: Int, authContext: AuthContextProtocol, interactor: MovieDetailsScreenInteractorProtocol, router: MovieDetailsScreenRouterProtocol) {
        self.movieID = movieID
        self.interactor = interactor
        self.router = router
        self.authContext = authContext
    }
    
    private func applySnapshot() {
        self.view?.hideLoading()
        guard let movieDetails else { return }
        let backdropVM = BackdropImageCellViewModel(
            imagePath: movieDetails.backdropPath,
            size: .w1280, isFavorite: movieAccountStates.favorite,
            didTapBackButtonAction: { [weak self] in self?.didTapBackButton() },
            didTapFavorite: { [weak self] in self?.didTapFavoriteButton(adding: $0) }
        )
        
        let titleVM = TitleAndTaglineCellViewModel(mediaName: movieDetails.title, mediaTagline: movieDetails.tagline)
        
        let subDetailsVM = MovieDetailsSubDetailsCellViewModel(
            year: movieDetails.releaseDate, released: CMDateFormatter.isDatePassed(movieDetails.releaseDate),
            duration: RuntimeHelper.runtime(movieDetails.runtime), imdbPath: movieDetails.imdbID,
            didTapIMDB: { [weak self] in self?.didTapIMDBImage() },
            didTapSubDetails: { [weak self] in self?.didTapToSubDetails(sendedBy: $0, message: $1) }
        )
                
        var sectionsAndTheirItems: [(sections: (MovieDetailsScreenVC.Sections), items: [MovieDetailsScreenVC.Items])] = [
            (.backdropImage, [.backdropImage(backdropVM)]),
            (.titleAndTagline, [.titleAndTagline(titleVM)]),
            (.subDetails, [.subDetails(subDetailsVM)])
        ]

        if !authContext.isGuest {
            let watchlistVM = WatchlistButtonCellViewModel(
                isWatchlisted: movieAccountStates.watchlist,
                showsAddToListButton: userLists.count > 0,
                didTapAction: { [weak self] in self?.didTapAddToWatchlist(adding: $0) },
                didTapAddToList: { [weak self] in self?.didTapAddToList() }
            )
            sectionsAndTheirItems.append((.watchlistButton, [.watchListButton(watchlistVM)]))
        }
        
        if !movieDetails.overview.isEmpty {
            let overviewVM = OverviewCellViewModel(overviewText: movieDetails.overview)
            sectionsAndTheirItems.append((.overview, [.overview(overviewVM)]))
        }
        
        if !movieCast.isEmpty || !movieCrew.isEmpty {
            let castVM = CastListCellViewModel(cast: !movieCast.isEmpty ? movieCast : movieCrew) { [weak self] in self?.didSelectActor($0)}
            sectionsAndTheirItems.append((.cast, [.cast(castVM)]))
        }
        
        let prodVM = ProductionInfoCellViewModel(companies: movieDetails.productionCompanies, countries: movieDetails.productionCountries)
        sectionsAndTheirItems.append((.production, [.production(prodVM)]))
        
        let rateVM = RateAndShareCellViewModel(
            didTapShareButton: { [weak self] in self?.didTapShareButton() },
            didTapRateButton: { [weak self] in self?.didTapRateButton() }
        )
        sectionsAndTheirItems.append((.rateAndShare, [.rateAndShare(rateVM)]))
        
        if belongsToCollectionDetails != nil || !movieRecommends.isEmpty || !movieVideos.isEmpty || !movieReviews.isEmpty {
            let extrasVM = MediaExtrasCellViewModel(
                collectionDetails: belongsToCollectionDetails,
                recommended: movieRecommends, videos: movieVideos,
                reviews: movieReviews, didTapMedia: { [weak self] in self?.didTapMedia(media: $0) }
            )
            sectionsAndTheirItems.append((.mediaExtras, [.mediaExtras(extrasVM)]))
        } else {
            let unavailableVM = UnavailableInfoCellViewModel(
                title: "No additional content available",
                subtitle: "We couldn’t find any related videos, reviews, or recommendations for this movie.",
                image: UIImage(named: ImageNames.empty2.rawValue)
            )
            sectionsAndTheirItems.append((.unavailable, [.unavailable(unavailableVM)]))
        }
        
        self.view?.applySnapshot(
            sections: sectionsAndTheirItems.map { $0.sections },
            items: Dictionary(uniqueKeysWithValues: sectionsAndTheirItems)
        )
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
        
        if !authContext.isGuest {
            dispatchGroup.enter()
            interactor.getMovieAccountStates(movieID: movieID)
        }
        
        dispatchGroup.enter()
        interactor.getUserLists()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.applySnapshot()
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
