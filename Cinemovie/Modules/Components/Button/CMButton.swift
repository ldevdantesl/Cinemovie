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
    public var buttonImage: UIImage? = nil
    public var backColor: UIColor = .systemCyan
    public var cornerRadius: CGFloat = 8
    
    init(
        text: String = "",
        foreColor: UIColor = UIColor.white,
        textFont: UIFont = UIFont.boldSystemFont(ofSize: 24),
        image: UIImage? = nil,
        backColor: UIColor = .systemCyan,
        cornerRadius: CGFloat = 8
    ) {
        super.init(frame: .zero)
        self.titleLabelText = text
        self.titleLabelFont = textFont
        self.titleLabelForeColor = foreColor
        self.backColor = backColor
        self.cornerRadius = cornerRadius
        self.buttonImage = image
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
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = backColor
        self.configuration = .borderedTinted()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = cornerRadius
        self.setAttributedTitle(attrTitle, for: .normal)
        self.clipsToBounds = true
        
        if let buttonImage = buttonImage?.withRenderingMode(.alwaysTemplate) {
            self.setImage(buttonImage, for: .normal)
            self.configuration?.imagePlacement = .leading
            self.configuration?.imagePadding = 5
            self.tintColor = titleLabelForeColor
        }
    }
}
