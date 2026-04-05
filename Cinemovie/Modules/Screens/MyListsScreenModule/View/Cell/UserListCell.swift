//
//  UserListCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.05.2025.
//

import UIKit
import SnapKit

final class UserListCellViewModel: CellViewModelBaseClass {
    let userList: UserListDetails
    let didTapList: ((UserListDetails) -> Void)?
    let didTapRemoveList: ((UserListDetails) -> Void)?
    
    init(userList: UserListDetails, didTapList: ((UserListDetails) -> Void)?, didTapRemoveList: ((UserListDetails) -> Void)? = nil) {
        self.userList = userList
        self.didTapList = didTapList
        self.didTapRemoveList = didTapRemoveList
        super.init(cellIdentifier: "UserListCell")
    }
}

final class UserListCell: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let plusImageName = "plus"
        static let plusPointSize = 30.0
        static let notFoundImageName = "questionmark"
        static let notFoundPointSize = 20.0
        static let posterBorderWidth = 0.5
        static let posterCornerRadius = 10.0
        static let hugeSpacing = 20.0
        static let spacing = 5.0
        static let vSpacing = 10.0
        
        static let contextMenuImage = "play.square.stack"
    }
    
    // MARK: - PROPERTIES
    private var viewModel: UserListCellViewModel?

    // MARK: - VIEW PROPERTIES
    private let posterStackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let numberOfItemsLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = CMFont.font(size: .tiny, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
        label.clipsToBounds = true
        label.textInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        label.backgroundColor = CMColor.cmSecondaryBackground.withAlphaComponent(0.8)
        return label
    }()
    
    private let plusPosterView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = CMColor.cmSecondaryBackground
        view.contentMode = .center
        view.clipsToBounds = true
        view.image = UIImage(systemName: Constants.plusImageName)
        view.preferredSymbolConfiguration = .init(pointSize: Constants.plusPointSize, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
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
        setupContextMenu()
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
        self.viewModel = nil
        self.listTitleLabel.text = nil
        self.listSubtitleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.numberOfItemsLabel.layer.cornerRadius = Constants.posterCornerRadius
        self.plusPosterView.layer.cornerRadius = Constants.posterCornerRadius
        self.plusPosterView.layer.borderColor = CMColor.cmLabel.cgColor
        self.plusPosterView.layer.borderWidth = Constants.posterBorderWidth
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: UserListCellViewModel) {
        self.viewModel = viewModel
        self.numberOfItemsLabel.text = "\(viewModel.userList.itemCount >= 20 ? "20+" : "\(viewModel.userList.itemCount)") items"
        self.listTitleLabel.text = viewModel.userList.name
        self.listSubtitleLabel.text = viewModel.userList.description
        self.stackPosters(items: viewModel.userList.results)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAction)))
        contentView.addSubview(posterStackView)
        posterStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.height.equalTo(posterStackView.snp.width).multipliedBy(1.5).priority(.high)
        }
        
        contentView.addSubview(listTitleLabel)
        listTitleLabel.snp.makeConstraints {
            $0.top.equalTo(posterStackView.snp.bottom).offset(Constants.hugeSpacing)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(listSubtitleLabel)
        listSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(listTitleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-Constants.vSpacing)
        }
    }
    
    private func setupContextMenu() {
        let interaction = UIContextMenuInteraction(delegate: self)
        contentView.addInteraction(interaction)
    }
    
    private func stackPosters(items: [MediaProtocol]) {
        posterStackView.subviews.forEach { $0.removeFromSuperview() }
        guard !items.isEmpty else {
            posterStackView.addSubview(plusPosterView)
            plusPosterView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalToSuperview()
                $0.height.equalTo(plusPosterView.snp.width).multipliedBy(1.5)
            }
            return
        }

        let postersToShow = items.prefix(3)
        let baseOffset = 15.0
        let count = postersToShow.count
        let totalOffset = Double(count - 1) * baseOffset

        for (index, item) in postersToShow.enumerated() {
            let imageView = AsyncImageView()
            imageView.setBorder(width: Constants.posterBorderWidth, borderColor: CMColor.cmLabel)
            imageView.setCornerRadius(Constants.posterCornerRadius)
            imageView.setAsyncImage(
                path: item.posterPath, size: .w1280,
                notFoundImageSystemName: Constants.notFoundImageName,
                notFoundPointSize: Constants.notFoundPointSize
            )
            posterStackView.addSubview(imageView)
            let centerOffset = (Double(index) * baseOffset - totalOffset / 2)
            
            imageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.centerX.equalToSuperview().offset(centerOffset)
                $0.width.equalToSuperview()
                $0.height.equalTo(imageView.snp.width).multipliedBy(1.5)
            }
            
            if index == postersToShow.count - 1{
                imageView.addSubview(numberOfItemsLabel)
                numberOfItemsLabel.snp.makeConstraints {
                    $0.top.equalToSuperview().offset(Constants.spacing)
                    $0.trailing.equalToSuperview().offset(-Constants.spacing)
                }
            }
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapAction() {
        guard let userList = viewModel?.userList else { return }
        self.viewModel?.didTapList?(userList)
    }
}

extension UserListCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        .init(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self = self, let viewModel = self.viewModel else { return nil }
            let firstElement = UIAction(title: "Remove", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                viewModel.didTapRemoveList?(viewModel.userList)
            }
            
            return UIMenu(
                title: viewModel.userList.name,
                image: UIImage(systemName: Constants.contextMenuImage),
                children: [firstElement]
            )
        }
    }
}
