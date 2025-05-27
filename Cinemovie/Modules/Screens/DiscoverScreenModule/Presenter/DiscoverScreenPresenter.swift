//
//  HomeScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol DiscoverScreenPresenterProtocol: AnyObject {
    // MARK: - STARTING
    func viewDidLoaded()
    
    // MARK: - USER INITIATED
    func didTapMedia(_ media: Media)
    func didTapPerson(_ person: Person)
    func didChangeMediaType(_ mediaType: MediaTypes)
    func didStartSearching(_ query: String)
    
    // MARK: - SEARCH
    func didRecieveMovieSearchResults(_ results: [Movie])
    func didRecieveTVSeriesSearchResults(_ results: [TVSeries])
    func didFinishSearching()
    func showSearchResults()
    func showRecentlyViewedMedia()
    
    // MARK: - MOVIES
    func didDownloadMovieList(listType: MovieListType, queryMovies: [Movie])
    
    // MARK: - TV SERIES
    func didDownloadSeriesList(listType: TVSeriesListType, querySeries: [TVSeries])
    
    // MARK: - TRENDING
    func didDownloadTrendingPeople(_ people: [Person])
    
    // MARK: - PROPERTIES
    var visibleSections: [DiscoverScreenVC.Sections] { get set }
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error)
}

final class DiscoverScreenPresenter {
    // MARK: - TYPEALIASES
    typealias Sections = DiscoverScreenVC.Sections
    typealias Items = DiscoverScreenVC.Items
    
    // MARK: - VIPER
    weak var view: DiscoverScreenViewProtocol?
    var router: DiscoverScreenRouterProtocol
    var interactor: DiscoverScreenInteractorProtocol
    
    // MARK: - PUBLIC PROPERTIES
    public var visibleSections: [DiscoverScreenVC.Sections] = []

    // MARK: - PRIVATE PROPERTIES
    private let downloadGroup = DispatchGroup()
    private let searchDownloadGroup = DispatchGroup()
    private var searchWorkItem: DispatchWorkItem?
    
    private var movieLists: [(listType: MovieListType, movies: [Movie])] = []
    private var seriesLists: [(listType: TVSeriesListType, series: [TVSeries])] = []
    
    private var trendingPeople: [Person] = []
    
    private var movieSearchResults: [Movie] = []
    private var tvSeriesSearchResults: [TVSeries] = []
    private var peopleSearchResults: [Person] = []
    
    private var recentlyViewedMedia: [Media] = []
    
    private var lastSearchQuery: String = ""
    private var currentMoviePage = 1
    private var currentTVSeriesPage = 1
    
