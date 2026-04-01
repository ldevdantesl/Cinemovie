//
//  OtherAPISubService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2026.
//

import Foundation

protocol OtherAPISubServiceProtocol {
    func collectionDetails(collectionID: Int) async throws -> BelongsToCollectionDetails
}

final class OtherAPISubService: OtherAPISubServiceProtocol {
    private let httpClient: HTTPClientProtocol
    private let config: APIConfigurationProtocol
    
    private var queryParams: [String : String]{
        ["language" : config.language]
    }
    
    init(httpClient: HTTPClientProtocol, config: APIConfigurationProtocol) {
        self.httpClient = httpClient
        self.config = config
    }
    
    func collectionDetails(collectionID: Int) async throws -> BelongsToCollectionDetails {
        try await httpClient.request(OtherEndpoints.collectionDetails(collectionID: collectionID, extraParams: queryParams))
    }
}
