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
    func didGetTVSeasonDetails(_ details: TVSeasonDetails)
    
    func didAddOrRemoveFromWatchlist(message: String?)
    func didAddOrRemoveFromFavorites(message: String?)
    
    // MARK: - RATING
    func didRate(message: String?, value: Double)
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: Error)
}

final class TVSeriesDetailsScreenPresenter {
    
    // MARK: - TASK GROUP
    enum FetchResult {
        case details(TVSeriesDetails)
        case castNCrew([Cast], [Cast])
        case videos([Video])
        case recommends([TVSeries])
        case reviews([Review])
        case userList([UserList])
        case accountState(MediaAccountStatesAPIResponse)
        case failure(Error)
    }
    
    // MARK: - TYPEALIASES
    typealias Sections = TVSeriesDetailsScreenVC.Sections
    typealias Items = TVSeriesDetailsScreenVC.Items
    
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
    private var userLists: [UserList] = []
    private var seriesAccountStates: MediaAccountStatesAPIResponse = .empty

    init(seriesID: Int, authContext: AuthContextProtocol, interactor: TVSeriesDetailsScreenInteractorProtocol, router: TVSeriesDetailsScreenRouterProtocol) {
        self.seriesID = seriesID
        self.interactor = interactor
        self.router = router
        self.authContext = authContext
    }
    
    func applySnapshot() {
        self.view?.showLoading()
        guard let seriesDetails else { return }
        
        let backdropVM: BackdropImageCellViewModel
        
        if !authContext.isGuest {
            backdropVM = BackdropImageCellViewModel(
                imagePath: seriesDetails.backdropPath,
                size: .w1280, isFavorite: seriesAccountStates.favorite,
                didTapBackButtonAction: { [weak self] in self?.didTapBackButton() },
                didTapFavorite: { [weak self] in self?.didTapFavoriteButton(adding: $0) }
            )
        } else {
            backdropVM = BackdropImageCellViewModel(
                imagePath: seriesDetails.backdropPath, size: .w1280,
                didTapBackButtonAction: { [weak self] in self?.didTapBackButton() }
            )
        }
        
        let titleVM = TitleAndTaglineCellViewModel(mediaName: seriesDetails.name, mediaTagline: seriesDetails.tagline)
        
        let subDetailsVM = TVSeriesDetailsSubDetailsViewModel(
            firstAirDate: seriesDetails.firstAirDate, numberOfSeasons: seriesDetails.numberOfSeasons ?? 0,
            numberOfEpisodes: seriesDetails.numberOfEpisodes ?? 0, homepage: seriesDetails.homepage,
            status: seriesDetails.status ?? .ended, nextEpisodeToAir: seriesDetails.nextEpisodeToAir?.airDate,
            didTapView: { [weak self] in self?.didTapTooltipView(sendedBy: $0, withMessage: $1) },
            didTapHomepage: { [weak self] in self?.didTapHomepage(homepage: $0) }
        )
        
        var sectionsAndTheirItems: [(section: Sections, items: [Items])] = [
            (.backdropImage, [.backdropImage(backdropVM)]),
            (.titleAndTagline, [.titleAndTagline(titleVM)]),
            (.subDetails, [.subDetails(subDetailsVM)])
        ]
        
        if !authContext.isGuest {
            let watchlistVm = WatchlistButtonCellViewModel(
                isWatchlisted: seriesAccountStates.watchlist,
                showsAddToListButton: userLists.count > 0,
                didTapAction: { [weak self] in self?.didTapWatchlistButton(adding: $0) },
                didTapAddToList: { [weak self] in self?.didTapAddToList() }
            )
            
            sectionsAndTheirItems.append((Sections.watchlistButton, [.watchListButton(watchlistVm)]))
        }
        
        if !seriesDetails.overview.isEmpty {
            let overviewVM = OverviewCellViewModel(overviewText: seriesDetails.overview)
            sectionsAndTheirItems.append((Sections.overview, [.overview(overviewVM)]))
        }
        
        if !seriesCast.isEmpty || !seriesCrew.isEmpty {
            let castVM = CastListCellViewModel(
                cast: !seriesCast.isEmpty ? seriesCast : seriesCrew,
                didSelectCast: { [weak self] in self?.didSelectActor($0) }
            )
            sectionsAndTheirItems.append((Sections.cast, [.cast(castVM)]))
        }
        
        let prodVM = ProductionInfoCellViewModel(
            companies: seriesDetails.productionCompanies,
            countries: seriesDetails.productionCountries
        )
        sectionsAndTheirItems.append((Sections.production, [.production(prodVM)]))
        
        let rateVM = RateAndShareCellViewModel(
            rated: seriesAccountStates.rated,
            didTapShareButton: { [weak self] in self?.didTapShareButton() },
            didTapRateButton: { [weak self] in self?.didTapRateButton() }
        )
        sectionsAndTheirItems.append((Sections.rateAndShare, [.rateAndShare(rateVM)]))
        
        let seasons = seriesDetails.seasons.filter { $0.seasonNumber != 0 }
        if !seasons.isEmpty || !seriesRecommends.isEmpty || !seriesVideos.isEmpty || !seriesReviews.isEmpty {
            let extrasVM = MediaExtrasCellViewModel(
                seasons: seasons, recommended: seriesRecommends,
                videos: seriesVideos, reviews: seriesReviews,
                didTapMedia: { [weak self] in self?.didTapMedia(media: $0) },
                didTapSeason: { [weak self] in self?.didSelectSeason($0) }
            )
            sectionsAndTheirItems.append((Sections.mediaExtras, [.mediaExtras(extrasVM)]))
        } else {
            let unavailableVM = UnavailableInfoCellViewModel(
                title: "No additional content available",
                subtitle: "We couldn’t find any related seasons, videos, reviews, or recommendations for this TV Series.",
                image: UIImage(named: ImageNames.empty2.rawValue)
            )
            sectionsAndTheirItems.append((Sections.unavailable, [.unavailable(unavailableVM)]))
        }
        
        self.view?.applySnapshot(
            sections: sectionsAndTheirItems.map { $0.section },
            items: Dictionary(uniqueKeysWithValues: sectionsAndTheirItems)
        )
    }
}

