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
    
    var localizedDescription: String {
        switch self {
        case .invalidCredentials: "Error: Error with credentials"
        case .networkError(let error): "Error: Something is wrong with network \(error)"
        case .userCancelled: "Error: User cancelled"
        }
    }
}
