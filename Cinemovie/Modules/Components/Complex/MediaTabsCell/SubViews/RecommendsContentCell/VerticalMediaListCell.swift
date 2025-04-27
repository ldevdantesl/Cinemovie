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
    let didTapAnyMedia: ((Media) -> Void)?
    let didTriggerPagination: (() -> Void)?
    let onHeightChangedRequest: (() -> Void)?
    let title: String?
    let subtitle: String?
    var cellHeight: CGFloat = 100
    
    init(media: [Media], didTapAnyMedia: ((Media) -> Void)?, didTriggerPagination: (() -> Void)? = nil, onHeightChangedRequest: (() -> Void)? = nil) {
        self.media = media
        self.didTapAnyMedia = didTapAnyMedia
        self.title = nil
        self.subtitle = nil
        self.didTriggerPagination = didTriggerPagination
        self.onHeightChangedRequest = onHeightChangedRequest
        super.init(cellIdentifier: "VerticalMediaListCell")
    }
    
    init(media: [Media], title: String, subtitle: String? = nil, didTapAnyMedia: ((Media) -> Void)?, didTriggerPagination: (() -> Void)? = nil, onHeightChangedRequest: (() -> Void)? = nil) {
        self.media = media
        self.title = title
        self.subtitle = subtitle
        self.didTapAnyMedia = didTapAnyMedia
        self.didTriggerPagination = didTriggerPagination
        self.onHeightChangedRequest = onHeightChangedRequest
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
        static let itemHeight = itemWidth * 1.7
        static let vGroupHeight = itemHeight * 3 + 20
        static let vSpacing = 10.0
        static let spacing = 5.0
        static let loadingIndicatorSize = 10.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: VerticalMediaListCellViewModel?
    private var items: [MediaPosterImageCellViewModel] = []
    private var gridCVTopConstraint: Constraint?
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
    
    private lazy var gridCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.isScrollEnabled = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = CMColor.cmBackground
        view.register(cellClass: MediaPosterImageCell.self)
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
        gridCollectionView.performBatchUpdates(nil) { [weak self] _ in
            guard let self = self else { return }
            gridCollectionView.layoutIfNeeded()
        }
        let height = gridCollectionView.contentSize.height + titleLabel.intrinsicContentSize.height + subtitleLabel.intrinsicContentSize.height + Constants.loadingIndicatorSize
        layoutAttributes.frame.size.height = height
        self.viewModel?.setCellHeight(to: height)
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: VerticalMediaListCellViewModel) {
        self.viewModel = viewModel
        if let title = viewModel.title {
            self.titleLabel.text = title
            self.subtitleLabel.text = viewModel.subtitle
            self.gridCVTopConstraint?.update(offset: Constants.vSpacing)
        }
        self.items = viewModel.media.map { MediaPosterImageCellViewModel(media: $0, didTapMedia: viewModel.didTapAnyMedia) }
        self.gridCollectionView.reloadData()
        self.gridCollectionView.layoutIfNeeded()
        self.layoutIfNeeded()
    }
    
    public func reloadData(withNewItems newItems: [Media]) {
        newItems.forEach {
            let vm = MediaPosterImageCellViewModel(media: $0) { [weak self] in
                guard let self = self else { return }
                self.viewModel?.didTapAnyMedia?($0)
            }
            items.append(vm)
        }
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.gridCollectionView.reloadData()
            self.invalidateIntrinsicContentSize()
            self.viewModel?.onHeightChangedRequest?()
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(gridCollectionView)
        gridCollectionView.snp.makeConstraints {
            gridCVTopConstraint = $0.top.equalTo(subtitleLabel.snp.bottom).constraint
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-Constants.vSpacing)
        }
        
        contentView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.top.equalTo(gridCollectionView.snp.bottom).offset(Constants.spacing)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Constants.loadingIndicatorSize)
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

extension VerticalMediaListCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MediaPosterImageCell.identifier, for: indexPath
        ) as? MediaPosterImageCell else { return UICollectionViewCell() }
        let vm = items[indexPath.row]
        cell.configure(with: vm)
        return cell
    }
}
