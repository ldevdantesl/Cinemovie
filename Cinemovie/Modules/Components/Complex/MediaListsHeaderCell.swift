//
//  MediaListsHeaderCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 26.03.2025.
//

import UIKit
import SnapKit

struct MediaListsHeaderCellViewModel: CellViewModel {
    let id: String = UUID().uuidString
    var cellIdentifier: String = "MediaListsHeaderCell"
    let titleText: String
    let subtitleText: String
}

final class MediaListsHeaderCell: UICollectionViewCell, ReusableCell {
    // MARK: - TYPEALIAS
    typealias ViewModel = MediaListsHeaderCellViewModel
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 5
    }
    
    // MARK: - PROPERTIES
    private var viewModel: ViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .footnote, fontName: .avenirDemiBoldItalic)
        label.textColor = CMColor.cmSecondary
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
    func configure(with viewModel: MediaListsHeaderCellViewModel) {
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.titleText
        self.subtitleLabel.text = viewModel.subtitleText
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
