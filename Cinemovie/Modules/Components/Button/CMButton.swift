//
//  CMButton.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import UIKit

final class CMButton: UIButton {

    // MARK: - PROPERTIES
    public var titleLabelText: String = ""
    public var titleLabelForeColor: UIColor = UIColor.white
    public var titleLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 24)
    public var buttonImage: UIImage? = nil
    public var backColor: UIColor = .systemCyan
    public var cornerRadius: CGFloat = 8
    
    // MARK: - LIFECYCLE
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
    
    convenience init(
        text: String = "",
        foreColor: UIColor = UIColor.white,
        textFont: UIFont = UIFont.boldSystemFont(ofSize: 24),
        image: UIImage? = nil,
        backColor: UIColor = .systemCyan,
        cornerRadius: CGFloat = 8,
        target: Any?,
        action: Selector
    ) {
        self.init(text: text, foreColor: foreColor, textFont: textFont, image: image, backColor: backColor, cornerRadius: cornerRadius)
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
    }
    
    // MARK: - PUBLIC FUNC
    public func setAction(target: Any?, action: Selector){
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    // MARK: - PRIVATE FUNC
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
