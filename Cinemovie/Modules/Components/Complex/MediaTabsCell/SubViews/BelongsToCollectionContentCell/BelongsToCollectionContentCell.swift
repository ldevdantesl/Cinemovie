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
    
    init(collectionDetails: BelongsToCollectionDetails) {
        self.collectionDetails = collectionDetails
        self.cellHeight = 200
        super.init(cellIdentifier: "BelongsToCollectionContentCell")
    }
}

final class BelongsToCollectionContentCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let imageHorizontalEdgePaddings = 10.0
        static let imageCornerRadius = 15.0
        static let fakePosterOffsets = 5.0
        static let fakePosterBorderWidth = 0.5
        static let maximumAlphaComponent = 0.8
        static let maximumTotalParts = 4
    }
    
    // MARK: - PROPERTIES
    private var viewModel: BelongsToCollectionContentCellViewModel?
    private var fakePosters: [UIView] = []
    
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
    
    private let collectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenirMediumItalic)
        label.numberOfLines = 1
        label.textColor = CMColor.cmLabel
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionOverviewLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .tiny, fontName: .avenirUltraLight)
        label.numberOfLines = 2
        label.textColor = CMColor.cmSecondary
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionLabelsStack: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [collectionNameLabel])
        vstack.axis = .vertical
        vstack.spacing = 0
        vstack.backgroundColor = CMColor.cmSecondaryBackground.withAlphaComponent(0.9)
        vstack.distribution = .fillEqually
        vstack.alignment = .leading
        vstack.isLayoutMarginsRelativeArrangement = true
        vstack.layoutMargins = .init(top: 5, left: 10, bottom: 5, right: 10)
        return vstack
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionLabelsStack.arrangedSubviews.forEach { collectionLabelsStack.removeArrangedSubview($0); $0.removeFromSuperview() }
        collectionNameLabel.text = nil
        collectionImageView.image = nil
        collectionOverviewLabel.text = nil
        
        fakePosters.forEach { $0.removeFromSuperview() }
        fakePosters.removeAll()
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: BelongsToCollectionContentCellViewModel) {
        self.viewModel = viewModel
        self.collectionNameLabel.text = viewModel.collectionDetails.name
        
        if let overview = viewModel.collectionDetails.overview, !overview.isEmpty {
            self.collectionOverviewLabel.text = overview
            collectionLabelsStack.addArrangedSubview(collectionOverviewLabel)
        }
        
        let imageURL = URLHelper.getImageURL(with: viewModel.collectionDetails.backdropPath, size: .original)
        guard let imageURL = imageURL else { return }
    
        loadingIndicator.startAnimating()
        self.collectionImageView.sd_setImage(with: imageURL) { [weak self] image, _, _, _ in
            guard let self = self else { return }
            loadingIndicator.stopAnimating()
        }
        
        let totalParts = min(Constants.maximumTotalParts, viewModel.collectionDetails.parts.count)
        self.collectionImageView.snp.remakeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Constants.fakePosterOffsets * Double(totalParts + 1))
        }
        
        createFakePosters(total: totalParts)
        
        self.layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        collectionImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        collectionImageView.addSubview(collectionLabelsStack)
        collectionLabelsStack.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        addSubview(collectionImageView)
        collectionImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    private func createFakePosters(total: Int) {
        for i in 1...total {
            let newAlphaComponent: Double = Constants.maximumAlphaComponent - (0.2 * Double(i))
            print("New Alpha: ", newAlphaComponent)
            let fakePoster = UIView()
            fakePoster.backgroundColor = CMColor.cmBackground
            fakePoster.layer.cornerRadius = Constants.imageCornerRadius
            fakePoster.layer.borderWidth = Constants.fakePosterBorderWidth
            fakePoster.layer.borderColor = CMColor.cmLabel.withAlphaComponent(newAlphaComponent).cgColor

            addSubview(fakePoster)
            fakePoster.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview().inset(Constants.fakePosterOffsets * Double(i))
            }
            fakePosters.append(fakePoster)
        }
        
        self.bringSubviewToFront(collectionImageView)
    }
}
