//
//  CMFont.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

public struct CMFont {
    static let titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
    static let subtitleFont = UIFont.systemFont(ofSize: 18, weight: .medium)
    static let bodyFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let captionFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    static let buttonFont = UIFont(name: "AvenirNext-DemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
}
