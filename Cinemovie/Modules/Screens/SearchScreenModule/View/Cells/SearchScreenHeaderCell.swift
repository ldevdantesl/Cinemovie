//
//  SearchScreenHeaderCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 3.10.2025.
//

import UIKit
import SnapKit

final class SearchScreenHeaderCellViewModel: CellViewModelBaseClass {
    let didTapSearch: (() -> Void)?
    
    init(didTapSearch: (() -> Void)?) {
        self.didTapSearch = didTapSearch
        super.init(cellIdentifier: "SearchScreenHeaderCell")
    }
}

final class SearchScreenHeaderCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let hSpacing = 10.0
        static let vSpacing = 10.0
        static let spacing = 5.0
        static let searchBarCornerRadius = 25.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: SearchScreenHeaderCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var headerTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenirBoldItalic)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var searchBar: UITextField = {
        let view = UITextField()
        view.placeholder = "Search"
        view.delegate = self
        view.backgroundColor = CMColor.cmSecondary
        view.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        view.returnKeyType = .go
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let height = contentView.systemLayoutSizeFitting(
            CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel
        ).height
        layoutAttributes.frame.size.height = height
        return layoutAttributes
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.layer.cornerRadius = Constants.searchBarCornerRadius
        searchBar.layer.borderColor = CMColor.cmBorder.cgColor
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: SearchScreenHeaderCellViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(headerTextLabel)
        headerTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.vSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
        }
        
        contentView.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(headerTextLabel.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
            $0.height.equalTo(50)
        }
    }
}

extension SearchScreenHeaderCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
