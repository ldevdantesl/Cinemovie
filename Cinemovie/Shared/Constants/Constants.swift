//
//  Constants.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import Foundation

struct CONSTANTS {
    static let appName = "Cinemovie"
    static let baseURLString: String = "https://" + ((try? Configuration.value(for: ConstantKeys.BASE_URL.rawValue)) ?? "")
    static let imageBaseURLString: String = "https://" + ((try? Configuration.value(for: ConstantKeys.IMAGE_BASE_URL.rawValue)) ?? "")
    static let baseUniversalURLString: String = "https://" + ((try? Configuration.value(for: ConstantKeys.BASE_UNIVERSAL_URL.rawValue)) ?? "")
    static let bearerToken: String = (try? Configuration.value(for: ConstantKeys.BEARER_TOKEN.rawValue)) ?? ""
}
