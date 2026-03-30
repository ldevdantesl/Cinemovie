//
//  SessionEndingDelegate.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.03.2026.
//

import Foundation

protocol SessionDelegate: AnyObject {
    func didRequestLogOut()
    func didRequestLogIn()
}
