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
    static let privacyPolicyURLString = "https://www.termsfeed.com/live/94ff20a3-912c-4be1-a840-ca55d238bd0e"
    static let termsURLString = "https://www.termsfeed.com/live/79857c88-efa6-4ce5-8a38-a42691df698a"
}
