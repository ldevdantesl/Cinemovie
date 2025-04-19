//
//  OverviewCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.03.2025.
//

import SnapKit
import UIKit

final class OverviewCellViewModel: CellViewModelBaseClass {
    let overviewText: String?

    init(overviewText: String?) {
        self.overviewText = overviewText
        super.init(cellIdentifier: "OverviewCell")
    }
}

final class OverviewCell: ReusableCellBaseClass {
    typealias ViewModel = OverviewCellViewModel
    
    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    // MARK: - PROPERTIES
    private var viewModel: ViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let overviewTextLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .footnote, fontName: .avenirDemiBoldItalic)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 0
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let height = systemLayoutSizeFitting(
            CGSize(width: UIConstants.screenWidth - 20, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        layoutAttributes.frame.size.height = height
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
        self.overviewTextLabel.text = viewModel.overviewText
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(overviewTextLabel)
        overviewTextLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
