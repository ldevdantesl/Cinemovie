//
//  UserServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 2.05.2025.
//

import Foundation

protocol UserServiceProtocol {
    var userLanguage: String { get }
    
    func changeLanguage(to language: String)
}

final class CMUserService: UserServiceProtocol {
    private(set) var userLanguage: String = "en-US"
    
    func changeLanguage(to language: String) {
        self.userLanguage = language
    }
}
