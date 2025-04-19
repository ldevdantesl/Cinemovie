//
//  ReviewsContentCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class ReviewsTabContentCellViewModel: CellViewModelBaseClass {
    let reviews: [Review]
    private(set) var cellHeight = 100.0
    let onHeightChangedRequest: (() -> Void)?
    
    static let defaultITemHeight: CGFloat = 120.0
    
    init(reviews: [Review], onHeightChangedRequest: (() -> Void)?) {
        self.reviews = reviews
        self.onHeightChangedRequest = onHeightChangedRequest
        super.init(cellIdentifier: "ReviewsTabContentCell")
    }
    
    fileprivate func changeCellHeight(to height: CGFloat) {
        self.cellHeight = height
    }
}

final class ReviewsTabContentCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let itemEstimatedHeight = 100.0
        static let itemSpacing = 10.0
        static let defaultItemHeight = ReviewsTabContentCellViewModel.defaultITemHeight
    }
    
    // MARK: - PROPERTIES
    private var viewModel: ReviewsTabContentCellViewModel?
    private var items: [ReviewItemContentCellViewModel] = []

    // MARK: - VIEW PROPERTIES
    private lazy var reviewsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.itemSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = CMColor.cmBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellClass: ReviewItemContentCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        let height = reviewsCollectionView.contentSize.height
        attributes.frame.size.height = height
        viewModel?.changeCellHeight(to: height)
        return attributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: ReviewsTabContentCellViewModel) {
        self.viewModel = viewModel
        self.items = viewModel.reviews.map {
            ReviewItemContentCellViewModel(review: $0) { [weak self] in
                guard let self = self else { return }
                self.onHeightChangeRequest()
            }
        }
        self.reviewsCollectionView.reloadData()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(reviewsCollectionView)
        reviewsCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func calculatedCollectionViewHeight() -> CGFloat {
        let height = items.map { $0.cellHeight }.reduce(0, +)
        let totalHeight = height + (CGFloat(items.count) * Constants.itemSpacing)
        return totalHeight
    }
    
    private func onHeightChangeRequest() {
        viewModel?.changeCellHeight(to: calculatedCollectionViewHeight())
        viewModel?.onHeightChangedRequest?()
        reviewsCollectionView.performBatchUpdates(nil) { [weak self] _ in
            guard let self = self else { return }
            self.reviewsCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

extension ReviewsTabContentCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReviewItemContentCell.identifier, for: indexPath
        ) as? ReviewItemContentCell else {
            return UICollectionViewCell()
        }
        
        let itemVM = items[indexPath.row]
        cell.configure(viewModel: itemVM)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.row]
        return CGSize(width: UIConstants.screenWidth - 20, height: item.cellHeight)
    }
}
