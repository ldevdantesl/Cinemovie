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
    func didTapList(listType: UserListTypes)
    func didTapAddNewList()
    
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
        self.view?.showDownloadingView()
        
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
    
    func didTapList(listType: UserListTypes) {
        router.navigateToList(listType: listType)
    }
    
    func didTapAddNewList() {
        router.presentAddNewListPopUp { [weak self] listName, listDescription in
            guard let self = self else { return }
            self.view?.showDownloadingView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                guard let self = self else { return }
                self.view?.hideDownloadingView()
            }
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
        self.view?.hideDownloadingView()
        let watchlistVM = WatchlistItemCellViewModel(
            media: interLeavedMedia(media: watchlistMedia),
            listType: .watchlist
        ) { [weak self] in
            guard let self = self else { return }
            self.didTapList(listType: $0)
        }
        
        let favoriteVM = WatchlistItemCellViewModel(
            media: interLeavedMedia(media: favoriteMedia),
            listType: .favorite
        ) { [weak self] in
            guard let self = self else { return }
            self.didTapList(listType: $0)
        }
        
        let ratedVM = WatchlistItemCellViewModel(
            media: interLeavedMedia(media: ratedMedia),
            listType: .rated
        ) { [weak self] in
            guard let self = self else { return }
            self.didTapList(listType: $0)
        }
        
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
