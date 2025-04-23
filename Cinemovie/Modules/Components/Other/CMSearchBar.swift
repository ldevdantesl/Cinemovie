//
//  CMSearchBar.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 22.04.2025.
//

import UIKit
import SnapKit

struct CMSearchBarViewModel {
    let backgroundColor: UIColor
    let textColor: UIColor
    let cornerRadius: CGFloat
    let placeholder: String?
    let font: UIFont
    
    init(backgroundColor: UIColor, textColor: UIColor = CMColor.cmLabel, cornerRadius: CGFloat = 15.0, placeholder: String? = nil, font: UIFont) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.placeholder = placeholder
        self.font = font
    }
}

final class CMSearchBar: UITextField {
     
    // MARK: - PROPERTIES
    private(set) var viewModel: CMSearchBarViewModel
    
    // MARK: - LIFECYCLE
    init(viewModel: CMSearchBarViewModel) {
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
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: .init(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: .init(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: CMSearchBarViewModel) {
        self.viewModel = viewModel
        setup()
    }
    
    // MARK: - PRIVATE FUNC
    private func setup() {
        self.returnKeyType = .search
        self.placeholder = viewModel.placeholder
        self.textColor = viewModel.textColor
        self.font = viewModel.font
        self.backgroundColor = viewModel.backgroundColor
    }
}
