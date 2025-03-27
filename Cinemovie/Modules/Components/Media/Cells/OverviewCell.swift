//
//  OverviewCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.03.2025.
//

import SnapKit
import UIKit

struct OverviewCellViewModel: CellViewModel, Hashable {
    let id: String = UUID().uuidString
    let cellIdentifier: String = "OverviewCell"
    let overviewText: String?
    static let estimatedCellHeight = 200.0
}

final class OverviewCell: UICollectionViewCell, ReusableCell {
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
