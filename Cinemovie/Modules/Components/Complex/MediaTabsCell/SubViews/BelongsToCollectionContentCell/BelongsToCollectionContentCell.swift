//
//  BelongsToCollectionContentCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 11.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class BelongsToCollectionContentCellViewModel: CellViewModelBaseClass {
    let collectionDetails: BelongsToCollectionDetails
    let cellHeight: CGFloat
    let isBackdropDriven: Bool
    
    init(collectionDetails: BelongsToCollectionDetails) {
        self.collectionDetails = collectionDetails
        self.cellHeight = collectionDetails.backdropPath != nil ? 200 : 450
        self.isBackdropDriven = collectionDetails.backdropPath != nil ? true : false
        super.init(cellIdentifier: "BelongsToCollectionContentCell")
    }
}

final class BelongsToCollectionContentCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let imageHorizontalEdgePaddings = 10.0
        static let imageCornerRadius = 15.0
        static let fakePosterOffsets = 5.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: BelongsToCollectionContentCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let collectionImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let fakePoster1: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.alpha = 0.4
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let fakePoster2: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.alpha = 0.2
        view.contentMode = .scaleAspectFill
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionImageView.layer.cornerRadius = Constants.imageCornerRadius
        self.collectionImageView.layer.borderWidth = 0.7
        self.collectionImageView.layer.borderColor = CMColor.cmLabel.withAlphaComponent(0.8).cgColor
        
        self.fakePoster1.layer.cornerRadius = Constants.imageCornerRadius
        self.fakePoster1.layer.borderWidth = 0.5
        self.fakePoster1.layer.borderColor = CMColor.cmLabel.withAlphaComponent(0.7).cgColor
        
        self.fakePoster2.layer.cornerRadius = Constants.imageCornerRadius
        self.fakePoster2.layer.borderWidth = 0.5
        self.fakePoster2.layer.borderColor = CMColor.cmLabel.withAlphaComponent(0.7).cgColor
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: BelongsToCollectionContentCellViewModel) {
        self.viewModel = viewModel
        
        let imageURL = URLHelper.getImageURL(
            with: viewModel.isBackdropDriven ?
            viewModel.collectionDetails.backdropPath :
            viewModel.collectionDetails.posterPath, size: .original
        )
        guard let imageURL = imageURL else { return }
    
        loadingIndicator.startAnimating()
        self.collectionImageView.sd_setImage(with: imageURL) { [weak self] image, _, _, _ in
            guard let self = self else { return }
            loadingIndicator.stopAnimating()
            self.fakePoster1.image = image
            self.fakePoster2.image = image
        }
        
        self.collectionImageView.snp.remakeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().inset(viewModel.isBackdropDriven ? 0 : Constants.imageHorizontalEdgePaddings)
            $0.trailing.equalToSuperview().inset(viewModel.isBackdropDriven ? (Constants.fakePosterOffsets * 2) : Constants.imageHorizontalEdgePaddings)
        }
        
        self.layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        collectionImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        addSubview(collectionImageView)
        collectionImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        addSubview(fakePoster1)
        fakePoster1.snp.makeConstraints {
            $0.top.bottom.equalTo(collectionImageView)
            $0.leading.equalTo(collectionImageView).offset(Constants.fakePosterOffsets)
            $0.trailing.equalTo(collectionImageView).offset(Constants.fakePosterOffsets)
        }
    
        addSubview(fakePoster2)
        fakePoster2.snp.makeConstraints {
            $0.top.bottom.equalTo(fakePoster1)
            $0.leading.equalTo(fakePoster1).offset(Constants.fakePosterOffsets)
            $0.trailing.equalTo(fakePoster1).offset(Constants.fakePosterOffsets)
        }
        
        self.bringSubviewToFront(collectionImageView)
    }
}
