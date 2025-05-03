//
//  CMButton.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import UIKit

public struct CMButtonViewModel {
    public var text: String
    public var foreColor: UIColor
    public var font: UIFont
    public var image: UIImage?
    public var backColor: UIColor
    public var cornerRadius: CGFloat
    public var borderColor: UIColor?
    public var borderWidth: CGFloat?
    
    public var didTapAction: (() -> Void)?
    
    init(
        text: String, foreColor: UIColor = CMColor.cmLabel,
        font: UIFont, image: UIImage? = nil,
        backColor: UIColor = CMColor.cmSecondary,
        cornerRadius: CGFloat = 8,
        borderColor: UIColor? = nil, borderWidth: CGFloat? = nil,
        didTapAction: (() -> Void)? = nil
    ) {
        self.text = text
        self.foreColor = foreColor
        self.font = font
        self.image = image
        self.backColor = backColor
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.didTapAction = didTapAction
    }
}

final class CMButton: UIButton {

    // MARK: - PROPERTIES
    private(set) var viewModel: CMButtonViewModel?
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(viewModel: CMButtonViewModel) {
        self.init(frame: .zero)
        self.viewModel = viewModel
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let viewModel = viewModel else { return }
        self.layer.cornerRadius = viewModel.cornerRadius
        self.clipsToBounds = true
        self.layer.borderColor = (viewModel.borderColor ?? .clear).cgColor
        self.layer.borderWidth = viewModel.borderWidth ?? 0
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
    
    // MARK: - PRIVATE FUNC
    private func setup() {
        guard let viewModel = viewModel else { return }
        self.setTitle(nil, for: .normal)
        self.setImage(nil, for: .normal)
        self.configuration = nil
        self.removeTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        let attrTitle = NSAttributedString(
            string: viewModel.text,
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
        viewModel?.didTapAction?()
    }
}
