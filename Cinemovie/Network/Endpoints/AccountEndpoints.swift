//
//  AccountEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.04.2026.
//

import UIKit

enum AccountEndpoints: Endpoint {
    case accountDetails(accountID: String)
    
    var path: String {
        switch self {
        case .accountDetails(let accountID): return "/account/\(accountID)"
        }
    }
    
    var auth: EndpointAuth {
        return .bearer(CONSTANTS.apiReadAcessToken)
    }
}
