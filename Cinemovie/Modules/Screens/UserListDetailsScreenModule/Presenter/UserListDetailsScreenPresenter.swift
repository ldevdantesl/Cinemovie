//
//  UserListDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 14.05.2025
//
import UIKit

protocol UserListDetailsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    // MARK: - USER INITIATED
    func didCallRefresh()
    func didCallPagination()
    func didTapBackButton()
    func didTapMedia(media: Media)
    
    // MARK: - PROGRAMMATIC
    func didReceiveListDetails(_ details: UserListDetails)
    func didReceivePaginatedListDetails(_ details: UserListDetails)
    func didReceiveNewMedia(_ media: [AnyMedia])
    func didReceieveRefreshingMedia(_ media: [AnyMedia])
    
    // MARK: - ERROR HANDLING
    func didReceiveError(_ error: Error)
    
    // MARK: - PROPERTIES
    var media: [Media] { get }
    var userList: UserList { get }
}

final class UserListDetailsScreenPresenter {
    // MARK: - TYPEALIASES
    typealias Sections = UserListDetailsScreenVC.Sections
    typealias Items = UserListDetailsScreenVC.Items
    
    weak var view: UserListDetailsScreenViewProtocol?
    var router: UserListDetailsScreenRouterProtocol
    var interactor: UserListDetailsScreenInteractorProtocol
    var media: [Media] = []
    let userList: UserList
    
    private var userListDetails: UserListDetails?
    private var currentPage: Int = 1

    init(userList: UserList, interactor: UserListDetailsScreenInteractorProtocol, router: UserListDetailsScreenRouterProtocol) {
        print("List ID: \(userList.id)")
        self.userList = userList
        self.interactor = interactor
        self.router = router
    }
}

extension UserListDetailsScreenPresenter: UserListDetailsScreenPresenterProtocol {
    func viewDidLoad() {
        self.view?.showDownloadingView()
        interactor.getListDetails(listID: userList.id)
    }
    
    // MARK: - USER INITIATED
    func didCallRefresh() {
        interactor.refreshListDetails(listID: userList.id)
    }
    
    func didCallPagination() {
        interactor.getNewPageListDetails(listID: userList.id, page: currentPage + 1)
    }
    
    func didTapBackButton() {
        router.goBack()
    }
    
    func didTapMedia(media: any Media) {
        if let movie = media as? Movie {
            router.navigateToMovie(movie: movie)
        } else if let series = media as? TVSeries {
            router.navigateToSeries(series: series)
        }
    }
    
    // MARK: - PROGRAMMATIC
    func didReceiveListDetails(_ details: UserListDetails) {
        self.userListDetails = details
        
        defer {
            self.view?.hideDownloadingView()
        }
        
        guard !details.results.isEmpty else {
            let notFoundVM = UnavailableInfoCellViewModel(
                title: "Nothing found",
                subtitle: "Add items to the list to see them here",
                image: UIImage(named: ImageNames.addMovie.rawValue)
            )
                
            self.view?.applySnapshot(
                sections: [.main, .notFound],
                itemsBySection: [.main : [], .notFound : [Items.unavailableVM(notFoundVM)]]
            )
            return
        }
        
        self.media = AnyMedia.toMedia(from: details.results)
        let vms = self.media.map {
            Items.posterImageVM(MediaPosterImageCellViewModel(media: $0) { [weak self] in self?.didTapMedia(media: $0)})
        }
        self.view?.applySnapshot(
            sections: [.main],
            itemsBySection: [.main : vms]
        )
    }
    
    func didReceivePaginatedListDetails(_ details: UserListDetails) {
        defer {
            self.view?.hidePaginationLoadingIndicator()
        }
        
        self.userListDetails = details
        guard !details.results.isEmpty else { return }
        
        let newMedia = AnyMedia.toMedia(from: details.results)
        self.media.append(contentsOf: newMedia)
        let vms = self.media.map {
            Items.posterImageVM(MediaPosterImageCellViewModel(media: $0) { [weak self] in self?.didTapMedia(media: $0)})
        }
        self.view?.applySnapshot(
            sections: [.main],
            itemsBySection: [.main : vms]
        )
        self.currentPage += 1
    }
    
    func didReceiveNewMedia(_ media: [AnyMedia]) {
        guard !media.isEmpty else { return }
        let newMedia = AnyMedia.toMedia(from: media)
        self.media.append(contentsOf: newMedia)
        self.currentPage += 1
        let vms = self.media.map {
            Items.posterImageVM(MediaPosterImageCellViewModel(media: $0) { [weak self] in self?.didTapMedia(media: $0)})
        }
        self.view?.applySnapshot(
            sections: [.main],
            itemsBySection: [.main : vms]
        )
    }
    
    func didReceieveRefreshingMedia(_ media: [AnyMedia]) {
        self.currentPage = 1
        
        defer {
            self.view?.stopRefreshing()
        }
        
        guard !media.isEmpty else {
            let notFoundVM = UnavailableInfoCellViewModel(
                title: "Nothing found",
                subtitle: "Add items to the list to see them here",
                image: UIImage(named: ImageNames.addMovie.rawValue)
            )
                
            self.view?.applySnapshot(
                sections: [.main, .notFound],
                itemsBySection: [.main : [], .notFound : [Items.unavailableVM(notFoundVM)]]
            )
            return
        }
        
        let refreshingMedia = AnyMedia.toMedia(from: media)
        self.media = refreshingMedia
        let mediaItems = self.media.map {
                Items.posterImageVM(.init(media: $0) { [weak self] in
                    self?.didTapMedia(media: $0)
                }
            )
        }
        
        self.view?.applySnapshot(
            sections: [.main],
            itemsBySection: [.main : mediaItems]
        )
    }
    
    // MARK: - ERROR HANDLING
    func didReceiveError(_ error: any Error) {
        self.view?.didReceiveError(error.localizedDescription, goesBack: true)
    }
}
