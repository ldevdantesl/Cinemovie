//
//  ShareCardGenerator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.07.2026.
//

import UIKit

enum ShareCardGenerator {
    
    static func generate(listName: String, media: [MediaProtocol], totalCount: Int) async -> UIImage? {
        let paths = media.compactMap(\.posterPath).prefix(await ListShareCardView.maxPosters)
        
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
            let card = ListShareCardView(listName: listName, itemCount: totalCount, posters: posters)
            card.layoutIfNeeded()
            
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1
            format.opaque = true
            
            let renderer = UIGraphicsImageRenderer(size: card.bounds.size, format: format)
            return renderer.image { _ in
                card.drawHierarchy(in: card.bounds, afterScreenUpdates: true)
            }
        }
    }
    
    static func generateShareFile(listName: String, media: [MediaProtocol], totalCount: Int) async -> URL? {
        guard let image = await generate(listName: listName, media: media, totalCount: totalCount),
              let data = image.jpegData(compressionQuality: 0.9)
        else { return nil }
        
        let filename = listName.replacingOccurrences(of: "/", with: "-") + ".jpg"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: url)
            return url
        } catch {
            return nil
        }
    }
}
