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
    private var tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func getUserLists() {
        tmdbService.getUserLists { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveLists(lists: success.results)
            case .failure(let failure): self.presenter?.didReceiveError(failure)
            }
        }
    }
    
    func getItemStatusInList(listID: Int, itemID: Int, mediaType: MediaTypes, refreshing: Bool) {
        tmdbService.getItemStatusInUserList(listID: listID, mediaID: itemID, mediaType: mediaType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: self.presenter?.didReceiveItemStatusInList(listID: listID, status: true)
            case .failure: self.presenter?.didReceiveItemStatusInList(listID: listID, status: false)
            }
        }
    }
    
    func addMediaToList(listID: Int, mediaID: Int, mediaType: MediaTypes) {
        tmdbService.addOrRemoveMediaInUserList(listID: listID, mediaID: mediaID, mediaType: mediaType, adding: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: self.presenter?.didAddOrRemoveFromList()
            case .failure(let failure): self.presenter?.didReceiveError(failure)
            }
        }
    }
    
    func removeMediaFromList(listID: Int, mediaID: Int, mediaType: MediaTypes) {
        tmdbService.addOrRemoveMediaInUserList(listID: listID, mediaID: mediaID, mediaType: mediaType, adding: false) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: self.presenter?.didAddOrRemoveFromList()
            case .failure(let failure): self.presenter?.didReceiveError(failure)
            }
        }
    }
}
