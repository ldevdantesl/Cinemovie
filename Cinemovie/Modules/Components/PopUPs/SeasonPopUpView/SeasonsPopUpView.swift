//
//  SeasonsPopUpView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 15.04.2025.
//

import UIKit
import SnapKit

struct SeasonsPopUpViewModel: PopUPViewModel {
    let seasonDetails: TVSeasonDetails
    let onClose: (() -> Void)?
    
    static let defaultItemHeight = 120.0
}

final class SeasonsPopUpView: PopUPView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let loadingIndicatorSize = 15.0
        
        static let itemSpacing = 10.0
        static let itemWidth = UIConstants.screenWidth - 40
        static let itemHeight = SeasonsPopUpViewModel.defaultItemHeight

        static let vSpacing = 20.0
        static let spacing = 10.0
        
        static let defaultImageName = "questionmark"
        static let defaultImageSize = 20.0
        
        static let posterHeight = UIConstants.screenHeight * 0.3
        static let posterWidth = posterHeight * (2/3)
        static let posterCornerRadius = 10.0
        static let posterBorderWidth = 0.5
    }
    
    // MARK: - PROPERTIES
    private let viewModel: SeasonsPopUpViewModel
    private var items: [EpisodeItemPopUpCellViewModel]
    
    // MARK: - VIEW PROPERTIES
    private lazy var posterImageView: AsyncImageView = {
        let image = AsyncImageView()
        image.setCornerRadius(Constants.posterCornerRadius)
        image.setBorder(width: Constants.posterBorderWidth, borderColor: CMColor.cmLabel)
        image.setAsyncImage(
            path: viewModel.seasonDetails.posterPath, size: .original,
            notFoundImageSystemName: Constants.defaultImageName,
            notFoundPointSize: Constants.defaultImageSize
        )
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var episodesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.itemSpacing
        layout.estimatedItemSize = CGSize(width: UIConstants.screenWidth - 40, height: 120)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.register(cellClass: EpisodeItemPopUpCell.self)
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    init(viewModel: SeasonsPopUpViewModel) {
        self.viewModel = viewModel
        self.items = viewModel.seasonDetails.episodes.map { EpisodeItemPopUpCellViewModel(episode: $0) }
        super.init(viewModel: viewModel)
        setupUI()
        episodesCollectionView.reloadData()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(posterImageView)
        posterImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constants.vSpacing)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Constants.posterHeight)
            $0.width.equalTo(Constants.posterWidth)
        }
        
        addSubview(episodesCollectionView)
        episodesCollectionView.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(Constants.spacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.vSpacing)
            $0.bottom.equalToSuperview()
        }
    }
}

extension SeasonsPopUpView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EpisodeItemPopUpCell.identifier, for: indexPath
        ) as? EpisodeItemPopUpCell else { return UICollectionViewCell() }
        
        let itemVM = items[indexPath.row]
        cell.configure(viewModel: itemVM)
        return cell
    }
}
