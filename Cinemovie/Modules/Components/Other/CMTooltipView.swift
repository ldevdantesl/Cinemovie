//
//  CMTooltipView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 26.02.2025.
//

import UIKit
import SnapKit

final class CMTooltipView: UIView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let padding: CGFloat = 10
        static let cornerRadius: CGFloat = 8
    }
    
    // MARK: - PROPERTIES
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = CMFont.font(size: .footnote, fontName: .avenirBoldItalic)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    init(text: String) {
        super.init(frame: .zero)
        label.text = text
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = Constants.cornerRadius
    }
    
    deinit {
        print("Tooltip Deinited")
    }
    
    // MARK: - PRIVATE FUNC
    private func setup() {
        self.backgroundColor = CMColor.cmBackground.withAlphaComponent(0.85)
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.padding)
        }
    }
    
    // MARK: - PUBLIC FUNC
    public func show(from sourceView: UIView, in parentView: UIView) {
        parentView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false

        let screenWidth = UIConstants.screenWidth
        let sourceFrame = sourceView.convert(sourceView.bounds, to: parentView)
        let tooltipWidth: CGFloat = 150
        
        self.snp.makeConstraints {
            $0.top.equalTo(sourceView.snp.bottom).offset(5)
            $0.width.lessThanOrEqualTo(tooltipWidth)
            
            if sourceFrame.midX - tooltipWidth / 2 < 10 {
                $0.leading.equalTo(parentView.snp.leading).offset(10)
            } else if sourceFrame.midX + tooltipWidth / 2 > screenWidth - 10 {
                $0.trailing.equalTo(parentView.snp.trailing).offset(-10)
            } else {
                $0.centerX.equalTo(sourceView)
            }
        }

        self.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
    public func dismiss() {
        UIView.animate(withDuration: 0.2) { [weak self]  in
            guard let self = self else { return }
            self.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.removeFromSuperview()
        }
    }
}
