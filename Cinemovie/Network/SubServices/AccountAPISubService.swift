//
//  AccountAPISubService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.04.2026.
//

import UIKit

protocol AccountAPISubServiceProtocol {
    func accountDetails(for accountID: String) async throws -> AccountDetails
}

final class AccountAPISubService: AccountAPISubServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func accountDetails(for accountID: String) async throws -> AccountDetails {
        try await httpClient.request(AccountEndpoints.accountDetails(accountID: accountID))
    }
}
