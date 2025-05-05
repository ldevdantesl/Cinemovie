//
//  WatchlistDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//
import UIKit

protocol WatchlistDetailsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    // MARK: - USER INITIATED
    func didTapBackButton()
    func didTapAnyMedia(media: Media)
    func didCallRefresh()
    func didCallPagination()
    
    // MARK: - PROGRAMMATIC
    func didRecieveInitialMedia(_ media: [Media])
    func didRecieveRefreshingMedia(_ media: [Media])
    func didRecievePaginatedMedia(_ media: [Media])
    func didRecieveTotalPages(forType mediaType: MediaTypes, totalPages: Int)
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error)
}

final class WatchlistDetailsScreenPresenter {
    weak var view: WatchlistDetailsScreenViewProtocol?
    var router: WatchlistDetailsScreenRouterProtocol
    var interactor: WatchlistDetailsScreenInteractorProtocol
    
    private let listType: UserListTypes
    private let downloadGroup = DispatchGroup()
    private let refreshGroup = DispatchGroup()
    private var isPaginating = false
    
    private var movieTotalPages: Int = 0
    private var seriesTotalPages: Int = 0
    private var movieCurrentPage: Int = 1
    private var seriesCurrentPage: Int = 1
    
    private var didFinishInitialMovies = false
    private var didFinishInitialSeries = false
    
    private var media: [Media] = []
    
    init(listType: UserListTypes, interactor: WatchlistDetailsScreenInteractorProtocol, router: WatchlistDetailsScreenRouterProtocol) {
        self.listType = listType
        self.interactor = interactor
        self.router = router
    }
}

extension WatchlistDetailsScreenPresenter: WatchlistDetailsScreenPresenterProtocol {
    
    func viewDidLoad() {
        downloadGroup.enter()
        interactor.getInitialListMovies(listType: listType)
        
        downloadGroup.enter()
        interactor.getInitialListSeries(listType: listType)
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.downloadView.hide()
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
    
    func didCallRefresh() {
        refreshGroup.enter()
        interactor.getRefreshingListMovies(listType: listType)
        
        refreshGroup.enter()
        interactor.getRefreshingListSeries(listType: listType)
        
        refreshGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.refreshController.endRefreshing()
        }
    }

    func didCallPagination() {
        guard !isPaginating else { return }
        isPaginating = true
        
        var requested = false
        
        if movieTotalPages > movieCurrentPage {
            interactor.getPaginatedListMovies(listType: listType, page: movieCurrentPage + 1)
            requested = true
        }
        if seriesTotalPages > seriesCurrentPage {
            interactor.getPaginatedListSeries(listType: listType, page: seriesCurrentPage + 1)
            requested = true
        }
        
        if !requested {
            isPaginating = false
        } else {
            self.view?.showPaginatedLoading()
        }
    }
    
    func didRecieveTotalPages(forType mediaType: MediaTypes, totalPages: Int) {
        switch mediaType {
        case .movie: movieTotalPages = totalPages
        case .tvShow: seriesTotalPages = totalPages
        }
    }
    
    // MARK: - PROGRAMMATIC
    func didRecieveInitialMedia(_ media: [any Media]) {
        self.media.append(contentsOf: media)
        self.view?.reloadData(newItems: self.media)
        downloadGroup.leave()
    }
    
    func didRecieveRefreshingMedia(_ media: [any Media]) {
        let newIDs = Set(media.map { $0.id })
        self.media.removeAll { newIDs.contains($0.id) }
        self.media.insert(contentsOf: media, at: 0)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.refreshController.endRefreshing()
        }
        self.view?.reloadData(newItems: self.media)
        refreshGroup.leave()
    }
    
    func didRecievePaginatedMedia(_ media: [any Media]) {
        let startIndex = self.media.count
        self.media.append(contentsOf: media)
        let endIndex = self.media.count
        let indexPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
        if let _ = media as? [Movie] {
            movieCurrentPage += 1
        } else if let _ = media as? [TVSeries] {
            seriesCurrentPage += 1
        }
        self.view?.hidePaginatedLoading()
        self.view?.didReceievePaginatedItems(media, at: indexPaths)
    }
    
    // MARK: - ERROR
    func didRecieveError(_ error: any Error) {
        self.view?.didRecieveError(error.localizedDescription, goesBack: true)
    }
}
