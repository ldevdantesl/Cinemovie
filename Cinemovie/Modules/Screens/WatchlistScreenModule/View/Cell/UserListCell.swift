//
//  UserListCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.05.2025.
//

import UIKit
import SnapKit

final class UserListCellViewModel: CellViewModelBaseClass {
    let userList: UserList
    let didTapList: ((UserList) -> Void)?
    
    init(userList: UserList, didTapList: ((UserList) -> Void)?) {
        self.userList = userList
        self.didTapList = didTapList
        super.init(cellIdentifier: "UserListCell")
    }
}

final class UserListCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let notFoundImageName = "plus"
        static let notFoundImagePointSize = 25.0
        static let posterBorderWidth = 0.5
        static let posterCornerRadius = 10.0
        static let hugeSpacing = 20.0
        static let spacing = 5.0
        static let vSpacing = 10.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: UserListCellViewModel?

    // MARK: - VIEW PROPERTIES
    private let posterImageView: AsyncImageView = {
        let view = AsyncImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCornerRadius(Constants.posterCornerRadius)
        view.setBorder(width: Constants.posterBorderWidth, borderColor: CMColor.cmLabel)
        return view
    }()
    
    private let listTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let listSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmSublabel
        label.font = CMFont.font(size: .caption, fontName: .avenirMediumItalic)
        label.numberOfLines = 2
        label.textAlignment = .center
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
        let height = contentView.systemLayoutSizeFitting(
            CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel
        ).height
        layoutAttributes.frame.size.height = height
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImageView.reset()
        self.viewModel = nil
        self.listTitleLabel.text = nil
        self.listSubtitleLabel.text = nil
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: UserListCellViewModel) {
        self.viewModel = viewModel
        self.posterImageView.setAsyncImage(
            path: viewModel.userList.posterPath, size: .original,
            notFoundImageSystemName: Constants.notFoundImageName,
            notFoundPointSize: Constants.notFoundImagePointSize,
            notFoundTintColor: CMColor.cmSystem
        )
        self.listTitleLabel.text = viewModel.userList.name
        self.listSubtitleLabel.text = viewModel.userList.description
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAction)))
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.vSpacing)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.5).priority(.high)
        }
        
        contentView.addSubview(listTitleLabel)
        listTitleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(Constants.hugeSpacing)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(listSubtitleLabel)
        listSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(listTitleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-Constants.vSpacing)
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapAction() {
        guard let userList = viewModel?.userList else { return }
        self.viewModel?.didTapList?(userList)
    }
}
