//
//  BelongsToCollectionContentCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 11.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class BelongsToCollectionTabContentCellViewModel: CellViewModelBaseClass {
    let collectionDetails: BelongsToCollectionDetails
    private(set) var cellHeight: CGFloat
    private let onHeightChangedRequest: (() -> Void)?
    let onItemTapped: ((Media) -> Void)?
    
    init(collectionDetails: BelongsToCollectionDetails, onItemTapped: ((Media) -> Void)?,  onHeightChangedRequest: (() -> Void)?) {
        self.collectionDetails = collectionDetails
        self.cellHeight = 200
        self.onHeightChangedRequest = onHeightChangedRequest
        self.onItemTapped = onItemTapped
        super.init(cellIdentifier: "BelongsToCollectionTabContentCell")
    }
    
    fileprivate func changeCellSize(to newSize: CGFloat) {
        self.cellHeight = newSize
        self.onHeightChangedRequest?()
    }
}

final class BelongsToCollectionTabContentCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let imageHorizontalEdgePaddings = 10.0
        static let imageCornerRadius = 15.0
        static let fakePosterOffsets = 5.0
        static let fakePosterBorderWidth = 0.5
        static let maximumAlphaComponent = 0.8
        static let maximumTotalParts = 4
        static let itemSpacing = 10.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: BelongsToCollectionTabContentCellViewModel?
    private var fakePosters: [UIView] = []
    private var items: [MediaPosterImageCellViewModel] = []
    private var showingItems: Bool = false
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    private lazy var collectionImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCollection)))
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
        self.collectionImageView.layer.cornerRadius = Constants.imageCornerRadius
        self.collectionImageView.layer.borderWidth = 0.7
        self.collectionImageView.layer.borderColor = CMColor.cmLabel.withAlphaComponent(0.8).cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionLabelsStack.arrangedSubviews.forEach { collectionLabelsStack.removeArrangedSubview($0); $0.removeFromSuperview() }
        fakePosters.forEach { $0.removeFromSuperview() }
        fakePosters.removeAll()
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
        let rows = ceil(Double(items.count) / 3.0)
        let itemWidth = bounds.width / 3
        let itemHeight = itemWidth * 1.5
        let totalHeight = rows * (itemHeight + Constants.itemSpacing)
        
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
            self.viewModel?.changeCellSize(to: totalHeight)
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
