//
//  AddToListModalPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 15.05.2025
//

import UIKit

protocol AddToListModalPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    func didReceiveLists(lists: [UserList])
    func didReceiveItemStatusInList(listID: Int, status: Bool)
    func didTapAddToList(userList: UserList)
    func didAddOrRemoveFromList()
    
    // MARK: - ERROR HANDLING
    func didReceiveError(_ error: Error)
    
    // MARK: - PROPERTIES
    var listAndStatus: [UserListStatus] { get }
}

final class AddToListModalPresenter {
    weak var view: AddToListModalViewProtocol?
    var router: AddToListModalRouterProtocol
    var interactor: AddToListModalInteractorProtocol
    var listAndStatus: [UserListStatus] = []
    
    private let downloadGroup = DispatchGroup()
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
    
    func didReceiveLists(lists: [UserList]) {
        self.listAndStatus = lists.map {
            downloadGroup.enter()
            interactor.getItemStatusInList(listID: $0.id, itemID: itemID, mediaType: mediaType, refreshing: false)
            return UserListStatus(list: $0, isInList: false)
        }
        downloadGroup.leave()
    }
    
    func didReceiveItemStatusInList(listID: Int, status: Bool) {
        guard let index = listAndStatus.firstIndex(where: { $0.list.id == listID }) else { downloadGroup.leave(); return }
        listAndStatus[index].isInList = status
        downloadGroup.leave()
    }
    
    func didAddOrRemoveFromList() {
        self.view?.hideLoadingView(completion: router.goBack)
    }
    
    func didTapAddToList(userList: UserList) {
        guard let index = listAndStatus.firstIndex(where: { $0.list.id == userList.id }) else { return }
        let status = listAndStatus[index].isInList
        self.view?.showLoadingView()
        
        status ?
        interactor.removeMediaFromList(listID: userList.id, mediaID: itemID, mediaType: mediaType) :
        interactor.addMediaToList(listID: userList.id, mediaID: itemID, mediaType: mediaType)
    }
    
    // MARK: - ERROR HANDLING
    func didReceiveError(_ error: any Error) {
        self.view?.didReceiveError(error.localizedDescription)
    }
}
