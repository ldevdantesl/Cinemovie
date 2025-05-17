//
//  CMSearchBar.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 22.04.2025.
//

import UIKit
import SnapKit

struct CMTextFieldViewModel {
    let backgroundColor: UIColor
    let textColor: UIColor
    let returnKeyType: UIReturnKeyType
    let cornerRadius: CGFloat
    let borderColor: UIColor?
    let borderWidth: CGFloat?
    let placeholder: String?
    let font: UIFont
    
    init(
        backgroundColor: UIColor, textColor: UIColor = CMColor.cmLabel,
        cornerRadius: CGFloat = 15.0, placeholder: String? = nil,
        font: UIFont, returnKeyType: UIReturnKeyType = .search,
        borderColor: UIColor? = nil, borderWidth: CGFloat? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.placeholder = placeholder
        self.returnKeyType = returnKeyType
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.font = font
    }
}

final class CMTextField: UITextField {
     
    // MARK: - PROPERTIES
    private(set) var viewModel: CMTextFieldViewModel
    
    // MARK: - LIFECYCLE
    init(viewModel: CMTextFieldViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = viewModel.cornerRadius
        if let borderColor = viewModel.borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        if let borderWidth = viewModel.borderWidth {
            self.layer.borderWidth = borderWidth
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: .init(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: .init(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: CMTextFieldViewModel) {
        self.viewModel = viewModel
        setup()
    }
    
    // MARK: - PRIVATE FUNC
    private func setup() {
        self.returnKeyType = viewModel.returnKeyType
        self.placeholder = nil
        if let placeholder = viewModel.placeholder {
            self.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: CMColor.cmPlaceholderLabel]
            )
        }
        self.textColor = viewModel.textColor
        self.font = viewModel.font
        self.backgroundColor = viewModel.backgroundColor
    }
}
