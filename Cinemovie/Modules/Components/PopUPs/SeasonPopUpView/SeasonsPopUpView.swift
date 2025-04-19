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
    let didTapClose: (() -> Void)?
    
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
    private var items: [EpisodeItemPopUpCellViewModel] = []
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = CMColor.cmBackground
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var episodesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.itemSpacing
        
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
        super.init(viewModel: viewModel)
        self.items = viewModel.seasonDetails.episodes.map {
            EpisodeItemPopUpCellViewModel(episode: $0) { [weak self] in
                guard let self = self else { return }
                self.episodesCollectionView.collectionViewLayout.invalidateLayout()
            }
        }
        setupUI()
        episodesCollectionView.reloadData()
        
        guard let imageURL = URLHelper.getImageURL(with: viewModel.seasonDetails.posterPath, size: .original) else {
            posterImageView.image = UIImage(systemName: Constants.defaultImageName)
            posterImageView.preferredSymbolConfiguration = .init(pointSize: Constants.defaultImageSize, weight: .bold)
            posterImageView.contentMode = .center
            return
        }
        
        print("ImageURL: \(imageURL)")
        
        self.loadingIndicator.startAnimating()
        posterImageView.sd_setImage(with: imageURL) { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.posterImageView.layoutIfNeeded()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.layer.cornerRadius = Constants.posterCornerRadius
        posterImageView.layer.borderColor = CMColor.cmLabel.cgColor
        posterImageView.layer.borderWidth = Constants.posterBorderWidth
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        posterImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(Constants.loadingIndicatorSize)
        }
        
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

extension SeasonsPopUpView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellVM = items[indexPath.row]
        return CGSize(width: UIConstants.screenWidth - 40, height: cellVM.cellHeight)
    }
}
