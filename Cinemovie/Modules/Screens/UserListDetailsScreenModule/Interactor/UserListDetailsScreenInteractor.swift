//
//  UserListDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 14.05.2025
//

import UIKit

protocol UserListDetailsScreenInteractorProtocol: AnyObject {
    func getListDetails(listID: Int)
    func refreshListDetails(listID: Int)
    func getNewPageListDetails(listID: Int, page: Int)
}

final class UserListDetailsScreenInteractor: UserListDetailsScreenInteractorProtocol {
    weak var presenter: UserListDetailsScreenPresenterProtocol?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func getListDetails(listID: Int) {
        tmdbService.getUserListDetails(listID: listID, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveListDetails(success)
            case .failure(let failure): self.presenter?.didReceiveError(failure)
            }
        }
    }
    
    func getNewPageListDetails(listID: Int, page: Int) {
        tmdbService.getUserListDetails(listID: listID, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveListDetails(success)
            case .failure(let failure): self.presenter?.didReceiveError(failure)
            }
        }
    }
    
    func refreshListDetails(listID: Int) {
        tmdbService.getUserListDetails(listID: listID, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceieveRefreshingMedia(success.results)
            case .failure(let failure): self.presenter?.didReceiveError(failure)
            }
        }
    }
}
