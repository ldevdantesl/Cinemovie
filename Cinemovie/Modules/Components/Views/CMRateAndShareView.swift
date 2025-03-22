//
//  CMRateAndShareView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 1.03.2025.
//

import UIKit
import SnapKit

final class CMRateAndShareView: UIView {
    
    fileprivate enum Constants {
        static let spacing: CGFloat = 5
        static let biggerSpacing: CGFloat = 20
        
        static let rateImageViewSize: CGFloat = 30
        static let shareImageViewSize: CGFloat = 25
    }
    
    private let rateImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageNames.like.rawValue)
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .footnote, fontName: .avenirDemiBold)
        label.textColor = CMColor.cmLabel
        label.text = "Rate"
        return label
    }()
    
    private let shareImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageNames.share.rawValue)
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let shareLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .footnote, fontName: .avenirDemiBold)
        label.textColor = CMColor.cmLabel
        label.text = "Share"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - PRIVATE METHODS
    private func setupUI() {
        
        let rateStack = UIStackView(arrangedSubviews: [rateImageView, rateLabel])
        rateStack.axis = .vertical
        rateStack.spacing = Constants.spacing
        rateStack.alignment = .center
        
        rateImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.rateImageViewSize)
        }
        
        let shareStack = UIStackView(arrangedSubviews: [shareImageView, shareLabel])
        shareStack.axis = .vertical
        shareStack.spacing = Constants.spacing
        shareStack.alignment = .center
        
        shareImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.shareImageViewSize)
        }
        
        let hStack = UIStackView(arrangedSubviews: [rateStack, UIView(), shareStack])
        hStack.axis = .horizontal
        hStack.spacing = Constants.biggerSpacing
        hStack.alignment = .bottom
        hStack.distribution = .equalSpacing
        
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
