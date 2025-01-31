//
//  CMButton.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import UIKit

final class CMButton: UIButton {

    public var titleLabelText: String = ""
    public var titleLabelForeColor: UIColor = UIColor.white
    public var titleLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 24)
    public var backColor: UIColor = .systemCyan
    public var cornerRadius: CGFloat = 8
    
    init(
        text: String = "",
        foreColor: UIColor = UIColor.white,
        textFont: UIFont = UIFont.boldSystemFont(ofSize: 24),
        backColor: UIColor = .systemCyan,
        cornerRadius: CGFloat = 8
    ) {
        super.init(frame: .zero)
        self.titleLabelText = text
        self.titleLabelFont = textFont
        self.titleLabelForeColor = foreColor
        self.backColor = backColor
        self.cornerRadius = cornerRadius
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let attrTitle = NSAttributedString(
            string: titleLabelText,
            attributes: [
                .font : titleLabelFont,
                .foregroundColor : titleLabelForeColor
            ]
        )
        
        self.layer.cornerRadius = cornerRadius
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = backColor
        self.configuration = .borderedTinted()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setAttributedTitle(attrTitle, for: .normal)
    }
}
