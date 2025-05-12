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
    
    // MARK: - PROGRAMMATIC
    func didRecieveMovies(_ movie: [Movie])
    func didRecieveTVSeries(_ series: [TVSeries])
    func didRecieveTotalPages(forType mediaType: MediaTypes, totalPages: Int)
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error)
}

final class UserListDetailsScreenPresenter {
    weak var view: UserListDetailsScreenViewProtocol?
    var router: UserListDetailsScreenRouterProtocol
    var interactor: UserListDetailsScreenInteractorProtocol
    
    private let listType: AccountListTypes
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
    
    // MARK: - PROGRAMMATIC
    func didRecieveMovies(_ movie: [Movie]) {
        self.movies = movie
        downloadGroup.leave()
    }
    
    func didRecieveTVSeries(_ series: [TVSeries]) {
        self.series = series
        downloadGroup.leave()
    }
    
    // MARK: - ERROR
    func didRecieveError(_ error: any Error) {
        self.view?.didRecieveError(error.localizedDescription, goesBack: true)
    }
}
