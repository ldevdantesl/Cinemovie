//
//  TopBlurredCollectionView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.04.2025.
//

import UIKit
import SnapKit

class TopBlurredCollectionView: UICollectionView, UICollectionViewDelegate {
    private var fadeLayer: CAGradientLayer?
    private var showsFade: Bool

    init(layout: UICollectionViewLayout, ignoresTopSafeArea: Bool = true) {
        self.showsFade = ignoresTopSafeArea
        super.init(frame: .zero, collectionViewLayout: layout)
        self.contentInsetAdjustmentBehavior = ignoresTopSafeArea ? .never : .always
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard showsFade, fadeLayer == nil, let superview = superview else { return }
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.withAlphaComponent(1.0).cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor,
            UIColor.black.withAlphaComponent(0.4).cgColor,
            UIColor.clear.cgColor
        ]
        gradient.locations = [0.0, 0.3, 0.6, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = CGRect(x: 0, y: 0, width: superview.bounds.width, height: UIConstants.topInset)
        
        fadeLayer = gradient
        superview.layer.addSublayer(gradient)
    }
}
