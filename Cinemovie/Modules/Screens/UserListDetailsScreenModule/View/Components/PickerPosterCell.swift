//
//  PickerPosterCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.07.2026.
//

import UIKit
import SnapKit
import SDWebImage

final class PickerPosterCell: UICollectionViewCell {
    static let identifier = "PickerPosterCell"
    
    private let imageView = UIImageView()
    private let badge = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        badge.font = .systemFont(ofSize: 14, weight: .bold)
        badge.textColor = .black
        badge.backgroundColor = CMColor.cmAccent
        badge.textAlignment = .center
        badge.layer.cornerRadius = 13
        badge.clipsToBounds = true
        contentView.addSubview(badge)
        badge.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(6)
            $0.size.equalTo(26)
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(posterPath: String?, selectionNumber: Int?) {
        if let path = posterPath, let url = URLHelper.getImageURL(with: path, size: .w342) {
            imageView.sd_setImage(with: url)
        }
        if let number = selectionNumber {
            badge.isHidden = false
            badge.text = "\(number)"
            imageView.alpha = 1
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = CMColor.cmAccent.cgColor
        } else {
            badge.isHidden = true
            imageView.alpha = 0.4
            imageView.layer.borderWidth = 0
        }
    }
}
