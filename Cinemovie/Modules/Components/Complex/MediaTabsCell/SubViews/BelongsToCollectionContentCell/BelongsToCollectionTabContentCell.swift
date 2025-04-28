//
//  BelongsToCollectionContentCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 11.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class BelongsToCollectionTabContentCellViewModel: CellViewModelBaseClass, CellWithHeightProtocol{
    let collectionDetails: BelongsToCollectionDetails
    let onItemTapped: ((Media) -> Void)?
    let onHeightChangedRequest: (() -> Void)?
    var cellHeight: CGFloat = 100.0
    
    init(collectionDetails: BelongsToCollectionDetails, onItemTapped: ((Media) -> Void)?, onHeightChangedRequest: (() -> Void)?) {
        self.collectionDetails = collectionDetails
        self.onItemTapped = onItemTapped
        self.onHeightChangedRequest = onHeightChangedRequest
        super.init(cellIdentifier: "BelongsToCollectionTabContentCell")
    }
    
    func setCellHeight(to height: CGFloat) {
        self.cellHeight = height
    }
}

final class BelongsToCollectionTabContentCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let imageHorizontalEdgePaddings = 10.0
        static let imageCornerRadius = 15.0
        static let imageBorderWidth = 0.7
        static let fakePosterOffsets = 5.0
        static let fakePosterBorderWidth = 0.5
        static let maximumAlphaComponent = 0.8
        static let maximumTotalParts = 4
        static let itemSpacing = 10.0
        static let defaultCellHeight: CGFloat = 200.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: BelongsToCollectionTabContentCellViewModel?
    private var items: [MediaPosterImageCellViewModel] = []
    private var showingItems: Bool = false
    
    // MARK: - VIEW PROPERTIES
    private lazy var collectionImageView: AsyncImageView = {
        let view = AsyncImageView()
        view.setCornerRadius(Constants.imageCornerRadius)
        view.setBorder(width: Constants.imageBorderWidth, borderColor: CMColor.cmLabel.withAlphaComponent(0.8))
        view.setAction(target: self, action: #selector(didTapCollection))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let firstFakePoster: UIView = {
        let view = UIView()
        view.backgroundColor = CMColor.cmSecondaryBackground.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let secondFakePoster: UIView = {
        let view = UIView()
        view.backgroundColor = CMColor.cmSecondaryBackground.withAlphaComponent(0.4)
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
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.spacing = 0
        vstack.backgroundColor = CMColor.cmSecondaryBackground.withAlphaComponent(0.9)
        vstack.distribution = .fillEqually
        vstack.alignment = .leading
        vstack.isLayoutMarginsRelativeArrangement = true
        vstack.layoutMargins = .init(top: 5, left: 10, bottom: 5, right: 10)
        return vstack
    }()
    
    private lazy var partsCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = CMColor.cmBackground
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        view.register(cellClass: MediaPosterImageCell.self)
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
        self.firstFakePoster.layer.cornerRadius = Constants.imageCornerRadius
        self.firstFakePoster.layer.borderWidth = Constants.fakePosterBorderWidth
        self.firstFakePoster.layer.borderColor = CMColor.cmLabel.withAlphaComponent(0.7).cgColor
        
        self.secondFakePoster.layer.cornerRadius = Constants.imageCornerRadius
        self.secondFakePoster.layer.borderWidth = Constants.fakePosterBorderWidth
        self.secondFakePoster.layer.borderColor = CMColor.cmLabel.withAlphaComponent(0.4).cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionLabelsStack.arrangedSubviews.forEach { collectionLabelsStack.removeArrangedSubview($0); $0.removeFromSuperview() }
        self.viewModel = nil
        self.items = []
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        partsCollectionView.layoutIfNeeded()
        
        let height = showingItems ? partsCollectionView.contentSize.height : Constants.defaultCellHeight
        layoutAttributes.frame.size.height = height
        self.viewModel?.setCellHeight(to: height)
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: BelongsToCollectionTabContentCellViewModel) {
        self.viewModel = viewModel
        self.items = viewModel.collectionDetails.parts.map { MediaPosterImageCellViewModel(media: $0, didTapMedia: viewModel.onItemTapped) }
        
        guard !showingItems else { return }
        self.collectionNameLabel.text = viewModel.collectionDetails.name
        self.collectionLabelsStack.addArrangedSubview(collectionNameLabel)
        
        if let overview = viewModel.collectionDetails.overview, !overview.isEmpty {
            self.collectionOverviewLabel.text = overview
            collectionLabelsStack.addArrangedSubview(collectionOverviewLabel)
        }
        
        collectionImageView.setAsyncImage(
            path: viewModel.collectionDetails.backdropPath, size: .original,
            notFoundImageSystemName: "questionmark", notFoundPointSize: 20.0
        )
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        collectionImageView.addSubview(collectionLabelsStack)
        collectionLabelsStack.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        contentView.addSubview(collectionImageView)
        collectionImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Constants.fakePosterOffsets * 2)
        }
        
        contentView.addSubview(firstFakePoster)
        firstFakePoster.snp.makeConstraints {
            $0.verticalEdges.equalTo(collectionImageView.snp.verticalEdges)
            $0.leading.equalTo(collectionImageView.snp.leading)
            $0.trailing.equalTo(collectionImageView.snp.trailing).offset(Constants.fakePosterOffsets)
        }
        
        contentView.addSubview(secondFakePoster)
        secondFakePoster.snp.makeConstraints {
            $0.verticalEdges.equalTo(collectionImageView.snp.verticalEdges)
            $0.leading.equalTo(collectionImageView.snp.leading)
            $0.trailing.equalTo(collectionImageView.snp.trailing).offset(Constants.fakePosterOffsets * 2)
        }
        
        contentView.bringSubviewToFront(collectionImageView)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { section, environment in
            let itemWidth = environment.container.contentSize.width / 3
            let itemHeight = itemWidth * 1.5
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(itemWidth), heightDimension: .absolute(itemHeight)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(itemHeight)), subitem: item, count: 3)
            group.interItemSpacing = .fixed(Constants.itemSpacing)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = Constants.itemSpacing
            return section
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapCollection() {        
        partsCollectionView.alpha = 0
        partsCollectionView.transform = CGAffineTransform(translationX: 0, y: -bounds.height)
        
        addSubview(partsCollectionView)
        partsCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        showingItems = true
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            
            self.collectionImageView.alpha = 0
            self.collectionImageView.transform = CGAffineTransform(translationX: 0, y: self.bounds.height / 2)
            
            self.partsCollectionView.alpha = 1
            self.partsCollectionView.transform = .identity
            
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.collectionImageView.removeFromSuperview()
            self.layoutIfNeeded()
            self.invalidateIntrinsicContentSize()
            self.viewModel?.onHeightChangedRequest?()
        }
    }
}

extension BelongsToCollectionTabContentCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MediaPosterImageCell.identifier, for: indexPath
        ) as? MediaPosterImageCell else { return UICollectionViewCell() }
        
        let itemVM = items[indexPath.row]
        cell.configure(with: itemVM)
        return cell
    }
}
