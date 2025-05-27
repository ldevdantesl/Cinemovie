//
//  OneFeaturedMediaCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.05.2025.
//

import UIKit
import SnapKit

final class OneFeaturedMediaCellViewModel: CellViewModelBaseClass {
    let media: Media
    let didTapAction: ((Media) -> Void)?
    
    init(media: Media, didTapAction: ((Media) -> Void)?) {
        self.media = media
        self.didTapAction = didTapAction
        super.init(cellIdentifier: "OneFeaturedMediaCell")
    }
}

final class OneFeaturedMediaCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let notFoundImageSystemName = "questionmark"
        static let notFoundImagePointSize = 20.0
        static let bottomCornerRadius = 10.0
        static let cellHeight = UIConstants.screenHeight * 0.7
    }
    
    // MARK: - PROPERTIES
    private var viewModel: OneFeaturedMediaCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let imageView: AsyncImageView = {
        let view = AsyncImageView()
        view.setCornerRadiusForBottomOnly(Constants.bottomCornerRadius)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.reset()
        self.viewModel = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        layoutAttributes.frame.size.height = Constants.cellHeight
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: OneFeaturedMediaCellViewModel) {
        self.viewModel = viewModel
        self.imageView.setAsyncImage(
            path: viewModel.media.posterPath, size: .original,
            notFoundImageSystemName: Constants.notFoundImageSystemName,
            notFoundPointSize: Constants.notFoundImagePointSize
        )
        self.imageView.setAction(target: self, action: #selector(didTapFeaturedMedia))
        self.layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapFeaturedMedia() {
        guard let viewModel = viewModel else { return }
        viewModel.didTapAction?(viewModel.media)
    }
    
}
