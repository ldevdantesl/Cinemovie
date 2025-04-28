//
//  CMMovieBackdropImageCVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.03.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class BackdropImageCellViewModel: CellViewModelBaseClass {
    let imagePath: String?
    let didTapBackButtonAction: (() -> Void)?
    
    init(imagePath: String?, size: TMDBImageSizes, didTapBackButtonAction: (() -> Void)?) {
        self.imagePath = imagePath
        self.didTapBackButtonAction = didTapBackButtonAction
        super.init(cellIdentifier: "BackdropImageCell")
    }
}

final class BackdropImageCell: ReusableCellBaseClass {
    // MARK: - TYPEALIAS
    typealias ViewModel = BackdropImageCellViewModel
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let backButtonSize = 35.0
        static let backButtonSpacing = 10.0
        static let backButtonImageName = "chevron.left"
        
        static let indicatorSize: CGFloat = 30
        static let backdropImageSize: CGFloat = 20
        static let imageNotFoundName = "questionmark.circle"
        static let cellHeight = UIConstants.screenWidth * 0.65
    }
    
    // MARK: - PROPERTIES
    private var viewModel: ViewModel?
    private var imageTopConstraint: Constraint?
    
    // MARK: - VIEW PROPERTIES
    private let backdropImageView: AsyncImageView = {
        let view = AsyncImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: CMCircularButton = {
        let view = CMCircularButton()
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
        layoutAttributes.frame.size.height = Constants.cellHeight
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
        
        let vm = CMCircularButtonViewModel(
            systemName: Constants.backButtonImageName, backColor: CMColor.cmSecondaryBackground,
            foreColor: CMColor.cmAccent, didTapAction: viewModel.didTapBackButtonAction
        )
        backButton.configure(viewModel: vm)
        
        backdropImageView.setAsyncImage(
            path: viewModel.imagePath, size: .original,
            notFoundImageSystemName: Constants.imageNotFoundName,
            notFoundPointSize: Constants.backdropImageSize
        )
    }
    
    public func scaleImage(to offsetY: CGFloat) {
        let clampedOffset = abs(offsetY)
        let scaleX = 1 + (clampedOffset / 600)
        let scaleY = 1 + (scaleX / 300)

        backdropImageView.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        imageTopConstraint?.update(offset: offsetY)
    }

    public func resetScale() {
        backdropImageView.transform = .identity
        imageTopConstraint?.update(offset: 0)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(backdropImageView)
        backdropImageView.snp.makeConstraints {
            imageTopConstraint = $0.top.equalToSuperview().constraint
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(Constants.backButtonSpacing)
            $0.size.equalTo(Constants.backButtonSize)
        }
    }
}
