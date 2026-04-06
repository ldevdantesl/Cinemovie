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
    
    // MARK: - USER INITIATED
    func didAddToWatchlist(_ message: String)
    func didAddToFavorite(_ message: String)
    
    // MARK: - RATING
    func didRate(message: String?, value: Double)
    func didRemovedRating(message: String?)
    
    // MARK: - ERROR
    func didRecieveError(_ error: String, goesBack: Bool)
}

final class MovieDetailsScreenPresenter {
    
    // MARK: - FETCH RESULT
    private enum FetchResult {
        case details(MovieDetails)
        case castNCrew([Cast], [Cast])
        case videos([Video])
        case reviews([Review])
        case recommends([Movie])
        case accountState(MediaAccountStatesAPIResponse)
        case userList([UserList])
        case collection(BelongsToCollectionDetails)
        case failure(Error)
    }
    
    // MARK: - VIPER
    weak var view: MovieDetailsScreenViewProtocol?
    var router: MovieDetailsScreenRouterProtocol
    var interactor: MovieDetailsScreenInteractorProtocol
    
    // MARK: - PROPERTIES
    private let movieID: Int
    private let authContext: AuthContextProtocol
    
    private var movieDetails: MovieDetails?
    private var movieVideos: [Video] = []
    private var movieCast: [Cast] = []
    private var movieCrew: [Cast] = []
    private var movieReviews: [Review] = []
    private var movieRecommends: [Movie] = []
    private var belongsToCollectionDetails: BelongsToCollectionDetails?
    private var userLists: [UserList] = []
    private var movieAccountStates: MediaAccountStatesAPIResponse = .empty

    init(movieID: Int, authContext: AuthContextProtocol, interactor: MovieDetailsScreenInteractorProtocol, router: MovieDetailsScreenRouterProtocol) {
        self.movieID = movieID
        self.interactor = interactor
        self.router = router
        self.authContext = authContext
    }
    
    private func applySnapshot() {
        guard let movieDetails else { return }
        let backdropVM: BackdropImageCellViewModel
        
        if !authContext.isGuest {
            backdropVM = BackdropImageCellViewModel(
                imagePath: movieDetails.backdropPath,
                size: .w1280, isFavorite: movieAccountStates.favorite,
                didTapBackButtonAction: { [weak self] in self?.didTapBackButton() },
                didTapFavorite: { [weak self] in self?.didTapFavoriteButton(adding: $0) }
            )
        } else {
            backdropVM = BackdropImageCellViewModel(
                imagePath: movieDetails.backdropPath, size: .w1280,
                didTapBackButtonAction: { [weak self] in self?.didTapBackButton() }
            )
        }
        
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
            rated: movieAccountStates.rated,
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
        Task { [weak self] in
            guard let self else { return }
            await MainActor.run { self.view?.showLoading() }
            
            let errors = await withTaskGroup(of: FetchResult.self) { group in
                group.addTask {
                    do { return .details(try await self.interactor.getMovieDetails(movieID: self.movieID)) }
                    catch { return .failure(error) }
                }
                
                group.addTask {
                    do {
                        let (cast, crew) = try await self.interactor.getMovieCast(movieID: self.movieID)
                        return .castNCrew(cast, crew)
                    }
                    catch { return .failure(error) }
                }
                
                group.addTask {
                    do { return .recommends(try await self.interactor.getMovieRecommendations(movieID: self.movieID)) }
                    catch { return .failure(error) }
                }
                
                group.addTask {
                    do { return .videos(try await self.interactor.getMovieVideos(movieID: self.movieID)) }
                    catch { return .failure(error) }
                }
                
                group.addTask {
                    do { return .reviews(try await self.interactor.getMovieReviews(movieID: self.movieID)) }
                    catch { return .failure(error) }
                }
                
                if !self.authContext.isGuest {
                    group.addTask {
                        do { return .accountState(try await self.interactor.getMovieAccountStates(movieID: self.movieID)) }
                        catch { return .failure(error) }
                    }
                }
                
                group.addTask {
                    do { return .userList(try await self.interactor.getUserLists()) }
                    catch { return .failure(error) }
                }
                
                var collectedErrors: [Error] = []
                
                for await result in group {
                    switch result {
                    case .details(let details):
                        self.movieDetails = details
                    case .castNCrew(let cast, let crew):
                        self.movieCast = cast
                        self.movieCrew = crew
                    case .recommends(let movies):
                        self.movieRecommends = movies.removingMediaWithoutPoster().sortByPopularity()
                    case .videos(let videos):
                        self.movieVideos = videos
                    case .reviews(let reviews):
                        self.movieReviews = reviews
                    case .accountState(let states):
                        self.movieAccountStates = states
                    case .userList(let lists):
                        self.userLists = lists
                    case .collection(let details):
                        self.belongsToCollectionDetails = details
                    case .failure(let error):
                        collectedErrors.append(error)
                    }
                }
                
                return collectedErrors
            }
            
            if let collectionID = self.movieDetails?.belongsToCollection?.id {
                do {
                    self.belongsToCollectionDetails = try await self.interactor.getBelongsToCollectionDetails(collectionID: collectionID)
                } catch {
                    self.belongsToCollectionDetails = .none
                }
            }
            
            await MainActor.run {
                if let error = errors.first {
                    self.view?.didRecieveError(error.localizedDescription, goesBack: true)
                }
                self.applySnapshot()
                self.view?.hideLoading()
            }
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
        let viewModel = RatePopUpViewModel(
            posterPath: movieDetails?.posterPath,
            existingRating: movieAccountStates.rated?.value,
            didRate: { [weak self] in
                guard let self = self else { return }
                self.interactor.rateMovie(movieID: self.movieID, value: $0)
            },
            onClose: { [weak self] in self?.view?.activePopUpView = nil }
        )
        self.router.showRatingPopUP(ratePopupVM: viewModel)
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
    
    func didAddToWatchlist(_ message: String) {
        print("Successfully added to watchlist: \(message)")
    }
    
    func didAddToFavorite(_ message: String) {
        print("Successfully added to favorite: \(message)")
    }
    
    // MARK: - RATING
    func didRate(message: String?, value: Double) {
        var newAccountState = movieAccountStates
        newAccountState.rated = .init(value: value)
        self.movieAccountStates = newAccountState
    }
    
    func didRemovedRating(message: String?) { }
    
    // MARK: - ERROR
    func didRecieveError(_ error: String, goesBack: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecieveError(error, goesBack: goesBack)
        }
    }
}
