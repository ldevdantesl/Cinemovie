//
//  WatchlistDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//
import UIKit

protocol UserListDetailsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    // MARK: - USER INITIATED
    func didTapBackButton()
    func didTapAnyMedia(media: Media)
    func didCallPagination(for mediaType: MediaTypes)
    func didCallRefresh(for mediaType: MediaTypes)
    
    // MARK: - PROGRAMMATIC
    func didRecieveMovies(_ movie: [Movie])
    func didRecieveTVSeries(_ series: [TVSeries])
    func didRecieveTotalPages(forType mediaType: MediaTypes, totalPages: Int)
    
    func didReceiveNewMovies(_ movies: [Movie])
    func didReceiveNewSeries(_ series: [TVSeries])
    
    func didReceiveRefreshingMovies(_ movies: [Movie])
    func didReceiveRefreshingSeries(_ series: [TVSeries])
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error)
}

final class UserListDetailsScreenPresenter {
    weak var view: UserListDetailsScreenViewProtocol?
    var router: UserListDetailsScreenRouterProtocol
    var interactor: UserListDetailsScreenInteractorProtocol
    
    private var listType: AccountListTypes
    private let downloadGroup = DispatchGroup()
    private let refreshGroup = DispatchGroup()
    
    private var movieTotalPages: Int = 0
    private var seriesTotalPages: Int = 0
    private var movieCurrentPage: Int = 1
    private var seriesCurrentPage: Int = 1
    
    private var movies: [Movie] = []
    private var series: [TVSeries] = []
    
    init(listType: AccountListTypes, interactor: UserListDetailsScreenInteractorProtocol, router: UserListDetailsScreenRouterProtocol) {
        self.listType = listType
        self.interactor = interactor
        self.router = router
    }
}

extension UserListDetailsScreenPresenter: UserListDetailsScreenPresenterProtocol {
    func viewDidLoad() {
        
        downloadGroup.enter()
        interactor.getInitialListMovies(listType: listType)
        
        downloadGroup.enter()
        interactor.getInitialListSeries(listType: listType)
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.didRecieveMedia(movies: movies, series: series)
        }
    }
    
    // MARK: - USER INITIATED
    func didTapBackButton() {
        router.goBack()
    }
    
    func didTapAnyMedia(media: any Media) {
        switch media {
        case let movie as Movie: router.navigateToMovieDetails(movieId: movie.id)
        case let series as TVSeries: router.navigateToTVSeriesDetails(seriesID: series.id)
        default: break
        }
    }
    
    func didRecieveTotalPages(forType mediaType: MediaTypes, totalPages: Int) {
        switch mediaType {
        case .movie: movieTotalPages = totalPages
        case .tvShow: seriesTotalPages = totalPages
        }
    }
    
    func didCallPagination(for mediaType: MediaTypes) {
        mediaType == .movie ?
        interactor.getNewPaginatedMoviesForPage(listType: listType, page: movieCurrentPage + 1) :
        interactor.getNewPaginatedSeriesForPage(listType: listType, page: seriesCurrentPage + 1)
    }
    
    func didCallRefresh(for mediaType: MediaTypes) {
        mediaType == .movie ?
        interactor.getRefreshingListMovies(listType: listType) :
        interactor.getRefreshingListSeries(listType: listType)
    }
    
    // MARK: - INITIAL
    func didRecieveMovies(_ movie: [Movie]) {
        self.movies = movie
        downloadGroup.leave()
    }
    
    func didRecieveTVSeries(_ series: [TVSeries]) {
        self.series = series
        downloadGroup.leave()
    }
    
    // MARK: - PAGINATED
    func didReceiveNewMovies(_ movies: [Movie]) {
        self.movies.append(contentsOf: movies)
        self.view?.didRecieveNewMedia(mediaType: .movie, media: movies, paginating: true)
        guard !movies.isEmpty else { return }
        self.movieCurrentPage += 1
    }
    
    func didReceiveNewSeries(_ series: [TVSeries]) {
        self.series.append(contentsOf: series)
        self.view?.didRecieveNewMedia(mediaType: .tvShow, media: series, paginating: true)
        guard !series.isEmpty else { return }
        self.seriesCurrentPage += 1
    }
    
    // MARK: - REFRESHING
    func didReceiveRefreshingMovies(_ movies: [Movie]) {
        self.movies = movies
        self.view?.didRecieveNewMedia(mediaType: .movie, media: movies, paginating: false)
        if movieCurrentPage > 1 { self.movieCurrentPage -= 1 }
    }
    
    func didReceiveRefreshingSeries(_ series: [TVSeries]) {
        self.series = series
        self.view?.didRecieveNewMedia(mediaType: .tvShow, media: series, paginating: false)
        if seriesCurrentPage > 1 { self.seriesCurrentPage -= 1 }
    }
    
    // MARK: - ERROR
    func didRecieveError(_ error: any Error) {
        self.view?.didRecieveError(error.localizedDescription, goesBack: true)
    }
}
