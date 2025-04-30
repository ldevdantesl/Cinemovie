//
//  ConstantKeys.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import Foundation

enum ConstantKeys: String {
    // MARK: - CONFIGURATION
    case BASE_URL = "BASE_URL"
    case BASE_URL_V4 = "BASE_URL_V4"
    case BASE_UNIVERSAL_URL = "BASE_UNIVERSAL_URL"
    case IMAGE_BASE_URL = "IMAGE_BASE_URL"
    
    case API_READ_ACCESS_TOKEN = "API_READ_ACCESS_TOKEN"
    case API_KEY = "API_KEY"
    
    // MARK: - OTHER
    case OAUTH_CALLBACK = "OAUTH_CALLBACK"
    
    // MARK: - ACCOUNT
    case SESSION_ID_KEYCHAIN_KEY = "SESSION_ID_KEYCHAIN_KEY"
    case ACCOUNT_ID_KEYCHAIN_KEY = "ACCOUNT_ID_KEYCHAIN_KEY"
    case ACCESS_TOKEN_KEYCHAIN_KEY = "ACCESS_TOKEN_KEYCHAIN_KEY"
    case GUEST_SESSION_ID_KEYCHAIN_KEY = "GUEST_SESSION_ID_KEYCHAIN_KEY"
}
