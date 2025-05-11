//
//  SupplementaryHeaderCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 10.05.2025.
//

import UIKit
import SnapKit

struct SupplementaryHeaderViewModel {
    let title: String
    let subtitle: String?
    let cellIdentifier: String
    
    init(title: String, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
        self.cellIdentifier = "SupplementaryHeaderCell"
    }
}

final class SupplementaryHeaderCell: ReusableCellBaseClass {
    // MARK: - PROPERTIES
    private var viewModel: SupplementaryHeaderViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headerSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmSublabel
        label.font = CMFont.font(size: .caption, fontName: .avenirRegular)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    public func configure(viewModel: SupplementaryHeaderViewModel) {
        self.viewModel = viewModel
        self.headerTitleLabel.text = viewModel.title
        self.headerSubtitleLabel.text = viewModel.subtitle
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(headerTitleLabel)
        headerTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(headerSubtitleLabel)
        headerSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(headerTitleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
