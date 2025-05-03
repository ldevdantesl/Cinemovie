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
    
    // MARK: - WATCHLIST
    func didGetWatchlistMovies(_ movies: [Movie], refreshing: Bool)
    func didGetWatchlistTVSeries(_ series: [TVSeries], refreshing: Bool)
    
    // MARK: - FAVORITE
    func didGetFavoriteMovies(_ movies: [Movie], refreshing: Bool)
    func didGetFavoriteTVSeries(_ series: [TVSeries], refreshing: Bool)
    
    // MARK: - RATED
    func didGetRatedMovies(_ movies: [Movie], refreshing: Bool)
    func didGetRatedTVSeries(_ series: [TVSeries], refreshing: Bool)
    
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
    
    private var watchlistMedia: [Media] = []
    private var favoriteMedia: [Media] = []
    private var ratedMedia: [Media] = []
    
    init(interactor: WatchlistScreenInteractorProtocol, router: WatchlistScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension WatchlistScreenPresenter: WatchlistScreenPresenterProtocol {
    func viewDidLoad() {
        downloadGroup.enter()
        interactor.getFavoriteMovies(refreshing: false)
        
        downloadGroup.enter()
        interactor.getFavoriteTVSeries(refreshing: false)
        
        downloadGroup.enter()
        interactor.getWatchlistMovies(refreshing: false)
        
        downloadGroup.enter()
        interactor.getWatchlistTVSeries(refreshing: false)
        
        downloadGroup.enter()
        interactor.getRatedMovies(refreshing: false)
        
        downloadGroup.enter()
        interactor.getRatedTVSeries(refreshing: false)
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.didGetAllData()
        }
    }
    
    // MARK: - USER INITIATED
    func didCallRefresh() {
        self.watchlistMedia = []
        self.favoriteMedia = []
        self.ratedMedia = []
        
        refreshGroup.enter()
        interactor.getFavoriteMovies(refreshing: true)
        
        refreshGroup.enter()
        interactor.getFavoriteTVSeries(refreshing: true)
        
        refreshGroup.enter()
        interactor.getWatchlistMovies(refreshing: true)
        
        refreshGroup.enter()
        interactor.getWatchlistTVSeries(refreshing: true)
        
        refreshGroup.enter()
        interactor.getRatedMovies(refreshing: true)
        
        refreshGroup.enter()
        interactor.getRatedTVSeries(refreshing: true)
        
        refreshGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.didGetAllData()
            self.view?.refreshCompleted()
        }
    }
    
    // MARK: - WATCHLIST
    func didGetWatchlistMovies(_ movies: [Movie], refreshing: Bool) {
        self.watchlistMedia.append(contentsOf: movies)
        refreshing ? refreshGroup.leave() : downloadGroup.leave()
    }
    
    func didGetWatchlistTVSeries(_ series: [TVSeries], refreshing: Bool) {
        self.watchlistMedia.append(contentsOf: series)
        refreshing ? refreshGroup.leave() : downloadGroup.leave()
    }
    
    // MARK: - FAVORITE
    func didGetFavoriteMovies(_ movies: [Movie], refreshing: Bool) {
        self.favoriteMedia.append(contentsOf: movies)
        refreshing ? refreshGroup.leave() : downloadGroup.leave()
    }
    
    func didGetFavoriteTVSeries(_ series: [TVSeries], refreshing: Bool) {
        self.favoriteMedia.append(contentsOf: series)
        refreshing ? refreshGroup.leave() : downloadGroup.leave()
    }
    
    // MARK: - RATED
    func didGetRatedMovies(_ movies: [Movie], refreshing: Bool) {
        self.ratedMedia.append(contentsOf: movies)
        refreshing ? refreshGroup.leave() : downloadGroup.leave()
    }
    
    func didGetRatedTVSeries(_ series: [TVSeries], refreshing: Bool) {
        self.ratedMedia.append(contentsOf: series)
        refreshing ? refreshGroup.leave() : downloadGroup.leave()
    }
    
    private func didGetAllData() {
        self.view?.downloadingView.hide()
        let watchlistVM = ZStackMediaListCellViewModel(media: interLeavedMedia(media: watchlistMedia), title: "Watchlist", subtitle: "Added to Watchlist")
        let favoriteVM = ZStackMediaListCellViewModel(media: interLeavedMedia(media: favoriteMedia), title: "Favorites", subtitle: "Added To Favorites")
        let ratedVM = ZStackMediaListCellViewModel(media: interLeavedMedia(media: ratedMedia), title: "Rated", subtitle: nil)
        self.view?.applySnapshot(
            sections: [.watchlist],
            itemsBySection: [.watchlist : [
                .zStackMediaListVM(watchlistVM),
                .zStackMediaListVM(favoriteVM),
                .zStackMediaListVM(ratedVM)
            ]]
        )
    }
    
    private func interLeavedMedia(media: [Media]) -> [Media] {
        let movies = media.compactMap { $0 as? Movie }
        let series = media.compactMap { $0 as? TVSeries }
        
        var interleaved: [Media] = []
        let count = max(movies.count, series.count)
        
        for i in 0..<count {
            if i < movies.count { interleaved.append(movies[i]) }
            if i < series.count { interleaved.append(series[i]) }
        }
        
        return interleaved
    }
}
