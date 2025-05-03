//
//  WatchlistScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol WatchlistScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    // MARK: - USER INITIATED
    func didCallRefresh()
    
    // MARK: - PROGRAMMATIC
    func didGetWatchlistMovies(_ movies: [Movie], refreshing: Bool)
    func didGetFavoriteMovies(_ movies: [Movie], refreshing: Bool)
    func didGetRatedMovies(_ movies: [Movie], refreshing: Bool)
    
    // MARK: - PROPERTIES
    var visibleSections: [WatchlistScreenVC.Sections] { get set }
}

final class WatchlistScreenPresenter {
    // MARK: - TYPEALIASES
    typealias Sections = WatchlistScreenVC.Sections
    typealias Items = WatchlistScreenVC.Items
    
    // MARK: - VIPER
    weak var view: WatchlistScreenViewProtocol?
    var router: WatchlistScreenRouterProtocol
    var interactor: WatchlistScreenInteractorProtocol
    var visibleSections: [WatchlistScreenVC.Sections] = []
        
    // MARK: - PRIVATE PROPERTIES
    private let downloadGroup = DispatchGroup()
    private let refreshGroup = DispatchGroup()
    
    private var watchlistMovies: [Movie] = []
    private var favoriteMovies: [Movie] = []
    private var ratedMovies: [Movie] = []

    init(interactor: WatchlistScreenInteractorProtocol, router: WatchlistScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension WatchlistScreenPresenter: WatchlistScreenPresenterProtocol {
    func viewDidLoad() {
        downloadGroup.enter()
        interactor.getWatchlistMovies(refreshing: false)
        
        downloadGroup.enter()
        interactor.getFavoriteMovies(refreshing: false)
        
        downloadGroup.enter()
        interactor.getRatedMovies(refreshing: false)
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.didGetAllData()
        }
    }
    
    // MARK: - USER INITIATED
    func didCallRefresh() {
        refreshGroup.enter()
        interactor.getFavoriteMovies(refreshing: true)
        
        refreshGroup.enter()
        interactor.getWatchlistMovies(refreshing: true)
        
        refreshGroup.enter()
        interactor.getRatedMovies(refreshing: true)
        
        refreshGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.didGetAllData()
            self.view?.refreshCompleted()
        }
    }
    
    // MARK: - PROGRAMMATIC
    func didGetWatchlistMovies(_ movies: [Movie], refreshing: Bool) {
        self.watchlistMovies = movies
        refreshing ? refreshGroup.leave() : downloadGroup.leave()
    }
    
    func didGetFavoriteMovies(_ movies: [Movie], refreshing: Bool) {
        self.favoriteMovies = movies
        refreshing ? refreshGroup.leave() : downloadGroup.leave()
    }
    
    func didGetRatedMovies(_ movies: [Movie], refreshing: Bool) {
        self.ratedMovies = movies
        refreshing ? refreshGroup.leave() : downloadGroup.leave()
    }
    
    private func didGetAllData() {
        self.view?.downloadingView.hide()
        let watchlistVM = ZStackMediaListCellViewModel(media: watchlistMovies, title: "Watchlist", subtitle: "Added to Watchlist")
        let favoriteVM = ZStackMediaListCellViewModel(media: favoriteMovies, title: "Favorites", subtitle: "Added To Favorites")
        let ratedVM = ZStackMediaListCellViewModel(media: ratedMovies, title: "Rated", subtitle: nil)
        self.view?.applySnapshot(
            sections: [.watchlist],
            itemsBySection: [.watchlist : [
                .zStackMediaListVM(watchlistVM),
                .zStackMediaListVM(favoriteVM),
                .zStackMediaListVM(ratedVM)
            ]]
        )
    }
}
