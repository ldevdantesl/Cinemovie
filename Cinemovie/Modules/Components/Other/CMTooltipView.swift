//
//  CMTooltipView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 26.02.2025.
//

import UIKit

final class CMTooltipView: UIView {
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let padding: CGFloat = 10
    private let cornerRadius: CGFloat = 8
    
    init(text: String) {
        super.init(frame: .zero)
        backgroundColor = CMColor.cmBackground.withAlphaComponent(0.85)
        layer.cornerRadius = cornerRadius
        label.text = text
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(padding)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(from sourceView: UIView, in parentView: UIView) {
        parentView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false

        let screenWidth = UIConstants.screenWidth
        let sourceFrame = sourceView.convert(sourceView.bounds, to: parentView)
        let tooltipWidth: CGFloat = 200
        
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
    
    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
