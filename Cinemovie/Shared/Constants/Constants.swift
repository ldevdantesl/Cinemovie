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
    static let baseURLV4String: String = "https://" + ((try? Configuration.value(for: ConstantKeys.BASE_URL_V4.rawValue)) ?? "")
    static let imageBaseURLString: String = "https://" + ((try? Configuration.value(for: ConstantKeys.IMAGE_BASE_URL.rawValue)) ?? "")
    static let baseUniversalURLString: String = "https://" + ((try? Configuration.value(for: ConstantKeys.BASE_UNIVERSAL_URL.rawValue)) ?? "")
    static let apiReadAcessToken: String = (try? Configuration.value(for: ConstantKeys.API_READ_ACCESS_TOKEN.rawValue)) ?? ""
    static let apiKey: String = (try? Configuration.value(for: ConstantKeys.API_KEY.rawValue)) ?? ""
}
