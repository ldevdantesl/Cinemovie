//
//  WatchlistScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol MyListsScreenPresenterProtocol: AnyObject {
    func viewDidLoad(refreshing: Bool)
    
    // MARK: - USER INITIATED
    func didCallRefresh()
    func didTapAccountList(listType: AccountListTypes)
    func didTapUserList(userListDetails: UserListDetails)
    func didTapAddNewList()
    func didTapRemoveList(list: UserListDetails)
    
    // MARK: - WATCHLIST
    func didGetWatchlistMovies(_ movies: [Movie])
    func didGetWatchlistTVSeries(_ series: [TVSeries])
    
    // MARK: - FAVORITE
    func didGetFavoriteMovies(_ movies: [Movie])
    func didGetFavoriteTVSeries(_ series: [TVSeries])
    
    // MARK: - RATED
    func didGetRatedMovies(_ movies: [Movie])
    func didGetRatedTVSeries(_ series: [TVSeries])
    
    // MARK: - USER LISTS
    func didReceieveUserLists(lists: [UserList])
    func didReceiveUserListDetails(_ details: UserListDetails)
    func didRemoveList()
    
    // MARK: - PROGRAMMATIC
    func didCreateNewList()
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: Error)
    
    // MARK: - PROPERTIES
    var visibleSections: [MyListsScreenVC.Sections] { get set }
}

final class MyListsScreenPresenter {
    // MARK: - TYPEALIASES
    typealias Sections = MyListsScreenVC.Sections
    typealias Items = MyListsScreenVC.Items
    
    // MARK: - VIPER
    weak var view: MyListsScreenViewProtocol?
    var router: MyListsScreenRouterProtocol
    var interactor: MyListsScreenInteractorProtocol
    var visibleSections: [MyListsScreenVC.Sections] = []
    
    // MARK: - PRIVATE PROPERTIES
    private let downloadGroup = DispatchGroup()
    
    private var watchlistMedia: [MediaProtocol] = []
    private var favoriteMedia: [MediaProtocol] = []
    private var ratedMedia: [MediaProtocol] = []
    private var userListDetails: [UserListDetails] = []
    
    init(interactor: MyListsScreenInteractorProtocol, router: MyListsScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - PRIVATE FUNC
    private func sortedMedia(media: [MediaProtocol]) -> [MediaProtocol] {
        let movies = media.compactMap { $0 as? Movie }
        let series = media.compactMap { $0 as? TVSeries }
        return movies + series
    }
}

extension MyListsScreenPresenter: MyListsScreenPresenterProtocol {
    func viewDidLoad(refreshing: Bool) {
        refreshing ? () : self.view?.showDownloadingView()
        
        self.watchlistMedia = []
        self.favoriteMedia = []
        self.ratedMedia = []
        self.userListDetails = []
        
        downloadGroup.enter()
        interactor.getFavoriteMovies()
        
        downloadGroup.enter()
        interactor.getFavoriteTVSeries()
        
        downloadGroup.enter()
        interactor.getWatchlistMovies()
        
        downloadGroup.enter()
        interactor.getWatchlistTVSeries()
        
        downloadGroup.enter()
        interactor.getRatedMovies()
        
        downloadGroup.enter()
        interactor.getRatedTVSeries()
        
        downloadGroup.enter()
        interactor.getUserLists()
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.didGetAllData(refreshing: refreshing)
        }
    }
    
    // MARK: - USER INITIATED
    func didCallRefresh() {
        self.viewDidLoad(refreshing: true)
    }
    
    func didTapAccountList(listType: AccountListTypes) {
        router.navigateToAccountList(listType: listType)
    }
    
    func didTapUserList(userListDetails: UserListDetails) {
        router.navigateToUserList(userListDetails: userListDetails)
    }
    
    func didTapAddNewList() {
        router.presentAddNewListPopUp { [weak self] listName, listDescription, isPublic in
            guard let self = self else { return }
            self.router.showLoadingBox()
            if self.userListDetails.count >= 5 {
                self.router.hideLoadingBox(success: false, message: "Can't add more than 5 lists")
            } else {
                self.interactor.createNewList(listName: listName, listDescription: listDescription, isPublic: isPublic)
            }
        }
    }
    
    func didTapRemoveList(list: UserListDetails) {
        interactor.removeUserList(list: list)
    }
    
    // MARK: - WATCHLIST
    func didGetWatchlistMovies(_ movies: [Movie]) {
        self.watchlistMedia.append(contentsOf: movies)
        downloadGroup.leave()
    }
    
    func didGetWatchlistTVSeries(_ series: [TVSeries]) {
        self.watchlistMedia.append(contentsOf: series)
        downloadGroup.leave()
    }
    
    // MARK: - FAVORITE
    func didGetFavoriteMovies(_ movies: [Movie]) {
        self.favoriteMedia.append(contentsOf: movies)
        downloadGroup.leave()
    }
    
    func didGetFavoriteTVSeries(_ series: [TVSeries]) {
        self.favoriteMedia.append(contentsOf: series)
        downloadGroup.leave()
    }
    
    // MARK: - RATED
    func didGetRatedMovies(_ movies: [Movie]) {
        self.ratedMedia.append(contentsOf: movies)
        downloadGroup.leave()
    }
    
    func didGetRatedTVSeries(_ series: [TVSeries]) {
        self.ratedMedia.append(contentsOf: series)
        downloadGroup.leave()
    }
    
    // MARK: - USER LIST
    func didReceieveUserLists(lists: [UserList]) {
        lists.forEach {
            downloadGroup.enter()
            interactor.getUserListDetails(list: $0)
        }
        downloadGroup.leave()
    }
    
    func didReceiveUserListDetails(_ details: UserListDetails) {
        self.userListDetails.append(details)
        downloadGroup.leave()
    }
    
    // MARK: - PROGRAMMATIC
    func didCreateNewList() {
        self.router.hideLoadingBox(success: true, message: "Successfully added new list")
        self.didCallRefresh()
    }
    
    func didRemoveList() {
        didCallRefresh()
    }
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: any Error) {
        self.view?.showError(errorStr: error.localizedDescription)
        downloadGroup.leave()
    }
    
    // MARK: - PRIVATE FUNC
    private func didGetAllData(refreshing: Bool) {
        refreshing ? self.view?.refreshCompleted() : self.view?.hideDownloadingView()
        
        let watchlistVM = AccountListCellViewModel(
            media: sortedMedia(media: watchlistMedia),
            listType: .watchlist
        ) { [weak self] in
            guard let self = self else { return }
            self.didTapAccountList(listType: $0)
        }
        
        let favoriteVM = AccountListCellViewModel(
            media: sortedMedia(media: favoriteMedia),
            listType: .favorite
        ) { [weak self] in
            guard let self = self else { return }
            self.didTapAccountList(listType: $0)
        }
        
        let ratedVM = AccountListCellViewModel(
            media: sortedMedia(media: ratedMedia),
            listType: .rated
        ) { [weak self] in
            guard let self = self else { return }
            self.didTapAccountList(listType: $0)
        }
        
        let userLists: [Items] = self.userListDetails.map {
            Items.userListVM(
                UserListCellViewModel(userList: $0)
                { [weak self] in self?.didTapUserList(userListDetails: $0) } didTapRemoveList:
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
}
