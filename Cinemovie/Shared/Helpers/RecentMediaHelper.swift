//
//  RecentMediaHelper.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 10.10.2025.
//

import UIKit

public struct RecentMediaHelper {
    private static let recentMediaKey = "userRecentMedia"

    static func getRecentMedia() -> [Media] {
        let recents: [AnyMedia] = CMStorage.load([AnyMedia].self, key: recentMediaKey) ?? []
        return recents.map { $0.asMedia }
    }

    static func addRecentMedia(media: Media) {
        var allMedia = getRecentMedia().map { AnyMedia($0) }
        allMedia.removeAll { $0.asMedia.id == media.id }
        allMedia.insert(AnyMedia(media), at: 0)
        if allMedia.count > 50 { allMedia.removeLast(allMedia.count - 50) }
        print("Recent Media Count: \(allMedia.count)")
        CMStorage.save(allMedia, key: recentMediaKey)
    }
}
