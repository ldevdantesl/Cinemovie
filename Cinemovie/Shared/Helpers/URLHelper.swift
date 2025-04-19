//
//  ImagePathHelper.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

enum ImageSizes: String {
    case w92 = "w92"
    case w154 = "w154"
    case w185 = "w185"
    case w342 = "w342"
    case w500 = "w500"
    case w780 = "w780"
    case w1280 = "w1280"
    case original = "original"
}

public struct URLHelper {
    static func stringToURL(urlString: String) -> URL? {
        return URL(string: urlString)
    }
    
    static func getPersonInstagramURL(withID id: String?) -> URL? {
        guard let id = id, !id.isEmpty else { return nil }
        return URL(string: "https://www.instagram.com/\(id)/")
    }
    
    static func getPersonFacebookURL(withID id: String?) -> URL? {
        guard let id = id, !id.isEmpty else { return nil }
        return URL(string: "https://www.facebook.com/\(id)/")
    }
    
    static func getPersonTwitterURL(withID id: String?) -> URL? {
        guard let id = id, !id.isEmpty else { return nil }
        return URL(string: "https://twitter.com/\(id)/")
    }
    
    static func getPersonWikiURL(withID id: String?) -> URL? {
        guard let id = id, !id.isEmpty else { return nil }
        return URL(string: "https://www.wikidata.org/wiki/\(id)")
    }
    
    static func getPersonIMDBURL(withID id: String?) -> URL? {
        guard let id = id, !id.isEmpty else { return nil }
        return URL(string: "https://www.imdb.com/name/\(id)/")
    }
    
    static func getPersonYouTubeURL(withID id: String?) -> URL? {
        guard let id = id, !id.isEmpty else { return nil }
        print("https://www.youtube.com/channel/\(id)")
        return URL(string: "https://www.youtube.com/\(id)")
    }
    
    static func getImageURL(with path: String?, size: ImageSizes) -> URL? {
        guard let path = path, !path.isEmpty else { return nil }
        let finalPath = "\(CONSTANTS.imageBaseURLString)/\(size.rawValue)\(path)"
        return URL(string: finalPath)
    }
    
    static func getImdbURL(withID id: String?) -> URL? {
        guard let id = id else { return nil }
        return URL(string: "https://www.imdb.com/title/\(id)/")
    }
    
    static func getYouTubeVideoURL(video: Video, playsInline: Bool = true) -> URL? {
        return URL(string:"https://www.youtube.com/embed/\(video.key)?playsinline=\(playsInline ? "1" : "0")")
    }
}
