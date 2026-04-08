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
    func didTapMedia(_ media: MediaProtocol)
    func didTapPerson(_ person: Person)
    func didChangeMediaType(_ mediaType: MediaTypes)
    func didTapSearch()
    func didRefresh()
    
    var currentMediaType: MediaTypes { get }
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error)
}

final class DiscoverScreenPresenter {
    
    // MARK: - FETCH RESULT
    private enum FetchResult {
        case movieList(MovieListType, [Movie])
        case seriesList(TVSeriesListType, [TVSeries])
        case trendingPeople([Person])
        case failure(Error)
    }
    
    // MARK: - TYPEALIASES
    typealias Sections = DiscoverScreenVC.Sections
    typealias Items = DiscoverScreenVC.Items
    
    // MARK: - VIPER
    weak var view: DiscoverScreenViewProtocol?
    var router: DiscoverScreenRouterProtocol
    var interactor: DiscoverScreenInteractorProtocol
    
    // MARK: - INJECTED
    private let userService: UserServiceProtocol
    
    // MARK: - COMPUTED PROPERTIES
    var currentMediaType: MediaTypes {
        userService.defaultMediaType
    }

    // MARK: - PRIVATE PROPERTIES
    private var movieLists: [(listType: MovieListType, movies: [Movie])] = []
    private var seriesLists: [(listType: TVSeriesListType, series: [TVSeries])] = []
    private var trendingPeople: [Person] = []
    
    private let movieListsToDownload: [MovieListType] = [
        .popular, .upcoming, .topRated, .nowPlaying,
        .animation, .action, .comedy, .drama,
        .fantasy, .horror, .history, .documentary,
    ]
    
    private let seriesListsToDownload: [TVSeriesListType] = [
        .popular, .airingToday, .topRated, .onTheAir,
        .actionAdventure, .animation, .comedy, .drama,
        .sciFiFantasy, .crime, .documentary, .kids
    ]
    
    init(interactor: DiscoverScreenInteractorProtocol, router: DiscoverScreenRouterProtocol, userService: UserServiceProtocol) {
        self.interactor = interactor
        self.router = router
        self.userService = userService
    }
    
    // MARK: - FETCH
    private func fetchAllContent() async {
        movieLists.removeAll()
        seriesLists.removeAll()
        trendingPeople.removeAll()
        
        var fetchedMovies: [MovieListType: [Movie]] = [:]
        var fetchedSeries: [TVSeriesListType: [TVSeries]] = [:]
        
        let collectedErrors = await withTaskGroup(of: FetchResult.self) { group in
            for listType in movieListsToDownload {
                group.addTask { [interactor] in
                    do {
                        let movies = try await interactor.fetchMovieList(listType: listType)
                        return .movieList(listType, movies)
                    } catch {
                        return .failure(error)
                    }
                }
            }
            
            for listType in seriesListsToDownload {
                group.addTask { [interactor] in
                    do {
                        let series = try await interactor.fetchTVSeriesList(listType: listType)
                        return .seriesList(listType, series)
                    } catch {
                        return .failure(error)
                    }
                }
            }
            
            group.addTask { [interactor] in
                do {
                    let people = try await interactor.fetchTrendingPeople(timeWindow: .week)
                    return .trendingPeople(people)
                } catch {
                    return .failure(error)
                }
            }
            
            var errors: [Error] = []
            
            for await result in group {
                switch result {
                case .movieList(let listType, let movies):
                    fetchedMovies[listType] = movies
                case .seriesList(let listType, let series):
                    fetchedSeries[listType] = series
                case .trendingPeople(let people):
                    let filtered = people
                        .filter { $0.profilePath != nil }
                        .sorted { $0.popularity > $1.popularity }
                    self.trendingPeople = Array(filtered.prefix(10))
                case .failure(let error):
                    errors.append(error)
                }
            }
            
            return errors
        }
        
        self.movieLists = movieListsToDownload.compactMap { listType in
            guard let movies = fetchedMovies[listType], !movies.isEmpty else { return nil }
            return (listType, movies)
        }
        
        self.seriesLists = seriesListsToDownload.compactMap { listType in
            guard let series = fetchedSeries[listType], !series.isEmpty else { return nil }
            return (listType, series)
        }
        
        if !collectedErrors.isEmpty {
            print("⚠️ Discover fetch completed with \(collectedErrors.count) errors")
        }
    }
    
    private func generateListSections<T: MediaListType, M: MediaProtocol>(
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

extension DiscoverScreenPresenter: DiscoverScreenPresenterProtocol {
    
    // MARK: - STARTING
    func viewDidLoaded() {
        view?.showDownloadingView()
        Task { [weak self] in
            guard let self = self else { return }
            await self.fetchAllContent()
            await MainActor.run {
                self.didChangeMediaType(self.userService.defaultMediaType)
                self.view?.hideDownloadingView()
            }
        }
    }
    
    // MARK: - USER INITIATED
    func didTapMedia(_ media: any MediaProtocol) {
        switch media {
        case let movie as Movie: router.navigateToMovieDetails(movieID: movie.id)
        case let series as TVSeries: router.navigateToTVSeriesDetails(seriesID: series.id)
        default: break
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
        
        if sectionsAndItems.count >= 5 {
            sectionsAndItems.insert((Sections.trendingPeople, [.trendingPeopleCell(trendingPeopleVM)]), at: 5)
        } else {
            sectionsAndItems.append((Sections.trendingPeople, [.trendingPeopleCell(trendingPeopleVM)]))
        }
        
        let sections = sectionsAndItems.map(\.section)
        let itemsBySection = Dictionary(uniqueKeysWithValues: sectionsAndItems)
        
        view?.applySnapshot(sections: sections, itemsBySection: itemsBySection)
    }
    
    func didTapSearch() {
        router.navigateToSearch()
    }
    
    func didRefresh() {
        Task { [weak self] in
            guard let self = self else { return }
            await self.fetchAllContent()
            await MainActor.run {
                self.didChangeMediaType(self.userService.defaultMediaType)
                self.view?.didRefresh()
            }
        }
    }
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error) {
        self.view?.didRecieveError(error.localizedDescription)
    }
}
