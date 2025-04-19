//
//  TopBlurredCollectionView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.04.2025.
//

import UIKit
import SnapKit

class TopBlurredCollectionView: UICollectionView, UICollectionViewDelegate {
    private var blurView: UIVisualEffectView?
    private var showsBlur: Bool

    init(layout: UICollectionViewLayout, showsBlur: Bool = false) {
        self.showsBlur = showsBlur
        super.init(frame: .zero, collectionViewLayout: layout)
        self.delegate = self
        self.contentInsetAdjustmentBehavior = .never
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard showsBlur, blurView == nil, let superview = superview else { return }
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        blur.alpha = 0
        blur.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(blur)
        superview.bringSubviewToFront(blur)
        blur.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIConstants.topInset)
        }
        self.blurView = blur
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard showsBlur, let blurView else { return }
        let offsetY = scrollView.contentOffset.y
        let clamped = min(max(offsetY, 0), 200)
        blurView.alpha = clamped / 200
    }
}
