//
//  WatchlistScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol MyListsScreenPresenterProtocol: AnyObject {
    func viewDidLoad(refreshing: Bool)
    func didCallRefresh()
    func didTapAccountList(listType: AccountListTypes)
    func didTapUserList(userListDetails: UserListDetails)
    func didTapAddNewList()
    func didTapRemoveList(list: UserListDetails)
    var visibleSections: [MyListsScreenVC.Sections] { get set }
}

final class MyListsScreenPresenter {
    
    enum FetchResult {
        case watchlistMovies([Movie])
        case watchlistSeries([TVSeries])
        case favoriteMovies([Movie])
        case favoriteSeries([TVSeries])
        case ratedMovies([Movie])
        case ratedSeries([TVSeries])
        case userLists([UserList])
        case failure(Error)
    }
    
    typealias Sections = MyListsScreenVC.Sections
    typealias Items = MyListsScreenVC.Items

    weak var view: MyListsScreenViewProtocol?
    var router: MyListsScreenRouterProtocol
    var interactor: MyListsScreenInteractorProtocol

    var visibleSections: [MyListsScreenVC.Sections] = []
    private let authContext: AuthContextProtocol

    private var watchlistMedia: [MediaProtocol] = []
    private var favoriteMedia: [MediaProtocol] = []
    private var ratedMedia: [MediaProtocol] = []
    private var userListDetails: [UserListDetails] = []

    init(authContext: AuthContextProtocol, interactor: MyListsScreenInteractorProtocol, router: MyListsScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.authContext = authContext
    }

    private func sortedMedia(media: [MediaProtocol]) -> [MediaProtocol] {
        let movies = media.compactMap { $0 as? Movie }
        let series = media.compactMap { $0 as? TVSeries }
        return movies + series
    }
}

extension MyListsScreenPresenter: MyListsScreenPresenterProtocol {
    func viewDidLoad(refreshing: Bool) {
        refreshing ? () : self.view?.showDownloadingView()

        guard !authContext.isGuest else {
            let authenticateCell = MyListsAuthenticateCellViewModel { [weak self] in self?.router.navigateToLogin() }
            view?.applySnapshot(sections: [.unauthorized], itemsBySection: [.unauthorized: [.authorizeVM(authenticateCell)]])
            view?.hideDownloadingView()
            view?.refreshCompleted()
            return
        }

        Task { [weak self] in
            guard let self else { return }
            
            self.watchlistMedia = []
            self.favoriteMedia = []
            self.ratedMedia = []
            self.userListDetails = []

            let (lists, errors): ([UserList], [Error]) = await withTaskGroup(of: FetchResult.self) { group in
                group.addTask {
                    do { return .watchlistMovies(try await self.interactor.getWatchlistMovies()) }
                    catch { return .failure(error) }
                }
                group.addTask {
                    do { return .watchlistSeries(try await self.interactor.getWatchlistTVSeries()) }
                    catch { return .failure(error) }
                }
                group.addTask {
                    do { return .favoriteMovies(try await self.interactor.getFavoriteMovies()) }
                    catch { return .failure(error) }
                }
                group.addTask {
                    do { return .favoriteSeries(try await self.interactor.getFavoriteTVSeries()) }
                    catch { return .failure(error) }
                }
                group.addTask {
                    do { return .ratedMovies(try await self.interactor.getRatedMovies()) }
                    catch { return .failure(error) }
                }
                group.addTask {
                    do { return .ratedSeries(try await self.interactor.getRatedTVSeries()) }
                    catch { return .failure(error) }
                }
                group.addTask {
                    do { return .userLists(try await self.interactor.getUserLists()) }
                    catch { return .failure(error) }
                }
                
                var collectedLists: [UserList] = []
                var collectedErrors: [Error] = []
                
                for await result in group {
                    switch result {
                    case .watchlistMovies(let m):  self.watchlistMedia.append(contentsOf: m)
                    case .watchlistSeries(let s):  self.watchlistMedia.append(contentsOf: s)
                    case .favoriteMovies(let m):   self.favoriteMedia.append(contentsOf: m)
                    case .favoriteSeries(let s):   self.favoriteMedia.append(contentsOf: s)
                    case .ratedMovies(let m):      self.ratedMedia.append(contentsOf: m)
                    case .ratedSeries(let s):      self.ratedMedia.append(contentsOf: s)
                    case .userLists(let l):        collectedLists = l
                    case .failure(let e):          collectedErrors.append(e)
                    }
                }
                return (collectedLists, collectedErrors)
            }
            
            self.userListDetails = await withTaskGroup(of: UserListDetails?.self) { group in
                for list in lists {
                    group.addTask {
                        do { return try await self.interactor.getUserListDetails(list: list) }
                        catch { return nil }
                    }
                }
                return await group.reduce(into: []) { result, details in
                    if let details { result.append(details) }
                }
            }
            
            await MainActor.run {
                if let firstError = errors.first {
                    self.view?.showError(errorStr: firstError.localizedDescription)
                }
                self.didGetAllData(refreshing: refreshing)
            }
        }
    }

