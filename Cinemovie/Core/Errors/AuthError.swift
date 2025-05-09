//
//  AuthError.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.02.2025.
//

import Foundation
import UIKit

enum AuthError: Error {
    case cantCreateRequestToken
    case networkError(NetworkError)
    case cantExchangeRequestTokenToAccessToken
    case notValidSessionID
    
    var localizedDescription: String {
        switch self {
        case .cantCreateRequestToken: "Error: Something is wrong with backend, please try again later"
        case .networkError(let error): "Error: Something is wrong with network \(error)"
        case .notValidSessionID: "Error: Session ID is not valid or its a guest session"
        case .cantExchangeRequestTokenToAccessToken: "Error: Something is wrong with backend, please try again later"
        }
    }
}
