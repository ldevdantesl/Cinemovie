//
//  PersonImagesCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 28.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class PersonImagesCellViewModel: CellViewModelBaseClass {
    let images: [TMDBImage]
    
    init(images: [TMDBImage]) {
        self.images = images
        super.init(cellIdentifier: "PersonImagesCell")
    }
}

final class PersonImagesCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let itemWidth = UIConstants.screenWidth
        static let itemHeight = UIConstants.screenWidth * 0.65
        static let cellHeight = UIConstants.screenWidth * 0.65
        static let spacing = 5.0
        static let vSpacing = 10.0
        static let pageControlWidth = UIConstants.screenWidth / 4
    }
    
    // MARK: - PROPERTIES
    private var viewModel: PersonImagesCellViewModel?
    private var items: [BackdropImageCellViewModel] = []
    
    // MARK: - VIEW PROPERTIES
    private lazy var personImagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: Constants.itemWidth, height: Constants.itemHeight)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellClass: BackdropImageCell.self)
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.hidesForSinglePage = true
        pc.currentPageIndicatorTintColor = CMColor.cmLabel
        pc.pageIndicatorTintColor = CMColor.cmSecondaryBackground
        return pc
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
    public func configure(viewModel: PersonImagesCellViewModel) {
        self.viewModel = viewModel
        self.items = viewModel.images.map { BackdropImageCellViewModel(imagePath: $0.filePath, size: .original) }
        self.personImagesCollectionView.reloadData()
        self.pageControl.numberOfPages = items.count
        self.pageControl.currentPage = 0
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(personImagesCollectionView)
        personImagesCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.bottom.equalTo(personImagesCollectionView.snp.bottom)
            $0.centerX.equalTo(personImagesCollectionView.snp.centerX)
            $0.width.equalTo(Constants.pageControlWidth)
        }
    }
}

extension PersonImagesCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let vm = items[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: vm.cellIdentifier, for: indexPath
        ) as? BackdropImageCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: vm)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
    }
}
