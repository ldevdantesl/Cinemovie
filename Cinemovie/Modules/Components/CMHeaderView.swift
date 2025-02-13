//
//  CMHeaderView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import SnapKit
import UIKit

final class CMHeaderView: UIView {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.titleFont
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let firstButton: CMCircularButton
    private let secondButton: CMCircularButton?
    
    init(
        headerTitle: String,
        firstButton: CMCircularButton,
        secondButton: CMCircularButton? = nil
    ) {
        self.firstButton = firstButton
        self.secondButton = secondButton
        super.init(frame: .zero)
        
        self.setupUI(headerTitle: headerTitle)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI(headerTitle: String) {
        headerLabel.text = headerTitle
        
        self.backgroundColor = CMColor.cmBackground
        let spacer = UIView()
        let hStack = UIStackView(arrangedSubviews: [headerLabel, spacer, firstButton])
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.alignment = .top
        hStack.distribution = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false

        if let secondButton = secondButton {
            hStack.addArrangedSubview(secondButton)
        }
        
        addSubview(hStack)
        
        hStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        headerLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        headerLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        firstButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        firstButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    // MARK: - Public Methods
    public func addShadowToHeader() {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 1
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.layer.shadowRadius = 2
            self.layer.zPosition = 1
            
            let shadowHeight: CGFloat = 4
            let shadowRect = CGRect(x: 0, y: self.bounds.height - shadowHeight, width: self.bounds.width, height: shadowHeight)
            self.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        }
    }

    public func removeShadowFromHeader() {
        UIView.transition(with: self, duration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.layer.shadowOpacity = 0
        }
    }
}
