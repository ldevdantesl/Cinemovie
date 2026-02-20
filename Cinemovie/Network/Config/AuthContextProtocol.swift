//
//  AuthContext.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2026.
//

import Foundation

protocol AuthContextProtocol: AnyObject {
    var sessionID: String? { get }
    var accountID: String? { get }
    var accessToken: String? { get }
    var isLoggedIn: Bool { get }
    var isGuest: Bool { get }
}
