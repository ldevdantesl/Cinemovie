//
//  CMButton.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import UIKit

public struct CMButtonViewModel {
    public var text: String?
    public var foreColor: UIColor
    public var font: UIFont
    public var image: UIImage?
    public var backColor: UIColor
    public var didTapAction: (() -> Void)?
    
    init(
        text: String? = nil, foreColor: UIColor = CMColor.cmLabel,
        font: UIFont, image: UIImage? = nil,
        backColor: UIColor = CMColor.cmSecondary,
        didTapAction: (() -> Void)? = nil
    ) {
        self.text = text
        self.foreColor = foreColor
        self.font = font
        self.image = image
        self.backColor = backColor
        self.didTapAction = didTapAction
    }
}

final class CMButton: UIButton {

    // MARK: - PROPERTIES
    private(set) var viewModel: CMButtonViewModel?
    private(set) var buttonCornerRadius: CGFloat = 0
    private(set) var buttonBorderColor: UIColor?
    private(set) var buttonBorderWidth: CGFloat?
    private var onTapAction: (() -> Void)?
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(viewModel: CMButtonViewModel) {
        self.init(frame: .zero)
        configure(viewModel: viewModel)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = buttonCornerRadius
        self.layer.borderColor = buttonBorderColor?.cgColor
        self.layer.borderWidth = buttonBorderWidth ?? 0
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: CMButtonViewModel) {
        self.viewModel = viewModel
        setup()
    }
    
    public func reconfigure(viewModel: CMButtonViewModel, aniDuration: TimeInterval = 0.3, options: UIView.AnimationOptions = [.transitionCrossDissolve]) {
        self.viewModel = viewModel
        UIView.transition(with: self, duration: aniDuration, options: options) { [weak self] in
            guard let self = self else { return }
            self.setup()
        }
    }
    
    public func setCornerRadius(_ radius: CGFloat) {
        self.buttonCornerRadius = radius
        self.clipsToBounds = true
        layoutIfNeeded()
    }
    
    public func setBorder(borderWidth: CGFloat, borderColor: UIColor) {
        self.buttonBorderColor = borderColor
        self.buttonBorderWidth = borderWidth
    }
    
    public func setAction(action: (() -> Void)?) {
        self.onTapAction = action
    }
    
    // MARK: - PRIVATE FUNC
    private func setup() {
        guard let viewModel = viewModel else { return }
        self.onTapAction = viewModel.didTapAction ?? self.onTapAction
        self.setTitle(nil, for: .normal)
        self.setImage(nil, for: .normal)
        self.configuration = nil
        self.removeTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        let attrTitle = NSAttributedString(
            string: viewModel.text ?? "",
            attributes: [
                .font : viewModel.font,
                .foregroundColor : viewModel.foreColor
            ]
        )
        
        
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = viewModel.backColor
        self.configuration = .borderedTinted()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setAttributedTitle(attrTitle, for: .normal)
        
        if let buttonImage = viewModel.image?.withRenderingMode(.alwaysTemplate) {
            self.setImage(buttonImage, for: .normal)
            self.configuration?.imagePlacement = .leading
            self.configuration?.imagePadding = 5
            self.tintColor = viewModel.foreColor
        }
        
        self.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapButton() {
        self.onTapAction?()
    }
}
