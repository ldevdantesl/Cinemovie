//
//  UserListAPISubService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.02.2026.
//

import Foundation

protocol UserListAPISubServiceProtocol {
    func getUserLists(page: Int) async throws -> [UserList]
    func getUserListDetails(listID: Int, page: Int) async throws -> UserListDetails
    
    @discardableResult
    func createUserList(name: String, description: String?, isPublic: Bool) async throws -> TMDBStatusResponse
    
    @discardableResult
    func addMediaInUserList(listID: Int, mediaID: Int, mediaType: MediaTypes) async throws -> AddOrRemoveMediaUserListResponse
    
    @discardableResult
    func removeMediaInUserList(listID: Int, mediaID: Int, mediaType: MediaTypes) async throws -> AddOrRemoveMediaUserListResponse
    
    @discardableResult
    func removeUserList(listID: Int) async throws -> TMDBStatusResponse
    
    @discardableResult
    func getItemStatusInUserList(listID: Int, mediaID: Int, mediaType: MediaTypes) async -> Bool
}

final class UserListAPISubService: UserListAPISubServiceProtocol {
    private let httpClient: HTTPClientProtocol
    private let authContext: AuthContextProtocol
    private let config: APIConfigurationProtocol
    
    private var queryParams: [String : String] {
        ["language" : config.language]
    }
    
    init(httpClient: HTTPClientProtocol, authContext: AuthContextProtocol, config: APIConfigurationProtocol) {
        self.httpClient = httpClient
        self.authContext = authContext
        self.config = config
    }
    
    func getUserLists(page: Int) async throws -> [UserList] {
        guard let accountID = authContext.accountID, let accessToken = authContext.accessToken else { throw APIError.unauthorized }
        let response: PaginatedAPIResponse<UserList> = try await httpClient.request(UserListEndpoints.getUserLists(accountID: accountID, accessToken: accessToken, page: page))
        return response.results
    }
    
    func getUserListDetails(listID: Int, page: Int) async throws -> UserListDetails {
        guard let accessToken = authContext.accessToken else { throw APIError.unauthorized }
        return try await httpClient.request(UserListEndpoints.getUserListDetails(accessToken: accessToken, listID: listID, extraParams: queryParams, page: page))
    }
    
    func createUserList(name: String, description: String?, isPublic: Bool) async throws -> TMDBStatusResponse {
        guard let accessToken = authContext.accessToken else { throw APIError.unauthorized }
        return try await httpClient.request(UserListEndpoints.createUserList(accessToken: accessToken, name: name, description: description, queryParams: queryParams, isPublic: isPublic))
    }
    
    func addMediaInUserList(listID: Int, mediaID: Int, mediaType: MediaTypes) async throws -> AddOrRemoveMediaUserListResponse {
        guard let accessToken = authContext.accessToken else { throw APIError.unauthorized }
        return try await httpClient.request(UserListEndpoints.addMediaInUserList(accessToken: accessToken, listID: listID, mediaID: mediaID, mediaType: mediaType))
    }
    
    func removeMediaInUserList(listID: Int, mediaID: Int, mediaType: MediaTypes) async throws -> AddOrRemoveMediaUserListResponse {
        guard let accessToken = authContext.accessToken else { throw APIError.unauthorized }
        return try await httpClient.request(UserListEndpoints.removeMediaInUserList(accessToken: accessToken, listID: listID, mediaID: mediaID, mediaType: mediaType))
    }
    
    func removeUserList(listID: Int) async throws -> TMDBStatusResponse {
        guard let accessToken = authContext.accessToken else { throw APIError.unauthorized }
        return try await httpClient.request(UserListEndpoints.removeUserList(accessToken: accessToken, listID: listID))
    }
    
    func getItemStatusInUserList(listID: Int, mediaID: Int, mediaType: MediaTypes) async -> Bool {
        guard let accessToken = authContext.accessToken else { return false }
        do {
            let response: ItemStatusInUserListResponse = try await httpClient.request(
                UserListEndpoints.getItemStatusInUserList(
                    accessToken: accessToken,
                    listID: listID,
                    mediaID: mediaID,
                    mediaType: mediaType
                )
            )
            return response.success
        } catch APIError.statusCode(404, _) {
            return false
        } catch {
            print("Unexpected error checking item status: \(error)")
            return false
        }
    }
}
