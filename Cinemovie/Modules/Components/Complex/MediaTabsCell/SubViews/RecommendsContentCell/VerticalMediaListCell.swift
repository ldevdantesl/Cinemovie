//
//  RecommendsContentCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class VerticalMediaListCellViewModel: CellViewModelBaseClass, CellWithHeightProtocol {
    let media: [Media]
    let title: String?
    let subtitle: String?
    let didTapBackButton: (() -> Void)?
    let didTapAnyMedia: ((Media) -> Void)?
    var cellHeight: CGFloat = 100
    
    init(media: [Media], didTapAnyMedia: ((Media) -> Void)?) {
        self.media = media
        self.didTapAnyMedia = didTapAnyMedia
        self.title = nil
        self.subtitle = nil
        self.didTapBackButton = nil
        super.init(cellIdentifier: "VerticalMediaListCell")
    }
    
    init(media: [Media], title: String, subtitle: String? = nil, didTapAnyMedia: ((Media) -> Void)?) {
        self.media = media
        self.title = title
        self.subtitle = subtitle
        self.didTapAnyMedia = didTapAnyMedia
        self.didTapBackButton = nil
        super.init(cellIdentifier: "VerticalMediaListCell")
    }
    
    init(media: [Media], title: String, subtitle: String? = nil, didTapBackButton: (() -> Void)?, didTapAnyMedia: ((Media) -> Void)?) {
        self.media = media
        self.title = title
        self.subtitle = subtitle
        self.didTapAnyMedia = didTapAnyMedia
        self.didTapBackButton = didTapBackButton
        super.init(cellIdentifier: "VerticalMediaListCell")
    }
    
    func setCellHeight(to height: CGFloat) {
        self.cellHeight = height
    }
}

