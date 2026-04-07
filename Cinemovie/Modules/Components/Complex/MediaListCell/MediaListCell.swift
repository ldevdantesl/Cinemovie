//
//  MediaListCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.03.2025.
//

import UIKit
import SnapKit

final class MediaListCellViewModel: CellViewModelBaseClass {
    let listName: String
    let listSubtitle: String?
    let mediaItems: [MediaProtocol]
    let didTapMediaItem: ((MediaProtocol) -> Void)?
    
    init(mediaItems: [MediaProtocol], listName: String, listSubtitle: String? = nil, didTapMediaItem: ((MediaProtocol) -> Void)? = nil) {
        self.mediaItems = mediaItems
        self.listName = listName
        self.listSubtitle = listSubtitle
        self.didTapMediaItem = didTapMediaItem
        super.init(cellIdentifier: "MediaListCell")
    }
}

final class MediaListCell: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 5.0
        static let biggerSpacing = 10.0
        static let itemWidth = 120.0
        static let itemHeight = 180.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MediaListCellViewModel?
    private var items: [MediaProtocol] = []
    
    // MARK: - VIEW PROPERTIES
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: Constants.itemWidth, height: Constants.itemHeight)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = CMColor.cmBackground
        view.delegate = self
        view.dataSource = self
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
        self.items = []
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let fittingHeight = titleLabel.intrinsicContentSize.height + subtitleLabel.intrinsicContentSize.height +
        Constants.biggerSpacing + Constants.spacing + Constants.itemHeight
        layoutAttributes.frame.size.height = fittingHeight
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: MediaListCellViewModel) {
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.listName
        self.subtitleLabel.text = viewModel.listSubtitle
        self.items = viewModel.mediaItems
        
        self.collectionView.reloadData()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(10.0)
        }
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview().inset(10.0)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(Constants.biggerSpacing)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension MediaListCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MediaPosterImageCell.identifier, for: indexPath
        ) as? MediaPosterImageCell else { return UICollectionViewCell() }
        
        let item = items[indexPath.item]
        let vm = MediaPosterImageCellViewModel(media: item) { [weak self] in
            guard let self = self else { return }
            self.viewModel?.didTapMediaItem?($0)
        }
        cell.configure(with: vm)
        return cell
    }
}
