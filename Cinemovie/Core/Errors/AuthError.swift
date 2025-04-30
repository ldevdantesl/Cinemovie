//
//  AuthError.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.02.2025.
//

import Foundation
import UIKit

enum AuthError: Error {
    case invalidCredentials
    case networkError(NetworkError)
    case userCancelled
    case notValidSessionID
    case custom(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidCredentials: "Error: Error with credentials"
        case .networkError(let error): "Error: Something is wrong with network \(error)"
        case .userCancelled: "Error: User cancelled"
        case .notValidSessionID: "Error: Session ID is not valid or its a guest session"
        case .custom(let error) : "Error: \(error)"
        }
    }
}
