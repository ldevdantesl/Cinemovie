//
//  AccountManager.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 29.04.2025.
//

import Foundation

protocol AccountStore: AnyObject {
    var sessionID: String? { get set }
    var guestSessionID: String? { get set }
    var accountObjectID: String? { get set }
    var accessToken: String? { get set }
    var isLoggedIn: Bool { get }
    var isGuest: Bool { get }
    
    func clear()
}
