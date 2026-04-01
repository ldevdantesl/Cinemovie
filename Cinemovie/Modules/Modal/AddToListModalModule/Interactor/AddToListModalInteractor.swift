//
//  AddToListModalInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 15.05.2025
//

import UIKit

protocol AddToListModalInteractorProtocol: AnyObject {
    func getUserLists()
    func getItemStatusInList(listID: Int, itemID: Int, mediaType: MediaTypes, refreshing: Bool)
    func addMediaToList(listID: Int, mediaID: Int, mediaType: MediaTypes)
    func removeMediaFromList(listID: Int, mediaID: Int, mediaType: MediaTypes)
}

final class AddToListModalInteractor: AddToListModalInteractorProtocol {
    weak var presenter: AddToListModalPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getUserLists() {
        Task {
            do {
                let result = try await networkService.userList.getUserLists(page: 1)
                self.presenter?.didReceiveLists(lists: result)
            } catch {
                self.presenter?.didReceiveError(error)
            }
        }
    }
    
    func getItemStatusInList(listID: Int, itemID: Int, mediaType: MediaTypes, refreshing: Bool) {
        Task {
            do {
                let _ = try await networkService.userList.getItemStatusInUserList(listID: listID, mediaID: itemID, mediaType: mediaType)
                self.presenter?.didReceiveItemStatusInList(listID: listID, status: true)
            } catch {
                self.presenter?.didReceiveItemStatusInList(listID: listID, status: false)
            }
        }
    }
    
    func addMediaToList(listID: Int, mediaID: Int, mediaType: MediaTypes) {
        Task {
            do {
                let _ = try await networkService.userList.addMediaInUserList(listID: listID, mediaID: mediaID, mediaType: mediaType)
                self.presenter?.didAddOrRemoveFromList(added: true)
            } catch {
                self.presenter?.didReceieveErrorInBox(error)
            }
        }
    }
    
    func removeMediaFromList(listID: Int, mediaID: Int, mediaType: MediaTypes) {
        Task {
            do {
                let _ = try await networkService.userList.removeMediaInUserList(listID: listID, mediaID: mediaID, mediaType: mediaType)
                self.presenter?.didAddOrRemoveFromList(added: false)
            } catch {
                self.presenter?.didReceieveErrorInBox(error)
            }
        }
    }
}
