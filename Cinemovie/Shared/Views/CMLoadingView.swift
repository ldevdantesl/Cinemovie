//
//  MessageBoxView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 16.05.2025.
//

import UIKit
import SnapKit

final class CMLoadingView: UIView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let hSpacing = 10.0
        static let spacing = 5.0
        static let containerHeight = 100.0
        static let farOffset = 100.0
    }
    
    // MARK: - PROPERTIES
    
    // MARK: - VIEW PROPERTIES
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loadingImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageNames.logoAlt.rawValue)
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var stateImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirMedium)
        label.numberOfLines = 1
        label.textColor = CMColor.cmLabel
        return label
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNC
    public func load(in superView: UIView) {
        superView.addSubview(dimmingView)
        dimmingView.snp.makeConstraints { $0.edges.equalToSuperview() }
        dimmingView.alpha = 0

        superView.addSubview(self)
        self.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(Constants.containerHeight)
            $0.bottom.equalToSuperview().offset(Constants.farOffset)
        }
        superView.layoutIfNeeded()

        self.snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(Constants.containerHeight)
        }

        UIView.animate(withDuration: 0.3) {
            self.dimmingView.alpha = 1
            superView.layoutIfNeeded()
        }
    }
    
    public func showSuccess(message: String) {
        
    }
    
    public func showFailure() {
        
    }
    
    // MARK: - PRIVATE FUNC
    private func setup() {
        
    }
    
    private func hide() {
        
    }
}
