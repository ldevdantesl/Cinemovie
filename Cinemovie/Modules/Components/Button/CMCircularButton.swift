//
//  CMCircularButton.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import UIKit
import SnapKit

final class CMCircularButton: UIButton {
    
    // MARK: - PROPERTIES
    private var buttonSize: CGFloat
    
    // MARK: - LIFECYCLE
    init(
        systemName: String,
        size: CGFloat = 44,
        backColor: UIColor = .cmSecondary,
        foreColor: UIColor = .cmLabel
    ) {
        self.buttonSize = size
        super.init(frame: .zero)
        setupUI(systemName: systemName, backColor: backColor, foreColor: foreColor)
    }
    
    convenience init(
        systemName: String,
        size: CGFloat = 44,
        backColor: UIColor = .cmSecondary,
        foreColor: UIColor = .cmLabel,
        target: Any?,
        action: Selector
    ) {
        self.init(systemName: systemName, size: size, backColor: backColor, foreColor: foreColor)
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = buttonSize / 2
    }
    
    // MARK: - Private Methods
    private func setupUI(systemName: String, backColor: UIColor, foreColor: UIColor) {
        self.setImage(UIImage(systemName: systemName), for: .normal)
        self.imageView?.tintColor = foreColor
        self.backgroundColor = backColor
        self.imageView?.contentMode = .center
        
        self.clipsToBounds = true
        self.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: buttonSize * 0.6 , weight: .medium), forImageIn: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints {
            $0.size.equalTo(buttonSize)
        }
    }
    
    // MARK: - Public Methods
    public func setAction(target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
    }
}
