//
//  MediaListCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.03.2025.
//

import UIKit
import SnapKit

struct MediaListCellViewModel: CellViewModel, Hashable {
    let id: String = UUID().uuidString
    let cellIdentifier: String = "MediaListCell"
    let listName: String
    let listSubtitle: String?
    let mediaItems: [Media]
    let didTapMediaItem: ((Media) -> Void)?
    static let cellHeight: CGFloat = 230
    
    init(mediaItems: [Media], listName: String, listSubtitle: String? = nil, didTapMediaItem: ((Media) -> Void)? = nil) {
        self.mediaItems = mediaItems
        self.listName = listName
        self.listSubtitle = listSubtitle
        self.didTapMediaItem = didTapMediaItem
    }
    
    static func == (lhs: MediaListCellViewModel, rhs: MediaListCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class MediaListCell: UICollectionViewCell, ReusableCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 5.0
        static let biggerSpacing = 10.0
        static let itemWidth = 120
        static let itemHeight = 180
    }
    
    private enum MediaListSection: Hashable {
        case main
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MediaListCellViewModel?
    
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
    
    private lazy var collectionView: CMCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: Constants.itemWidth, height: Constants.itemHeight)
        
        let view = CMCollectionView<MediaListSection, MediaPosterImageCellViewModel>(layout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = CMColor.cmBackground
        view.register(cellClass: MediaPosterImageCell.self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureDataSource()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: MediaListCellViewModel) {
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.listName
        self.subtitleLabel.text = viewModel.listSubtitle
        
        collectionView.applySnapshot(
            sections: [.main],
            itemsBySection: [.main : viewModel.mediaItems.map { .init(media: $0, didTapMedia: viewModel.didTapMediaItem) }]
        )
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(Constants.biggerSpacing)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.itemHeight)
        }
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier, for: indexPath) as? MediaPosterImageCell
            cell?.configure(with: viewModel)
            return cell
        }
        
        collectionView.setDidSelectHandler { indexPath in
            guard let viewModel = self.viewModel else { return }
            let item = viewModel.mediaItems[indexPath.row]
            viewModel.didTapMediaItem?(item)
        }
    }
}