extension TVSeriesDetailsScreenPresenter: TVSeriesDetailsScreenPresenterProtocol {
    // MARK: - LIFECYCLE
    func viewDidLoad() {
        Task { [weak self] in
            guard let self = self else { return }
            self.view?.showLoading()
            
            let errors = await withTaskGroup(of: FetchResult.self) { group in
                group.addTask {
                    do { return .details(try await self.interactor.getTVSeriesDetails(seriesID: self.seriesID)) }
                    catch { return .failure(error) }
                }
                
                group.addTask {
                    do {
                        let (cast, crew) = try await self.interactor.getTVSeriesCast(seriesID: self.seriesID)
                        return .castNCrew(cast, crew)
                    }
                    catch { return .failure(error)}
                }
                
                group.addTask {
                    do { return .videos(try await self.interactor.getTVSeriesVideos(seriesID: self.seriesID)) }
                    catch { return .failure(error) }
                }
                
                group.addTask {
                    do { return .reviews(try await self.interactor.getTVSeriesReviews(seriesID: self.seriesID)) }
                    catch { return .failure(error) }
                }
                
                group.addTask {
                    do { return .recommends(try await self.interactor.getTVSeriesRecommendations(seriesID: self.seriesID)) }
                    catch { return .failure(error) }
                }
                
                if !self.authContext.isGuest {
                    group.addTask {
                        do { return .accountState(try await self.interactor.getTVSeriesAccountStates(seriesID: self.seriesID)) }
                        catch { return .failure(error) }
                    }
                    
                    group.addTask {
                        do { return .userList(try await self.interactor.getUserLists()) }
                        catch { return .failure(error)}
                    }
                }
                
                var collectedErrors: [Error] = []
                
                for await result in group {
                    switch result {
                    case .details(let details): self.seriesDetails = details
                    case .castNCrew(let cast, let crew): self.seriesCast = cast; self.seriesCrew = crew
                    case .reviews(let reviews): self.seriesReviews = reviews
                    case .recommends(let recommends): self.seriesRecommends = recommends
                    case .videos(let videos): self.seriesVideos = videos
                    case .userList(let userLists): self.userLists = userLists
                    case .accountState(let accountState): self.seriesAccountStates = accountState
                    case .failure(let error): collectedErrors.append(error)
                    }
                }
                
                return collectedErrors
            }
            
            await MainActor.run {
                if let error = errors.first {
                    self.view?.didRecieveError(error.localizedDescription)
                }
                self.applySnapshot()
                self.view?.hideLoading()
            }
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
        let viewModel = RatePopUpViewModel(
            posterPath: seriesDetails?.posterPath,
            existingRating: seriesAccountStates.rated?.value,
            didRate: { [weak self] in
                guard let self = self else { return }
                self.interactor.rate(seriesID: self.seriesID, value: $0)
            },
            onClose: { [weak self] in self?.view?.activePopUpView = nil }
        )
        self.router.showRatingPopUP(ratePopupVM: viewModel)
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
    
    func didTapAddToList() {
        router.presentAddToListModal(seriesID: seriesID)
    }
    
    func didGetTVSeasonDetails(_ details: TVSeasonDetails) {
        router.showSeasonPopUp(seasonDetails: details)
    }
    
    func didAddOrRemoveFromFavorites(message: String?) {
        print("Successfully done operation: \(message ?? "")")
    }
    
    func didAddOrRemoveFromWatchlist(message: String?) {
        print("Successfully done operation: \(message ?? "")")
    }
    
    // MARK: - RATING
    func didRate(message: String?, value: Double) {
        var newState = seriesAccountStates
        newState.rated = .init(value: value)
        self.seriesAccountStates = newState
    }
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: any Error) {
        self.view?.didRecieveError(error.localizedDescription)
    }
}
