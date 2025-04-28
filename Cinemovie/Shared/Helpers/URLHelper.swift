//
//  ImagePathHelper.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

public struct URLHelper {
    static func stringToURL(urlString: String) -> URL? {
        return URL(string: urlString)
    }
    
    // MARK: - SOURCE URL
    static func getPersonInstagramURL(withID id: String?) -> URL? {
        guard let id = id, !id.isEmpty else { return nil }
        return URL(string: "https://www.instagram.com/\(id)/")
    }
    
    static func getPersonFacebookURL(withID id: String?) -> URL? {
        guard let id = id, !id.isEmpty else { return nil }
        return URL(string: "https://www.facebook.com/\(id)/")
    }
    
    static func getPersonWikiURL(withID id: String?) -> URL? {
        guard let id = id, !id.isEmpty else { return nil }
        return URL(string: "https://www.wikidata.org/wiki/\(id)")
    }
    
    static func getPersonIMDBURL(withID id: String?) -> URL? {
        guard let id = id, !id.isEmpty else { return nil }
        return URL(string: "https://www.imdb.com/name/\(id)/")
    }
    
    static func getPersonTikTokURL(withID id: String?) -> URL? {
        guard let id = id else { return nil }
        return URL(string: "https://www.tiktok.com/@\(id)")
    }
    
    // MARK: - OTHER
    static func getImdbURL(withID id: String?) -> URL? {
        guard let id = id else { return nil }
        return URL(string: "https://www.imdb.com/title/\(id)/")
    }
    
    static func getImageURL(with path: String?, size: TMDBImageSizes) -> URL? {
        guard let path = path, !path.isEmpty else { return nil }
        let finalPath = "\(CONSTANTS.imageBaseURLString)/\(size.rawValue)\(path)"
        return URL(string: finalPath)
    }
    
    static func getYouTubeVideoURL(video: Video, playsInline: Bool = true) -> URL? {
        return URL(string:"https://www.youtube.com/embed/\(video.key)?playsinline=\(playsInline ? "1" : "0")")
    }
}
