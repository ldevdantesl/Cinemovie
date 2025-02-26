//
//  AppOpener.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 25.02.2025.
//

import UIKit

struct AppOpener {
    static func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
