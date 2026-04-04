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
                await MainActor.run {
                    self.presenter?.didReceiveLists(lists: result)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didReceiveError(error)
                }
            }
        }
    }
    
    func getItemStatusInList(listID: Int, itemID: Int, mediaType: MediaTypes, refreshing: Bool) {
        Task {
            let status = await networkService.userList.getItemStatusInUserList(listID: listID, mediaID: itemID, mediaType: mediaType)
            await MainActor.run {
                self.presenter?.didReceiveItemStatusInList(listID: listID, status: status)
            }
        }
    }
    
    func addMediaToList(listID: Int, mediaID: Int, mediaType: MediaTypes) {
        Task {
            do {
                try await networkService.userList.addMediaInUserList(listID: listID, mediaID: mediaID, mediaType: mediaType)
                await MainActor.run {
                    self.presenter?.didAddOrRemoveFromList(added: true)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didReceieveErrorInBox(error)
                }
            }
        }
    }
    
    func removeMediaFromList(listID: Int, mediaID: Int, mediaType: MediaTypes) {
        Task {
            do {
                try await networkService.userList.removeMediaInUserList(listID: listID, mediaID: mediaID, mediaType: mediaType)
                await MainActor.run {
                    self.presenter?.didAddOrRemoveFromList(added: false)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didReceieveErrorInBox(error)
                }
            }
        }
    }
}
