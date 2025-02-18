//
//  CMMovieListComponent.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import SnapKit
import UIKit

final class CMMovieList: UIView {
    // MARK: - Public properties
    public var didTapMovie: ((QueryMovie) -> Void)?
    
    // MARK: - Private properties
    private let cellWidth = (UIConstants.screenWidth / 3) - 15
    private let cellHeight = (UIConstants.screenWidth / 3) * 1.3
    
    private var movies: [QueryMovie]
    private var listTitleLabel: UILabel?
    private var listSubtitleLabel: UILabel?
    
    private lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumLineSpacing = 10

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flow)
        cv.backgroundColor = CMColor.cmBackground
        cv.delegate = self
        cv.dataSource = self
        cv.isScrollEnabled = true
        cv.isUserInteractionEnabled = true
        cv.alwaysBounceHorizontal = true
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(
            CMMovieListCell.self,
            forCellWithReuseIdentifier: CMMovieListCell.identifier
        )
        return cv
    }()
    
    init(
        movies: [QueryMovie],
        listTitle: String?,
        listSubtitle: String?,
        didTapMovie: ((QueryMovie) -> Void)? = nil
    ) {
        self.movies = movies
        self.didTapMovie = didTapMovie
        
        if let listTitle = listTitle {
            let listTitleLabel = UILabel()
            listTitleLabel.font = CMFont.subtitleFont
            listTitleLabel.textColor = CMColor.cmLabel
            listTitleLabel.textAlignment = .left
            listTitleLabel.text = listTitle
            self.listTitleLabel = listTitleLabel
        }
        
        if let listSubtitle = listSubtitle {
            let listSubtitleLabel = UILabel()
            listSubtitleLabel.font = CMFont.bodyFont
            listSubtitleLabel.textColor = CMColor.cmSecondary
            listSubtitleLabel.textAlignment = .left
            listSubtitleLabel.text = listSubtitle
            self.listSubtitleLabel = listSubtitleLabel
        }
        
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNCTIONS
    func updateMovies(_ movies: [QueryMovie]) {
        self.movies = movies
        collectionView.reloadData()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        if let listTitleLabel = listTitleLabel {
            addSubview(listTitleLabel)
            listTitleLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(5)
                $0.leading.equalToSuperview().offset(10)
                $0.trailing.equalToSuperview().offset(-10)
            }
            
            if let listSubtitleLabel = listSubtitleLabel {
                addSubview(listSubtitleLabel)
                listSubtitleLabel.snp.makeConstraints {
                    $0.top.equalTo(listTitleLabel.snp.bottom).offset(5)
                    $0.leading.trailing.equalToSuperview()
                }
                
                addSubview(collectionView)
                collectionView.snp.makeConstraints {
                    $0.top.equalTo(listSubtitleLabel.snp.bottom).offset(10)
                    $0.leading.trailing.bottom.equalToSuperview()
                    $0.height.equalTo(cellHeight)
                }
            } else {
                addSubview(collectionView)
                collectionView.snp.makeConstraints {
                    $0.top.equalTo(listTitleLabel.snp.bottom).offset(10)
                    $0.leading.trailing.bottom.equalToSuperview()
                    $0.height.equalTo(cellHeight)
                }
            }
        } else {
            addSubview(collectionView)
            collectionView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(5)
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(cellHeight)
            }
        }
    }
}

extension CMMovieList: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        self.didTapMovie?(selectedMovie)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        movies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CMMovieListCell.identifier, for: indexPath
        ) as? CMMovieListCell else {
            fatalError("CMMovieListCell is not registered")
        }

        cell.configure(movie: movies[indexPath.row])
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
