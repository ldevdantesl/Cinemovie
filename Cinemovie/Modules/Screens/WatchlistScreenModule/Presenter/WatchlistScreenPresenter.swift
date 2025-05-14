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
    func didTapAccountList(listType: AccountListTypes)
    func didTapUserList(listID: Int)
    func didTapAddNewList()
    func didTapRemoveList(list: UserList)
    
    // MARK: - WATCHLIST
    func didGetWatchlistMovies(_ movies: [Movie], refreshing: Bool)
    func didGetWatchlistTVSeries(_ series: [TVSeries], refreshing: Bool)
    
    // MARK: - FAVORITE
    func didGetFavoriteMovies(_ movies: [Movie], refreshing: Bool)
    func didGetFavoriteTVSeries(_ series: [TVSeries], refreshing: Bool)
    
    // MARK: - RATED
    func didGetRatedMovies(_ movies: [Movie], refreshing: Bool)
    func didGetRatedTVSeries(_ series: [TVSeries], refreshing: Bool)
    
    // MARK: - CUSTOM LISTS
    func didReceieveCustomLists(lists: [UserList], refreshing: Bool)
    func didRemoveList()
    
    // MARK: - PROGRAMMATIC
    func didCreateNewList()
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: Error)
    
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
    private var userCustomLists: [UserList] = []
    
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
        
        downloadGroup.enter()
        interactor.getCustomLists(refreshing: false)
        
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
        
        refreshGroup.enter()
        interactor.getCustomLists(refreshing: true)
        
        refreshGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.didGetAllData()
            self.view?.refreshCompleted()
        }
    }
    
    func didTapAccountList(listType: AccountListTypes) {
        router.navigateToAccountList(listType: listType)
    }
    
    func didTapUserList(listID: Int) {
        router.navigateToUserList(listID: listID)
    }
    
    func didTapAddNewList() {
        router.presentAddNewListPopUp { [weak self] listName, listDescription, isPublic in
            guard let self = self else { return }
            self.view?.showDownloadingView()
            self.interactor.createNewList(listName: listName, listDescription: listDescription, isPublic: isPublic)
        }
    }
    
    func didTapRemoveList(list: UserList) {
        interactor.removeCustomList(list: list)
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
    
    // MARK: - PROGRAMMATIC
    func didCreateNewList() {
        self.view?.hideDownloadingView()
        self.didCallRefresh()
        self.router.hidePopUp()
    }
    
    func didRecieveError(_ error: any Error) {
        self.view?.showError(errorStr: error.localizedDescription)
    }
    
    func didReceieveCustomLists(lists: [UserList], refreshing: Bool) {
        self.userCustomLists = lists
        refreshing ? refreshGroup.leave() : downloadGroup.leave()
    }
    
    func didRemoveList() {
        didCallRefresh()
    }
    
    // MARK: - PRIVATE FUNC
    private func didGetAllData() {
        self.view?.hideDownloadingView()
        let watchlistVM = AccountListCellViewModel(
            media: interLeavedMedia(media: watchlistMedia),
            listType: .watchlist
        ) { [weak self] in
            guard let self = self else { return }
            self.didTapAccountList(listType: $0)
        }
        
        let favoriteVM = AccountListCellViewModel(
            media: interLeavedMedia(media: favoriteMedia),
            listType: .favorite
        ) { [weak self] in
            guard let self = self else { return }
            self.didTapAccountList(listType: $0)
        }
        
        let ratedVM = AccountListCellViewModel(
            media: interLeavedMedia(media: ratedMedia),
            listType: .rated
        ) { [weak self] in
            guard let self = self else { return }
            self.didTapAccountList(listType: $0)
        }
        
        let userLists: [Items] = userCustomLists.map {
            Items.userListVM(
                UserListCellViewModel(userList: $0)
                { [weak self] in self?.didTapUserList(listID: $0.id) } didTapRemoveList:
                { [weak self] in self?.didTapRemoveList(list: $0) }
            )
        }
        
        self.view?.applySnapshot(
            sections: [.accountLists, .userLists],
            itemsBySection: [
                .accountLists : [
                    .accountListVM(watchlistVM),
                    .accountListVM(favoriteVM),
                    .accountListVM(ratedVM)
                ],
                .userLists : userLists
            ]
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
