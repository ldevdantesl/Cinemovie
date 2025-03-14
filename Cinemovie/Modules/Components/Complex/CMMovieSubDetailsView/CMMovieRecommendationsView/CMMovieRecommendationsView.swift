//
//  CMMovieMoreLikeThisView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.03.2025.
//

import UIKit
import SnapKit

final class CMMovieRecommendationsView: UIView {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let collectionViewWidth: CGFloat = UIConstants.screenWidth - 40
        static let itemWidth = (Constants.collectionViewWidth - (2 * 10)) / 3
        static let itemHeight = itemWidth * 1.4
        static let numberOfRows: CGFloat = 3
        static let lineSpacing: CGFloat = 10
        static let collectionViewHeight = (numberOfRows * itemHeight) + ((numberOfRows - 1) * lineSpacing) + 20
        static let totalMoviesToShow = 9
    }
    
    // MARK: - PROPERTIES
    private var movies: [QueryMovie] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.lineSpacing
        layout.minimumLineSpacing = Constants.lineSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CMMovieRecommendationCell.self, forCellWithReuseIdentifier: CMMovieRecommendationCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    override var intrinsicContentSize: CGSize {
        let totalHeight = Constants.collectionViewHeight
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    public func configure(movies: [QueryMovie]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    public func reloadData() {
        collectionView.reloadData()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension CMMovieRecommendationsView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int { return movies.isEmpty ? 0 : Constants.totalMoviesToShow }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CMMovieRecommendationCell.identifier,
            for: indexPath
        ) as? CMMovieRecommendationCell else {
            fatalError()
        }
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: floor(Constants.itemWidth), height: floor(Constants.itemHeight))
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.lineSpacing, left: 0, bottom: Constants.lineSpacing, right: 0)
    }
}
