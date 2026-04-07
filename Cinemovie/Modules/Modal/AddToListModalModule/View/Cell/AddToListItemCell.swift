//
//  AddToListItemCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.05.2025.
//

import UIKit
import SnapKit

struct AddToListItemCellViewModel {
    let userList: UserList
    let isAdded: Bool
    let didTapAddToList: ((UserList) -> Void)?
}

final class AddToListItemCell: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let plusIconName = "plus"
        static let checkmarkIconName = "checkmark"
        static let spacing = 5.0
        static let hSpacing = 10.0
        static let buttonSize = 35.0
        
        static let selfCornerRadius = 10.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: AddToListItemCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let listNameLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let listDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenirRegular)
        label.textColor = CMColor.cmSublabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalItemsLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenirHeavy)
        label.textColor = CMColor.cmSuccess
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addToListButton: CMCircularButton = {
        let button = CMCircularButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        let height = listNameLabel.intrinsicContentSize.height + listDescriptionLabel.intrinsicContentSize.height +
        totalItemsLabel.intrinsicContentSize.height + (Constants.spacing * 2)
        
        layoutAttributes.frame.size.height = height
        return layoutAttributes
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = Constants.selfCornerRadius
        contentView.layer.borderColor = CMColor.cmLabel.cgColor
        contentView.layer.borderWidth = 0.5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
        self.listNameLabel.text = nil
        self.listDescriptionLabel.text = nil
        self.totalItemsLabel.text = nil
        self.addToListButton.clear()
    }
    
    // MARK: - PUBLIC FUNC    
    public func configure(viewModel: AddToListItemCellViewModel) {
        self.viewModel = viewModel
        self.listNameLabel.text = viewModel.userList.name
        self.listDescriptionLabel.text = viewModel.userList.description
        self.totalItemsLabel.text = "\(viewModel.userList.numberOfItems) items"
        
        let buttonVM = CMCircularButtonViewModel(
            systemName: viewModel.isAdded ? Constants.checkmarkIconName : Constants.plusIconName,
            backColor: viewModel.isAdded ? CMColor.cmAccent : CMColor.cmSystem,
            foreColor: CMColor.cmLabel,
            didTapAction: { [weak self] in self?.didTapAddToList() }
        )
        self.addToListButton.configure(viewModel: buttonVM)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.backgroundColor = CMColor.cmSecondaryBackground
        contentView.addSubview(listNameLabel)
        listNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.spacing)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
        }
        
        contentView.addSubview(listDescriptionLabel)
        listDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(listNameLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
        }
        
        contentView.addSubview(totalItemsLabel)
        totalItemsLabel.snp.makeConstraints {
            $0.top.equalTo(listDescriptionLabel.snp.bottom).offset(Constants.spacing)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
            $0.bottom.equalToSuperview().offset(-Constants.spacing)
        }
        
        contentView.addSubview(addToListButton)
        addToListButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-Constants.hSpacing)
            $0.size.equalTo(Constants.buttonSize)
        }
    }
    
    private func didTapAddToList() {
        guard let viewModel = viewModel else { return }
        viewModel.didTapAddToList?(viewModel.userList)
    }
}
