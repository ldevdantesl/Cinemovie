//
//  AppInfo.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.04.2026.
//

import UIKit

enum AppInfo {
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
}
