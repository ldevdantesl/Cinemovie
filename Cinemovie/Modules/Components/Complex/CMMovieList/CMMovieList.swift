//
//  CMMovieListComponent.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import SnapKit
import UIKit

struct CMMovieListViewModel {
    let movies: [QueryMovie]
    let listTitle: String?
    let listSubtitle: String?
    let didTapMovie: ((QueryMovie) -> Void)?
    
    init(movies: [QueryMovie], listTitle: String?, listSubtitle: String? = nil, didTapMovie: ((QueryMovie) -> Void)? = nil) {
        self.movies = movies
        self.listTitle = listTitle
        self.listSubtitle = listSubtitle
        self.didTapMovie = didTapMovie
    }
}

final class CMMovieList: UIView {
    
    // MARK: - CONSTANTS
    fileprivate enum Paddings {
        static let spacing: CGFloat = 5
        static let biggerSpacing: CGFloat = 10
        static let horizontalPadding: CGFloat = 10
    }
    
    fileprivate enum Constants {
        static let cellWidth = (UIConstants.screenWidth / 3) - 15
        static let cellHeight = (UIConstants.screenWidth / 3) * 1.3
    }
    
    // MARK: - PROPERTIES
    private var viewModel: CMMovieListViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let listTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .subtitle, weight: .medium)
        label.textColor = CMColor.cmLabel
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let listSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, weight: .light)
        label.textColor = CMColor.cmSecondary
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [listTitleLabel])
        vStack.axis = .vertical
        vStack.spacing = Paddings.spacing
        vStack.alignment = .leading
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
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
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNCTIONS
    public func configure(viewModel: CMMovieListViewModel) {
        self.vStack.removeArrangedSubview(self.listSubtitleLabel)
        self.viewModel = viewModel
        self.listTitleLabel.text = viewModel.listTitle
        if let listSubtitle = viewModel.listSubtitle {
            self.listSubtitleLabel.text = listSubtitle
            self.vStack.addArrangedSubview(self.listSubtitleLabel)
        }
        collectionView.reloadData()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(Paddings.horizontalPadding)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(vStack.snp.bottom).offset(Paddings.spacing)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(Constants.cellHeight)
        }
    }
}

extension CMMovieList: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let selectedMovie = viewModel.movies[indexPath.row]
        viewModel.didTapMovie?(selectedMovie)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.movies.count
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
        
        guard let viewModel = viewModel else { return cell }

        cell.configure(movie: viewModel.movies[indexPath.row])
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: Constants.cellWidth, height: Constants.cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: Paddings.horizontalPadding, bottom: 0, right: Paddings.horizontalPadding)
    }
}
