//
//  CMCircularButton.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import Foundation
import UIKit
import SnapKit

final class CMCircularButton: UIView {
    
    private let buttonImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    init(
        systemName: String,
        backColor: UIColor = .cmSecondary,
        foreColor: UIColor = .cmLabel
    ) {
        super.init(frame: .zero)
        self.buttonImage.image = UIImage(systemName: systemName)
        self.buttonImage.tintColor = foreColor
        self.backgroundColor = backColor
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(buttonImage)
        buttonImage.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
    }
}
