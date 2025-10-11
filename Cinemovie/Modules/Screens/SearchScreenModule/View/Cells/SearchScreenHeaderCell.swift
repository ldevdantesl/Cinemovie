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
    let didTapBackButton: (() -> Void)?
    
    init(didTapSearch: (() -> Void)?, didTapBackButton: (() -> Void)?) {
        self.didTapSearch = didTapSearch
        self.didTapBackButton = didTapBackButton
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
        static let searchBarBorderWidth = 0.5
        static let backButtonSize = 35.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: SearchScreenHeaderCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var headerTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .title, fontName: .avenirBoldItalic)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backButton: CMCircularButton = {
        let button = CMCircularButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var searchBar: UISearchTextField = {
        let search = UISearchTextField()
        search.backgroundColor = CMColor.cmSecondaryBackground
        search.placeholder = "Search"
        search.clipsToBounds = true
        search.returnKeyType = .go
        search.delegate = self
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
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
        searchBar.layer.borderColor = CMColor.cmPlaceholderLabel.cgColor
        searchBar.layer.borderWidth = Constants.searchBarBorderWidth
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: SearchScreenHeaderCellViewModel) {
        self.viewModel = viewModel
        let backButtonVM = CMCircularButtonViewModel(
            systemName: "chevron.left",
            backColor: CMColor.cmSecondaryBackground,
            foreColor: CMColor.cmAccent,
            didTapAction: viewModel.didTapBackButton
        )
        backButton.configure(viewModel: backButtonVM)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.vSpacing)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
            $0.size.equalTo(Constants.backButtonSize)
        }
        
        contentView.addSubview(headerTextLabel)
        headerTextLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.leading.equalTo(backButton.snp.trailing).offset(Constants.hSpacing)
            $0.trailing.equalToSuperview().offset(-Constants.hSpacing)
        }
        
        contentView.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }
    }
}

extension SearchScreenHeaderCell: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.viewModel?.didTapSearch?()
        return true
    }
}
