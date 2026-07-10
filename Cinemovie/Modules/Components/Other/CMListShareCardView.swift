//
//  CMListCardShareView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.07.2026.
//

import UIKit

final class ListShareCardView: UIView {
    
    // MARK: - CONSTANTS
    private enum Layout {
        static let canvasSize = CGSize(width: 1080, height: 1920)
        static let margin: CGFloat = 60
        static let spacing: CGFloat = 24
        static let posterRatio: CGFloat = 1.5
        static let maxPosters = 6
        
        static let kickerHeight: CGFloat = 44
        static let titleHeight: CGFloat = 120
        static let footerHeight: CGFloat = 44
        static let headerToGrid: CGFloat = 70
        static let gridToFooter: CGFloat = 50
        static let maxGridHeight: CGFloat = 1250
    }
    
    // MARK: - INIT
    init(listName: String, itemCount: Int, posters allPosters: [UIImage]) {
        super.init(frame: CGRect(origin: .zero, size: Layout.canvasSize))
        backgroundColor = UIColor(red: 0.07, green: 0.07, blue: 0.09, alpha: 1)
        
        let posters = Array(allPosters.prefix(Layout.maxPosters))
                
        let (posterSize, cols, rows) = gridMetrics(count: posters.count)
        let gridH = posterSize.height * CGFloat(rows) + Layout.spacing * CGFloat(rows - 1)
        
        let headerH = Layout.kickerHeight + 8 + Layout.titleHeight
        let totalH = headerH + Layout.headerToGrid + gridH + Layout.gridToFooter + Layout.footerHeight
        var y = (Layout.canvasSize.height - totalH) / 2
        
        y = addHeader(listName: listName, at: y)
        y += Layout.headerToGrid
        y = addPosterGrid(posters, posterSize: posterSize, cols: cols, rows: rows, at: y)
        y += Layout.gridToFooter
        addFooter(itemCount: itemCount, shownCount: posters.count, at: y)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - GRID METRICS
    private func gridMetrics(count: Int) -> (CGSize, Int, Int) {
        guard count > 0 else { return (.zero, 1, 0) }
        
        let cols: Int
        switch count {
        case 1:      cols = 1
        case 2...4:  cols = 2
        default:     cols = 3
        }
        let rows = Int(ceil(Double(count) / Double(cols)))
        
        let gridWidth = Layout.canvasSize.width - Layout.margin * 2
        let wFromWidth = (gridWidth - Layout.spacing * CGFloat(cols - 1)) / CGFloat(cols)
        let hFromHeight = (Layout.maxGridHeight - Layout.spacing * CGFloat(rows - 1)) / CGFloat(rows)
        let wFromHeight = hFromHeight / Layout.posterRatio
        
        let cap: CGFloat = cols == 1 ? 620 : .greatestFiniteMagnitude
        let posterW = min(wFromWidth, wFromHeight, cap)
        
        return (CGSize(width: posterW, height: posterW * Layout.posterRatio), cols, rows)
    }
    
    // MARK: - HEADER
    private func addHeader(listName: String, at y: CGFloat) -> CGFloat {
        let kicker = UILabel(frame: CGRect(x: Layout.margin, y: y,
                                           width: Layout.canvasSize.width - Layout.margin * 2,
                                           height: Layout.kickerHeight))
        kicker.text = "Cinemovie"
        kicker.font = .systemFont(ofSize: 34, weight: .semibold)
        kicker.textColor = UIColor.white.withAlphaComponent(0.45)
        addSubview(kicker)
        
        let title = UILabel(frame: CGRect(x: Layout.margin, y: kicker.frame.maxY + 8,
                                          width: Layout.canvasSize.width - Layout.margin * 2,
                                          height: Layout.titleHeight))
        title.text = listName
        title.font = .systemFont(ofSize: 88, weight: .bold)
        title.textColor = .white
        title.numberOfLines = 2
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.6
        addSubview(title)
        
        return title.frame.maxY
    }
    
    // MARK: - POSTER GRID
    private func addPosterGrid(_ posters: [UIImage], posterSize: CGSize, cols: Int, rows: Int, at y: CGFloat) -> CGFloat {
        guard !posters.isEmpty else { return y }
        
        for (i, poster) in posters.enumerated() {
            let row = i / cols
            let col = i % cols
            
            let itemsInRow = (row == rows - 1) ? posters.count - row * cols : cols
            let rowWidth = posterSize.width * CGFloat(itemsInRow) + Layout.spacing * CGFloat(itemsInRow - 1)
            let rowOriginX = (Layout.canvasSize.width - rowWidth) / 2
            
            let iv = UIImageView(frame: CGRect(
                x: rowOriginX + CGFloat(col) * (posterSize.width + Layout.spacing),
                y: y + CGFloat(row) * (posterSize.height + Layout.spacing),
                width: posterSize.width,
                height: posterSize.height
            ))
            iv.image = poster
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 20
            addSubview(iv)
        }
        
        return y + posterSize.height * CGFloat(rows) + Layout.spacing * CGFloat(rows - 1)
    }
    
    // MARK: - FOOTER
    private func addFooter(itemCount: Int, shownCount: Int, at y: CGFloat) {
        let footer = UILabel(frame: CGRect(x: Layout.margin, y: y,
                                           width: Layout.canvasSize.width - Layout.margin * 2,
                                           height: Layout.footerHeight))
        let hidden = itemCount - shownCount
        footer.text = hidden > 0
            ? "+ \(hidden) more · made with Cinemovie"
            : "\(itemCount) titles · made with Cinemovie"
        footer.font = .systemFont(ofSize: 34, weight: .medium)
        footer.textColor = UIColor.white.withAlphaComponent(0.45)
        addSubview(footer)
    }
}
