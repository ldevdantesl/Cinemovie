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
    func didTapSearch()
    
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
    
    private var movieLists: [(listType: MovieListType, movies: [Movie])] = []
    private var seriesLists: [(listType: TVSeriesListType, series: [TVSeries])] = []
    private var trendingPeople: [Person] = []
    
    init(interactor: DiscoverScreenInteractorProtocol, router: DiscoverScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension DiscoverScreenPresenter: DiscoverScreenPresenterProtocol {
    
    // MARK: - STARTING
    func viewDidLoaded() {
        self.view?.showDownloadingView()
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
            self.view?.hideDownloadingView()
        }
    }
    
    // MARK: - USER INITIATED
    func didTapMedia(_ media: any Media) {
        switch media {
        case let movie as Movie: router.navigateToMovieDetails(movie: movie)
        case let series as TVSeries: router.navigateToTVSeriesDetails(series: series)
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
            guard let featuredMedia = self.movieLists.first(where: { $0.listType == .popular })?.movies.randomElement() else { return }
            let featuredVM = OneFeaturedMediaCellViewModel(media: featuredMedia) { [weak self] in
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
            guard let featuredMedia = self.seriesLists.first(where: { $0.listType == .popular })?.series.randomElement() else { return }
            let featuredVM = OneFeaturedMediaCellViewModel(media: featuredMedia) { [weak self] in
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
    
    func didTapSearch() {
        router.navigateToSearch()
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
