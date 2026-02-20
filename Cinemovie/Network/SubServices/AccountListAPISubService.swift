//
//  AccountListAPISubService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2026.
//

import Foundation

protocol AccountListAPISubServiceProtocol {
    func getMedia<T: MediaProtocol>(mediaType: MediaTypes, listType: AccountListTypes, page: Int) async throws -> [T]
    
    @discardableResult
    func addMediaInAccountList(mediaID: Int, listType: AccountListTypes, mediaType: MediaTypes) async throws -> TMDBStatusResponse
    @discardableResult
    func removeMediaInAccountList(mediaID: Int, listType: AccountListTypes, mediaType: MediaTypes) async throws -> TMDBStatusResponse
}

final class AccountListAPISubService: AccountListAPISubServiceProtocol {
    private let httpClient: HTTPClientProtocol
    private let authContext: AuthContextProtocol
    
    init(httpClient: HTTPClientProtocol, authContext: AuthContextProtocol) {
        self.httpClient = httpClient
        self.authContext = authContext
    }
    
    func getMedia<T: MediaProtocol>(mediaType: MediaTypes, listType: AccountListTypes, page: Int) async throws -> [T] {
        guard let accountID = authContext.accountID,
              let accessToken = authContext.accessToken else { throw APIError.unauthorized }
        
        let response: PaginatedAPIResponse<T> = try await httpClient.request(
            AccountListEndpoints.getMedia(
                accountID: accountID, accessToken: accessToken,
                mediaType: mediaType, listType: listType, page: page
            )
        )
        return response.result
    }
    
    func addMediaInAccountList(mediaID: Int, listType: AccountListTypes, mediaType: MediaTypes) async throws -> TMDBStatusResponse {
        guard let accountID = authContext.accountID,
              let accessToken = authContext.accessToken else { throw APIError.unauthorized }
        
        return try await httpClient.request(AccountListEndpoints.addMediaInAccountList(accountID: accountID, accessToken: accessToken, mediaID: mediaID, listType: listType, mediaType: mediaType))
    }
    
    func removeMediaInAccountList(mediaID: Int, listType: AccountListTypes, mediaType: MediaTypes) async throws -> TMDBStatusResponse {
        guard let accountID = authContext.accountID,
              let accessToken = authContext.accessToken else { throw APIError.unauthorized }
        
        return try await httpClient.request(AccountListEndpoints.removeMediaInAccountList(accountID: accountID, accessToken: accessToken, mediaID: mediaID, listType: listType, mediaType: mediaType))
    }
}
