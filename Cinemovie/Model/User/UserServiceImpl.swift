//
//  UserServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 2.05.2025.
//

import Foundation

final class UserServiceImpl: UserService {
    private(set) var userLanguage: String = "en-US"
    
    func changeLanguage(to language: String) {
        self.userLanguage = language
    }
}
