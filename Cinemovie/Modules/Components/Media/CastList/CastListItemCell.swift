//
//  CMMovieCastListCellCollectionViewCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.02.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class CastListItemCellViewModel: CellViewModelBaseClass {
    let cast: Cast?
    let didTapCast: ((Cast) -> Void)?

    init(cast: Cast?, didTapCast: ((Cast) -> Void)?) {
        self.cast = cast
        self.didTapCast = didTapCast
        super.init(cellIdentifier: "CastListItemCell")
    }
}

final class CastListItemCell: UICollectionViewCell {

    // MARK: - CONSTANTS
    fileprivate enum Paddings {
        static let imageViewTopPadding: CGFloat = 10
        static let spacer: CGFloat = 5
    }
    
    fileprivate enum Constants {
        static let loadingIndicatorSize: CGFloat = 20
        
        static let imageViewCornerRadius: CGFloat = 20
        static let imageViewBorderWidth: CGFloat = 1
        static let imageSize: CGFloat = 80
        static let imageViewImageName = "person"
        static let imageViewImagePointSize: CGFloat = 20
        
        static let unknownText: String = "Unknown"
    }
    
    // MARK: - PROPERTIES
    private var viewModel: CastListItemCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var avatarImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setAction(target: self, action: #selector(didSelectCast))
        imageView.setCornerRadius(Constants.imageViewCornerRadius)
        imageView.setBorder(width: Constants.imageViewBorderWidth, borderColor: CMColor.cmAccent)
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .tiny, fontName: .avenirDemiBold)
        label.textColor = CMColor.cmLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var characterName: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .tiny, fontName: .avenirDemiBold)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarImageView.reset()
    }
    
    // MARK: - PUBLIC METHOD
    public func configure(viewModel: CastListItemCellViewModel) {
        self.viewModel = viewModel
        guard let cast = viewModel.cast else { return }
        self.nameLabel.text = cast.name
        self.characterName.text = cast.character ?? cast.job ?? Constants.unknownText
        avatarImageView.setAsyncImage(
            path: cast.profilePath, size: .original,
            notFoundImageSystemName: Constants.imageViewImageName,
            notFoundPointSize: Constants.imageViewImagePointSize
        )
    }
    
    // MARK: - PRIVATE METHOD
    private func setupUI() {
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(Constants.imageSize)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Constants.imageSize)
        }
        
        contentView.addSubview(characterName)
        characterName.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualTo(Constants.imageSize)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didSelectCast() {
        print("Tapped select Cast")
        guard let viewModel = viewModel, let cast = viewModel.cast else { return }
        viewModel.didTapCast?(cast)
    }
}
