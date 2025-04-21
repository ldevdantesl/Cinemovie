//
//  MediaTabItemCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.03.2025.
//

import UIKit
import SnapKit

final class MediaExtrasTabItemCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let topBarHeight = 5.0
        static let spacing = 5.0
    }
    
    // MARK: - PROPERTIES
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = CMColor.cmSuccess
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(text: String, isSelected: Bool) {
        self.titleLabel.text = text
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.titleLabel.textColor = isSelected ? CMColor.cmLabel : CMColor.cmSecondary
            self.topBarView.alpha = !isSelected ? 0 : 1
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(topBarView)
        topBarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.topBarHeight)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