    init(interactor: DiscoverScreenInteractorProtocol, router: DiscoverScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension DiscoverScreenPresenter: DiscoverScreenPresenterProtocol {
    
    // MARK: - STARTING
    func viewDidLoaded() {
        let movieListToDownload: [MovieListType] = [
            .popular, .upcoming, .topRated, .nowPlaying,
            .animation, .action, .comedy, .drama,
            .fantasy, .horror, .history, .documentary,
        ]
        
        let seriesListToDownload: [TVSeriesListType] = [
            .popular, .airingToday, .topRated, .onTheAir,
            .actionAdventure, .animation, .comedy, .drama,
            .sciFiFantasy, .crime, .documentary, .kids
        ]
        
        movieListToDownload.forEach { downloadGroup.enter(); interactor.downloadMovieList(listType: $0) }
        seriesListToDownload.forEach { downloadGroup.enter(); interactor.downloadTVSeriesList(listType: $0) }
        
        downloadGroup.enter()
        interactor.downloadTrendingPeople(timeWindow: .week)
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.didChangeMediaType(.movie)
            self.view?.downloadingView.hide()
        }
    }
    
    // MARK: - USER INITIATED
    func didTapMedia(_ media: any Media) {
        recentlyViewedMedia.map { $0.id }.contains(media.id) ? () : self.recentlyViewedMedia.append(media)
        switch media {
        case is Movie: router.navigateToMovieDetails(movieID: media.id)
        case is TVSeries: router.navigateToTVSeriesDetails(seriesID: media.id)
        default: fatalError("Media not supported")
        }
    }
    
    func didTapPerson(_ person: Person) {
        router.navigateToPersonDetails(personID: person.id)
    }
    
    func didChangeMediaType(_ mediaType: MediaTypes) {
        var sectionsAndItems: [(section: Sections, items: [Items])] = []
        
        switch mediaType {
        case .movie:
            guard let media = self.movieLists.flatMap(\.movies).randomElement() else { return }
            let featuredVM = OneFeaturedMediaCellViewModel(media: media) { [weak self] in
                guard let self = self else { return }
                self.didTapMedia($0)
            }
            sectionsAndItems.append((Sections.featured, [.featured(featuredVM)]))
            
            let movieSections = generateListSections(
                from: self.movieLists.map { ($0.listType, $0.movies) },
                sectionBuilder: { Sections.movieList($0) }
            )
            sectionsAndItems.append(contentsOf: movieSections)
            
        case .tvShow:
            guard let media = self.movieLists.flatMap(\.movies).randomElement() else { return }
            let featuredVM = OneFeaturedMediaCellViewModel(media: media) { [weak self] in
                guard let self = self else { return }
                self.didTapMedia($0)
            }
            sectionsAndItems.append((Sections.featured, [.featured(featuredVM)]))
            let seriesSections = generateListSections(
                from: self.seriesLists.map { ($0.listType, $0.series) },
                sectionBuilder: { Sections.seriesList($0) }
            )
            sectionsAndItems.append(contentsOf: seriesSections)
        }
        
        let trendingPeopleVM = TrendingPeopleCellViewModel(people: self.trendingPeople) { [weak self] in
            guard let self = self else { return }
            self.didTapPerson($0)
        }
        sectionsAndItems.insert((Sections.trendingPeople, [.trendingPeopleCell(trendingPeopleVM)]), at: 5)
        
        visibleSections = sectionsAndItems.map(\.section)
        let itemsBySection = Dictionary(uniqueKeysWithValues: sectionsAndItems)
        
        view?.applySnapshot(sections: visibleSections, itemsBySection: itemsBySection)
    }
    
    func didStartSearching(_ query: String) {
        searchWorkItem?.cancel()
        view?.downloadingView.hide()
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            guard !query.isEmpty else {
                !recentlyViewedMedia.isEmpty ? self.showRecentlyViewedMedia() : ()
                return
            }
            
            self.view?.downloadingView.show()
            self.searchDownloadGroup.enter()
            self.movieSearchResults = []
            self.interactor.downloadSearchResultsForMovies(query: query, untilPage: 1)

            self.searchDownloadGroup.enter()
            self.tvSeriesSearchResults = []
            self.interactor.downloadSearchResultsForTVSeries(query: query, untilPage: 1)

            self.searchDownloadGroup.notify(queue: .main) {[weak self] in
                guard let self = self else { return }
                self.showSearchResults()
                self.lastSearchQuery = query
            }
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
    
    // MARK: - SEARCH
    func didRecieveMovieSearchResults(_ results: [Movie]) {
        self.movieSearchResults.append(contentsOf: results.filteringByMinimumPopularity().removingMediaWithoutPoster())
        searchDownloadGroup.leave()
    }
    
    func didRecieveTVSeriesSearchResults(_ results: [TVSeries]) {
        self.tvSeriesSearchResults.append(contentsOf: results.filteringByMinimumPopularity().removingMediaWithoutPoster())
        searchDownloadGroup.leave()
    }
    
    func showSearchResults() {
        guard !tvSeriesSearchResults.isEmpty || !movieSearchResults.isEmpty else {
            visibleSections = [.notFound]
            let vm = UnavailableInfoCellViewModel(title: "Nothing was found", subtitle: "Try something else", image: UIImage(named: ImageNames.notFound.rawValue))
            self.view?.applySnapshot(sections: visibleSections, itemsBySection: [.notFound : [.notFoundCell(vm)]])
            self.view?.downloadingView.hide()
            return
        }
        visibleSections = [.search]
        let vm = MediaSearchCellViewModel(movies: movieSearchResults, tvSeries: tvSeriesSearchResults, people: peopleSearchResults) { [weak self] in
            guard let self = self else { return }
            self.didTapMedia($0)
        }
        view?.applySnapshot(sections: visibleSections, itemsBySection: [.search : [.searchCell(vm)]])
        self.view?.downloadingView.hide()
    }
    
    func showRecentlyViewedMedia() {
        self.visibleSections = [.recentlyViewed]
        let vm = VerticalMediaListCellViewModel(media: recentlyViewedMedia, title: "Recently Viewed", subtitle: "Your recently explored titles") { [weak self] in
            guard let self = self else { return }
            self.didTapMedia($0)
        }
        self.view?.applySnapshot(sections: visibleSections, itemsBySection: [.recentlyViewed : [.verticalMediaListCell(vm)]])
    }
    
    func didFinishSearching() {
        self.didChangeMediaType(.movie)
    }

    // MARK: - MOVIES
    func didDownloadMovieList(listType: MovieListType, queryMovies: [Movie]) {
        movieLists.append((listType, queryMovies))
        downloadGroup.leave()
    }
    
    // MARK: - TV SERIES
    func didDownloadSeriesList(listType: TVSeriesListType, querySeries: [TVSeries]) {
        seriesLists.append((listType, querySeries))
        downloadGroup.leave()
    }
    
    // MARK: - TRENDING
    func didDownloadTrendingPeople(_ people: [Person]) {
        let trendingPeople = people.filter { $0.profilePath != nil }.sorted { $0.popularity > $1.popularity }
        self.trendingPeople = Array(trendingPeople.prefix(upTo: 10))
        downloadGroup.leave()
    }
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error) {
        view?.didRecieveError(error.localizedDescription)
    }
    
    // MARK: - PRIVATE FUNC
    private func generateListSections<T: MediaListType, M: Media>(
        from lists: [(listType: T, media: [M])],
        sectionBuilder: (T) -> Sections
    ) -> [(section: Sections, items: [Items])] {
        var result: [(section: Sections, items: [Items])] = []

        for (listType, media) in lists {
            if media.isEmpty { continue }

            let vm = MediaListCellViewModel(mediaItems: media, listName: listType.title, listSubtitle: listType.subtitle) { [weak self] in
                guard let self = self else { return }
                self.didTapMedia($0)
            }

            result.append((sectionBuilder(listType), [.mediaListCell(vm)]))
        }

        return result
    }
}
