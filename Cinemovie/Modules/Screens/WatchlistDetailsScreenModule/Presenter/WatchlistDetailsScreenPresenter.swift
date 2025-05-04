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
    
    // MARK: - PROGRAMMATIC
    func didRecieveMedia(_ media: [Media], refreshing: Bool)
    
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
        interactor.getWatchlistMovies(refreshing: false)
        
        downloadGroup.enter()
        interactor.getWatchlistSeries(refreshing: false)
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.reloadData(newItems: media)
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
        self.media = []
        refreshGroup.enter()
        interactor.getWatchlistMovies(refreshing: true)
        
        refreshGroup.enter()
        interactor.getWatchlistSeries(refreshing: true)
        
        refreshGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.reloadData(newItems: media)
        }
    }
    
    // MARK: - PROGRAMMATIC
    func didRecieveMedia(_ media: [any Media], refreshing: Bool) {
        self.media.append(contentsOf: media)
        refreshing ? refreshGroup.leave() : downloadGroup.leave()
    }
    
    // MARK: - ERROR
    func didRecieveError(_ error: any Error) {
        self.view?.didRecieveError(error.localizedDescription, goesBack: true)
    }
}
