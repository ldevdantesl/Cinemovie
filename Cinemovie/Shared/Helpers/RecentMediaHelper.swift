//
//  RecentMediaHelper.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 10.10.2025.
//

import UIKit

public struct RecentMediaHelper {
    private static let recentMediaKey = "userRecentMedia"

    static func getRecentMedia() -> [MediaProtocol] {
        let recents: [AnyMedia] = CMStorage.load([AnyMedia].self, key: recentMediaKey) ?? []
        return recents.map { $0.asMedia }
    }

    static func addRecentMedia(media: MediaProtocol) {
        var allMedia = getRecentMedia().map { AnyMedia($0) }
        allMedia.removeAll { $0.asMedia.id == media.id }
        allMedia.insert(AnyMedia(media), at: 0)
        if allMedia.count > 22 { allMedia.removeLast(allMedia.count - 50) }
        CMStorage.save(allMedia, key: recentMediaKey)
        print("Saved data to Storage; MediaID: \(media.id)")
    }
}
