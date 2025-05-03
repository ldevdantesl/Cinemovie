//
//  UserService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 2.05.2025.
//

import Foundation

protocol UserService: AnyObject {
    var userLanguage: String { get }
    
    func changeLanguage(to language: String)
}
