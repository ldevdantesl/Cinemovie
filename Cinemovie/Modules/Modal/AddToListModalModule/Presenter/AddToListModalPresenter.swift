//
//  AddToListModalPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 15.05.2025
//

import UIKit

protocol AddToListModalPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    func didReceiveLists(lists: [UserList], refreshing: Bool)
    func didReceiveItemStatusInList(listID: Int, status: Bool, refreshing: Bool)
    func didTapAddToList(userList: UserList)
    func didAddOrRemoveFromList()
    
    // MARK: - ERROR HANDLING
    func didReceiveError(_ error: Error)
    
    // MARK: - PROPERTIES
    var listAndStatus: [UserList : Bool] { get }
}

final class AddToListModalPresenter {
    weak var view: AddToListModalViewProtocol?
    var router: AddToListModalRouterProtocol
    var interactor: AddToListModalInteractorProtocol
    var listAndStatus: [UserList : Bool] = [:]
    
    private let downloadGroup = DispatchGroup()
    private let refreshGroup = DispatchGroup()
    private let itemID: Int
    private let mediaType: MediaTypes

    init(itemID: Int, mediaType: MediaTypes, interactor: AddToListModalInteractorProtocol, router: AddToListModalRouterProtocol) {
        self.itemID = itemID
        self.mediaType = mediaType
        self.interactor = interactor
        self.router = router
    }
}

extension AddToListModalPresenter: AddToListModalPresenterProtocol {
    func viewDidLoad() {
        self.view?.showLoadingView()
        
        downloadGroup.enter()
        interactor.getUserLists()
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.reloadData()
            self.view?.hideLoadingView(completion: nil)
        }
    }
    
    func didReceiveLists(lists: [UserList], refreshing: Bool) {
        self.listAndStatus.removeAll()
        lists.forEach {
            listAndStatus[$0] = false
            refreshing ? refreshGroup.enter() : downloadGroup.enter()
            interactor.getItemStatusInList(listID: $0.id, itemID: itemID, mediaType: mediaType, refreshing: refreshing)
        }
        refreshing ? refreshGroup.leave() : downloadGroup.leave()
    }
    
    func didReceiveItemStatusInList(listID: Int, status: Bool, refreshing: Bool) {
        if let list = listAndStatus.keys.first(where: { $0.id == listID }) {
            listAndStatus[list] = status
        }
        refreshing ? refreshGroup.leave() : downloadGroup.leave()
    }
    
    func didAddOrRemoveFromList() {
        refreshGroup.enter()
        self.interactor.refreshLists()
        refreshGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.reloadData()
            self.view?.hideLoadingView(completion: nil)
        }
    }
    
    func didTapAddToList(userList: UserList) {
        guard let status = listAndStatus[userList] else { return }
        self.view?.showLoadingView()
        if status {
            interactor.removeMediaFromList(listID: userList.id, mediaID: itemID, mediaType: mediaType)
        } else {
            interactor.addMediaToList(listID: userList.id, mediaID: itemID, mediaType: mediaType)
        }
    }
    
    // MARK: - ERROR HANDLING
    func didReceiveError(_ error: any Error) {
        self.view?.didReceiveError(error.localizedDescription)
    }
}
