//
//  UIImage+Extensions.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 28.02.2025.
//

import Foundation
import UIKit

extension UIImage {
    func convertedToRGB() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        if let convertedCGImage = context.makeImage() {
            return UIImage(cgImage: convertedCGImage)
        }
        return nil
    }
}
