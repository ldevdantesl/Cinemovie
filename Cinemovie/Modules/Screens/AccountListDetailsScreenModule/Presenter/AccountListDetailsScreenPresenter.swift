//
//  WatchlistDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//
import UIKit

protocol AccountListDetailsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    // MARK: - USER INITIATED
    func didTapBackButton()
    func didTapAnyMedia(media: Media)
    func didCallPagination(for mediaType: MediaTypes)
    func didCallRefresh(for mediaType: MediaTypes)
    
    // MARK: - PROGRAMMATIC
    func didReceiveMedia(_ media: [Media])
    func didReceiveNewMedia(_ media: [Media])
    func didReceiveRefreshingMedia(_ media: [Media])
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error)
}

final class AccountListDetailsScreenPresenter {
    weak var view: AccountListDetailsScreenViewProtocol?
    var router: AccountListDetailsScreenRouterProtocol
    var interactor: AccountListDetailsScreenInteractorProtocol
    
    private var listType: AccountListTypes
    private let downloadGroup = DispatchGroup()
    
    private var movieCurrentPage: Int = 1
    private var seriesCurrentPage: Int = 1
    
    private var movies: [Movie] = []
    private var series: [TVSeries] = []
    
    init(listType: AccountListTypes, interactor: AccountListDetailsScreenInteractorProtocol, router: AccountListDetailsScreenRouterProtocol) {
        self.listType = listType
        self.interactor = interactor
        self.router = router
    }
}

extension AccountListDetailsScreenPresenter: AccountListDetailsScreenPresenterProtocol {
    func viewDidLoad() {
        downloadGroup.enter()
        interactor.getInitialListMovies(listType: listType)
        
        downloadGroup.enter()
        interactor.getInitialListSeries(listType: listType)
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.didRecieveMedia(movies: self.movies, series: self.series)
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
    func didReceiveMedia(_ media: [any Media]) {
        guard !media.isEmpty else { downloadGroup.leave(); return }
        if let movies = media as? [Movie] {
            self.movies = movies
        } else if let series = media as? [TVSeries] {
            self.series = series
        }
        downloadGroup.leave()
    }
    
    // MARK: - PAGINATED
    func didReceiveNewMedia(_ media: [any Media]) {
        if let movies = media as? [Movie] {
            self.movies.append(contentsOf: movies)
            self.view?.didRecieveNewMedia(mediaType: .movie, media: movies, paginating: true)
            if !movies.isEmpty { self.movieCurrentPage += 1 }
        } else if let series = media as? [TVSeries] {
            self.series.append(contentsOf: series)
            self.view?.didRecieveNewMedia(mediaType: .tvShow, media: series, paginating: true)
            if !series.isEmpty { self.seriesCurrentPage += 1 }
        }
    }
    
    // MARK: - REFRESHING
    func didReceiveRefreshingMedia(_ media: [any Media]) {
        if let movies = media as? [Movie] {
            self.movies = movies
            self.view?.didRecieveNewMedia(mediaType: .movie, media: movies, paginating: false)
            self.movieCurrentPage = 1
        } else if let series = media as? [TVSeries] {
            self.series = series
            self.view?.didRecieveNewMedia(mediaType: .tvShow, media: series, paginating: false)
            self.seriesCurrentPage = 1
        }
    }
    // MARK: - ERROR
    func didRecieveError(_ error: any Error) {
        self.view?.didRecieveError(error.localizedDescription, goesBack: true)
    }
}
