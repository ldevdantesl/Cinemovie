//
//  AuthContext.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2026.
//

import Foundation

protocol AuthContextProtocol: AnyObject {
    var sessionID: String? { get set }
    var accountID: String? { get set }
    var accessToken: String? { get set }
    var isLoggedIn: Bool { get }
    var isGuest: Bool { get }
    func clearSession()
}
