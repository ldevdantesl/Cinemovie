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
    let didTapBackButton: (() -> Void)?
    
    init(images: [TMDBImage], didTapBackButton: (() -> Void)?) {
        self.images = images
        self.didTapBackButton = didTapBackButton
        super.init(cellIdentifier: "PersonImagesCell")
    }
}

final class PersonImagesCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let itemWidth = UIConstants.screenWidth
        static let itemHeight = UIConstants.screenWidth * 0.9
        static let spacing = 5.0
        static let vSpacing = 10.0
        static let pageControlWidth = UIConstants.screenWidth / 4
        static let superBottomInset = 50.0
        
        static let backButtonName = "chevron.left"
        static let backButtonSize = 35.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: PersonImagesCellViewModel?
    private var items: [BackdropImageCellViewModel] = []
    private var collectionViewTopConstraint: Constraint?
    
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
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.clipsToBounds = true
        pc.hidesForSinglePage = true
        pc.currentPageIndicatorTintColor = CMColor.cmLabel
        pc.pageIndicatorTintColor = CMColor.cmSecondaryBackground
        return pc
    }()
    
    private let backButton: CMCircularButton = {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.layer.cornerRadius = blurView.frame.height / 2
        personImagesCollectionView.layer.masksToBounds = true
        personImagesCollectionView.clipsToBounds = true
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        layoutAttributes.frame.size.height = Constants.itemHeight
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: PersonImagesCellViewModel) {
        self.viewModel = viewModel
        self.items = viewModel.images.map { BackdropImageCellViewModel(imagePath: $0.filePath, size: .original) }
        self.personImagesCollectionView.reloadData()
        self.pageControl.numberOfPages = items.count
        self.pageControl.currentPage = 0
        
        let vm = CMCircularButtonViewModel(
            systemName: Constants.backButtonName,
            backColor: .cmSecondaryBackground, foreColor: .cmLabel,
            didTapAction: viewModel.didTapBackButton
        )
        backButton.configure(viewModel: vm)
    }
    
    public func setTopContraint(offsetY: CGFloat) {
        if offsetY <= 0 && offsetY >= -200 {
            collectionViewTopConstraint?.update(offset: offsetY)
        } else if offsetY >= 0 {
            collectionViewTopConstraint?.update(offset: 0)
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(personImagesCollectionView)
        personImagesCollectionView.snp.makeConstraints {
            collectionViewTopConstraint = $0.top.equalToSuperview().constraint
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIConstants.topInset)
            $0.leading.equalToSuperview().offset(Constants.vSpacing)
            $0.size.equalTo(Constants.backButtonSize)
        }
        
        addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.bottom.equalTo(personImagesCollectionView.snp.bottom).offset(-Constants.superBottomInset)
            $0.centerX.equalTo(personImagesCollectionView.snp.centerX)
            $0.width.equalTo(Constants.pageControlWidth)
        }
        
        blurView.contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
