//
//  ShareCardGenerator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.07.2026.
//

import UIKit

enum ShareCardGenerator {
    
    static func generate(listName: String, media: [MediaProtocol], totalCount: Int) async -> UIImage? {
        let paths = media.compactMap(\.posterPath).prefix(totalCount)
        
        let posters: [UIImage] = await withTaskGroup(of: (Int, UIImage?).self) { group in
            for (i, path) in paths.enumerated() {
                group.addTask {
                    guard let url = URLHelper.getImageURL(with: path, size: .w500),
                          let (data, _) = try? await URLSession.shared.data(from: url)
                    else { return (i, nil) }
                    return (i, UIImage(data: data))
                }
            }
            var results = [(Int, UIImage?)]()
            for await r in group { results.append(r) }
            return results.sorted { $0.0 < $1.0 }.compactMap(\.1)
        }
        
        guard !posters.isEmpty else { return nil }
        
        return await MainActor.run {
            let card = ListShareCardView(listName: listName, itemCount: media.count, posters: posters)
            card.layoutIfNeeded()
            let renderer = UIGraphicsImageRenderer(size: card.bounds.size)
            return renderer.image { _ in
                card.drawHierarchy(in: card.bounds, afterScreenUpdates: true)
            }
        }
    }
}
