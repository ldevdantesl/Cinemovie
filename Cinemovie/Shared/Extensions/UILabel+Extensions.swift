//
//  UILabel+Extensions.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.04.2025.
//

import UIKit

extension UILabel {
    func calculateLineCount(using font: UIFont) -> Int {
        guard let text = self.text else { return 0 }
        let width = self.bounds.width
        if width == 0 { self.layoutIfNeeded() }

        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let textHeight = NSString(string: text).boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        ).height

        return Int(ceil(textHeight / font.lineHeight))
    }
    
    func getRenderedLines() -> [String] {
        guard let text = self.text, let font = self.font else { return [] }
        
        let attributedText = NSAttributedString(string: text, attributes: [.font: font])
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText as CFAttributedString)
        let path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: CGSize(width: self.bounds.width, height: .greatestFiniteMagnitude)))
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedText.length), path, nil)
        let lines = CTFrameGetLines(frame) as! [CTLine]
        
        var result: [String] = []
        for line in lines {
            let range = CTLineGetStringRange(line)
            let start = text.index(text.startIndex, offsetBy: range.location)
            let end = text.index(start, offsetBy: range.length)
            result.append(String(text[start..<end]))
        }
        return result
    }
}
