//
//  HomeScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol HomeScreenPresenterProtocol: AnyObject {
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
    func didRecievePeopleSearchResults(_ results: [Person])
    
    // MARK: - MOVIES
    func didDownloadMovieList(listType: MovieListType, queryMovies: [Movie])
    
    // MARK: - TV SERIES
    func didDownloadSeriesList(listType: TVSeriesListType, querySeries: [TVSeries])
    
    // MARK: - TRENDING
    func didDownloadTrendingPeople(_ people: [Person])
    
    // MARK: - PROPERTIES
    var movieLists: [(listType: MovieListType, movies: [Movie])] { get set }
    var seriesLists: [(listType: TVSeriesListType, series: [TVSeries])] { get set }
    var trendingPeople: [Person] { get set }
    var visibleSections: [HomeScreenVC.Sections] { get set }
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error)
}

final class HomeScreenPresenter {
    // MARK: - TYPEALIASES
    typealias Sections = HomeScreenVC.Sections
    typealias Items = HomeScreenVC.Items
    
    // MARK: - VIPER
    weak var view: HomeScreenViewProtocol?
    var router: HomeScreenRouterProtocol
    var interactor: HomeScreenInteractorProtocol
    
    // MARK: - PROPERTIES
    private let downloadGroup = DispatchGroup()
    private let searchDownloadGroup = DispatchGroup()
    private var searchWorkItem: DispatchWorkItem?
    
    public var visibleSections: [HomeScreenVC.Sections] = []
    
    public var movieLists: [(listType: MovieListType, movies: [Movie])] = []
    public var seriesLists: [(listType: TVSeriesListType, series: [TVSeries])] = []
    
    public var trendingPeople: [Person] = []
    
    public var movieSearchResults: [Movie] = []
    public var tvSeriesSearchResults: [TVSeries] = []
    public var peopleSearchResults: [Person] = []
    
    init(interactor: HomeScreenInteractorProtocol, router: HomeScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension HomeScreenPresenter: HomeScreenPresenterProtocol {
    
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
            self.view?.didRecieveAllData()
        }
    }
    
    // MARK: - USER INITIATED
    func didTapMedia(_ media: any Media) {
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
            let featuredVM = FeaturedMediaCellViewModel(media: self.movieLists.flatMap { $0.movies }) { [weak self] in
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
            let featuredVM = FeaturedMediaCellViewModel(media: self.seriesLists.flatMap { $0.series }) { [weak self] in
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
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            self.searchDownloadGroup.enter()
            self.interactor.downloadSearchResultsForMovies(query: query)

            self.searchDownloadGroup.enter()
            self.interactor.downloadSearchResultsForTVSeries(query: query)

            self.searchDownloadGroup.enter()
            self.interactor.downloadSearchResultsForPeople(query: query)

            self.searchDownloadGroup.notify(queue: .main) {
                self.view?.didRecieveSearchResults()
            }
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
    
    // MARK: - SEARCH
    func didRecieveMovieSearchResults(_ results: [Movie]) {
        self.movieSearchResults = results
        searchDownloadGroup.leave()
    }
    
    func didRecieveTVSeriesSearchResults(_ results: [TVSeries]) {
        self.tvSeriesSearchResults = results
        searchDownloadGroup.leave()
    }
    
    func didRecievePeopleSearchResults(_ results: [Person]) {
        self.peopleSearchResults = results
        searchDownloadGroup.leave()
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
        let trendingPeople = people.sorted {
            ($0.profilePath != nil ? 0 : 1) < ($1.profilePath != nil ? 0 : 1)
        }
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