final class VerticalMediaListCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let itemWidth = (UIConstants.screenWidth / 3) - 40
        static let itemHeight = (itemWidth * 2)
        static let vGroupHeight = itemHeight * 3 + 20
        static let vSpacing = 10.0
        static let spacing = 5.0
        static let backButtonName = "chevron.left"
        static let backButtonSize = 35.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: VerticalMediaListCellViewModel?
    private var items: [Media] = []
    private var itemVMS: [MediaPosterImageCellViewModel] = []
    private var gridCVTopConstraint: Constraint?
    private var backButtonSizeConstraint: Constraint?
    
    // MARK: - VIEW PROPERTIES
    private let paginatingLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = false
        indicator.alpha = 0
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let backButton: CMCircularButton = {
        let button = CMCircularButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .footnote, fontName: .avenirDemiBoldItalic)
        label.textColor = CMColor.cmSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var gridCollectionView: DiffableCollectionView = {
        let view = DiffableCollectionView<Int, MediaPosterImageCellViewModel>(layout: createLayout())
        view.isScrollEnabled = false
        view.backgroundColor = CMColor.cmBackground
        view.register(cellClass: MediaPosterImageCell.self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDataSource()
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let height = gridCollectionView.contentSize.height + titleLabel.intrinsicContentSize.height +
        subtitleLabel.intrinsicContentSize.height + Constants.vSpacing + paginatingLoadingIndicator.intrinsicContentSize.height + Constants.spacing
        layoutAttributes.frame.size.height = height
        self.viewModel?.setCellHeight(to: height)
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
        self.items = []
        self.itemVMS.removeAll()
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: VerticalMediaListCellViewModel) {
        self.viewModel = viewModel
        self.items = viewModel.media
        self.itemVMS.removeAll()
        
        let hasBackButton = viewModel.didTapBackButton != nil
        backButton.isHidden = !hasBackButton
        
        if let title = viewModel.title {
            titleLabel.text = title
            subtitleLabel.text = viewModel.subtitle
            gridCVTopConstraint?.update(offset: Constants.vSpacing)
        }
        
        let leadingView = hasBackButton ? backButton.snp.trailing : contentView.snp.leading
        let leadingOffset = hasBackButton ? Constants.vSpacing : 0
        
        titleLabel.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(leadingView).offset(leadingOffset)
            $0.trailing.equalToSuperview()
        }
        
        subtitleLabel.snp.remakeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(leadingView).offset(leadingOffset)
            $0.trailing.equalToSuperview()
        }
        
        let vm = CMCircularButtonViewModel(
            systemName: Constants.backButtonName, backColor: .cmSecondaryBackground,
            foreColor: CMColor.cmLabel, didTapAction: viewModel.didTapBackButton
        )
        backButton.configure(viewModel: vm)
        
        self.itemVMS = items.map { MediaPosterImageCellViewModel(media: $0, didTapMedia: viewModel.didTapAnyMedia)}
        var snapshot = NSDiffableDataSourceSnapshot<Int, MediaPosterImageCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.itemVMS, toSection: 0)
        self.gridCollectionView.applySnapshot(snapshot: snapshot, animatingDifferences: true)
        self.gridCollectionView.layoutIfNeeded()
        self.layoutIfNeeded()
    }
    
    public func startPaginatingLoadingAnimation(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.paginatingLoadingIndicator.startAnimating()
            self.paginatingLoadingIndicator.alpha = 1.0
        }
    }
    
    public func stopPaginatingLoadingAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.paginatingLoadingIndicator.stopAnimating()
            self.paginatingLoadingIndicator.alpha = 0
        }
    }
    
    public func setLoadingAlpha(_ alpha: CGFloat) {
        paginatingLoadingIndicator.alpha = alpha
    }
    
    public func insertNewItems(_ items: [Media], onCompletion: (() -> Void)? = nil) {
        self.items.append(contentsOf: items)
        let newVMs = items.map {
            MediaPosterImageCellViewModel(media: $0) { [weak self] in
                guard let self = self else { return }
                self.viewModel?.didTapAnyMedia?($0)
            }
        }
        self.itemVMS.append(contentsOf: newVMs)
        var snapshot = NSDiffableDataSourceSnapshot<Int, MediaPosterImageCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.itemVMS, toSection: 0)
        self.gridCollectionView.applySnapshot(snapshot: snapshot, animatingDifferences: true) { [weak self] in
            guard let self = self else { return }
            self.invalidateIntrinsicContentSize()
            onCompletion?()
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(Constants.backButtonSize)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(backButton.snp.trailing).offset(Constants.vSpacing)
            $0.trailing.equalToSuperview()
        }
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(backButton.snp.trailing).offset(Constants.vSpacing)
            $0.trailing.equalToSuperview()
        }
        
        contentView.addSubview(gridCollectionView)
        gridCollectionView.snp.makeConstraints {
            gridCVTopConstraint = $0.top.equalTo(subtitleLabel.snp.bottom).constraint
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(paginatingLoadingIndicator)
        paginatingLoadingIndicator.snp.makeConstraints {
            $0.top.equalTo(gridCollectionView.snp.bottom).offset(Constants.spacing)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        self.gridCollectionView.configureDataSource { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemIdentifier.cellIdentifier, for: indexPath) as? MediaPosterImageCell
            cell?.configure(with: itemIdentifier)
            return cell
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            let itemWidth = Constants.itemWidth
            let itemHeight = Constants.itemHeight
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(itemWidth), heightDimension: .absolute(itemHeight)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(itemHeight)), subitem: item, count: 3)
            group.interItemSpacing = .fixed(Constants.vSpacing)
            let vgroupHeight = Constants.vGroupHeight
            let vgroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(vgroupHeight)), subitem: group, count: 3)
            vgroup.interItemSpacing = .fixed(Constants.vSpacing)
            let section = NSCollectionLayoutSection(group: vgroup)
            section.interGroupSpacing = Constants.vSpacing
            return section
        }
    }
}
