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
    
    // MARK: - ERROR HANDLING
    func didReceiveError(_ error: Error)
}

final class UserListDetailsScreenPresenter {
    // MARK: - TYPEALIASES
    typealias Sections = UserListDetailsScreenVC.Sections
    typealias Items = UserListDetailsScreenVC.Items
    
    weak var view: UserListDetailsScreenViewProtocol?
    var router: UserListDetailsScreenRouterProtocol
    var interactor: UserListDetailsScreenInteractorProtocol
    
    private let listID: Int
    private let downloadGroup = DispatchGroup()
    private var userListDetails: UserListDetails?
    
    private var media: [Media] = []

    init(listID: Int, interactor: UserListDetailsScreenInteractorProtocol, router: UserListDetailsScreenRouterProtocol) {
        print("List ID: \(listID)")
        self.listID = listID
        self.interactor = interactor
        self.router = router
    }
}

extension UserListDetailsScreenPresenter: UserListDetailsScreenPresenterProtocol {
    func viewDidLoad() {
        self.view?.showDownloadingView()
        downloadGroup.enter()
        interactor.getListDetails(listID: listID)
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.didDownloadListDetails()
        }
    }
    
    // MARK: - USER INITIATED
    func didCallRefresh() {
        
    }
    
    func didCallPagination() {
        
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
        self.media = AnyMedia.toMedia(from: details.results)
        downloadGroup.leave()
    }
    
    // MARK: - PRIVATE FUNC
    private func didDownloadListDetails() {
        self.view?.hideDownloadingView()
        let vms = self.media.map {
            Items.posterImageVM(MediaPosterImageCellViewModel(media: $0) { [weak self] in self?.didTapMedia(media: $0)})
        }
        self.view?.applySnapshot(
            sections: [.main],
            itemsBySection: [.main : vms]
        )
    }
    
    // MARK: - ERROR HANDLING
    func didReceiveError(_ error: any Error) {
        self.view?.didReceiveError(error.localizedDescription, goesBack: true)
    }
}