    func didCallRefresh() {
        viewDidLoad(refreshing: true)
    }

    func didTapAccountList(listType: AccountListTypes) {
        router.navigateToAccountList(listType: listType)
    }

    func didTapUserList(userListDetails: UserListDetails) {
        router.navigateToUserList(userListDetails: userListDetails)
    }

    func didTapAddNewList() {
        router.presentAddNewListPopUp { [weak self] listName, listDescription, isPublic in
            guard let self else { return }
            self.router.showLoadingBox()
            guard self.userListDetails.count < 5 else {
                self.router.hideLoadingBox(success: false, message: "Can't add more than 5 lists")
                return
            }
            Task {
                do {
                    try await self.interactor.createNewList(listName: listName, listDescription: listDescription, isPublic: isPublic)
                    await MainActor.run {
                        self.router.hideLoadingBox(success: true, message: "Successfully added new list")
                        self.didCallRefresh()
                    }
                } catch {
                    await MainActor.run { self.view?.showError(errorStr: error.localizedDescription) }
                }
            }
        }
    }

    func didTapRemoveList(list: UserListDetails) {
        Task {
            do {
                try await interactor.removeUserList(list: list)
                await MainActor.run { self.didCallRefresh() }
            } catch {
                await MainActor.run { self.view?.showError(errorStr: error.localizedDescription) }
            }
        }
    }

    // MARK: - PRIVATE
    private func didGetAllData(refreshing: Bool) {
        refreshing ? self.view?.refreshCompleted() : self.view?.hideDownloadingView()

        let watchlistVM = AccountListCellViewModel(media: sortedMedia(media: watchlistMedia), listType: .watchlist) { [weak self] in
            self?.didTapAccountList(listType: $0)
        }
        let favoriteVM = AccountListCellViewModel(media: sortedMedia(media: favoriteMedia), listType: .favorite) { [weak self] in
            self?.didTapAccountList(listType: $0)
        }
        let ratedVM = AccountListCellViewModel(media: sortedMedia(media: ratedMedia), listType: .rated) { [weak self] in
            self?.didTapAccountList(listType: $0)
        }

        let userLists: [Items] = self.userListDetails.map {
            Items.userListVM(
                UserListCellViewModel(userList: $0)
                { [weak self] in self?.didTapUserList(userListDetails: $0) }
                didTapRemoveList: { [weak self] in self?.didTapRemoveList(list: $0) }
            )
        }

        self.view?.applySnapshot(
            sections: [.accountLists, .userLists],
            itemsBySection: [
                .accountLists: [.accountListVM(watchlistVM), .accountListVM(favoriteVM), .accountListVM(ratedVM)],
                .userLists: userLists
            ]
        )
    }
}
