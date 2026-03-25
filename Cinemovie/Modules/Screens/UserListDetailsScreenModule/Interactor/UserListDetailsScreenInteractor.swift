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
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getListDetails(listID: Int) {
        Task {
            do {
                let result = try await networkService.userList.getUserListDetails(listID: listID, page: 1)
                self.presenter?.didReceiveListDetails(result)
            } catch {
                self.presenter?.didReceiveError(error)
            }
        }
    }
    
    func getNewPageListDetails(listID: Int, page: Int) {
        Task {
            do {
                let result = try await networkService.userList.getUserListDetails(listID: listID, page: page)
                self.presenter?.didReceiveListDetails(result)
            } catch {
                self.presenter?.didReceiveError(error)
            }
        }
    }
    
    func refreshListDetails(listID: Int) {
        Task {
            do {
                let result = try await networkService.userList.getUserListDetails(listID: listID, page: 1)
                self.presenter?.didReceiveListDetails(result)
            } catch {
                self.presenter?.didReceiveError(error)
            }
        }
    }
}
