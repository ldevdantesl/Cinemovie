//
//  CMMovieListComponent.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import SnapKit
import UIKit

struct MediaListCellViewModel {
    private(set) var isMovieMedia: Bool
    let movies: [Movie]
    let tvShows: [TVSeries]
    let listTitle: String
    let listSubtitle: String?
    let didTapMovie: ((Movie) -> Void)?
    let didTapTVShow: ((TVSeries) -> Void)?
    let cellHeight: CGFloat
    
    init(movies: [Movie], listTitle: String, listSubtitle: String? = nil, didTapMovie: ((Movie) -> Void)? = nil) {
        self.isMovieMedia = true
        self.movies = movies
        self.listTitle = listTitle
        self.listSubtitle = listSubtitle
        self.didTapMovie = didTapMovie
        self.tvShows = []
        self.didTapTVShow = nil
        self.cellHeight = Self.calculateCellHeight(listSubtitle: listSubtitle)
    }
    
    init(tvShows: [TVSeries], listTitle: String, listSubtitle: String? = nil, didTapTVShow: ((TVSeries) -> Void)? = nil) {
        self.isMovieMedia = false
        self.movies = []
        self.listTitle = listTitle
        self.listSubtitle = listSubtitle
        self.didTapMovie = nil
        self.tvShows = tvShows
        self.didTapTVShow = didTapTVShow
        self.cellHeight = Self.calculateCellHeight(listSubtitle: listSubtitle)
    }
    
    static func calculateCellHeight(listSubtitle: String?) -> CGFloat {
        guard let _ = listSubtitle else {
            return ((UIConstants.screenWidth / 3) * 1.3) + 25
        }
        return ((UIConstants.screenWidth / 3) * 1.3) + 40
    }
}

extension MediaListCellViewModel: Hashable {
    static func == (lhs: MediaListCellViewModel, rhs: MediaListCellViewModel) -> Bool {
        lhs.movies == rhs.movies &&
        lhs.tvShows == rhs.tvShows &&
        lhs.listTitle == rhs.listTitle &&
        lhs.listSubtitle == rhs.listSubtitle
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(movies)
        hasher.combine(tvShows)
        hasher.combine(listTitle)
        hasher.combine(listSubtitle)
    }
}

final class MediaListCell: UICollectionViewCell {
    
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
    public var isShowingMovieMedia: Bool {
        viewModel?.isMovieMedia ?? true
    }
    
    private var viewModel: MediaListCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let listTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .subtitle, fontName: .avenirDemiBold)
        label.textColor = CMColor.cmLabel
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let listSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .footnote, fontName: .avenirMediumItalic)
        label.textColor = CMColor.cmSecondary
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [listTitleLabel])
        vStack.axis = .vertical
        vStack.spacing = 0
        vStack.alignment = .leading
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumLineSpacing = Paddings.biggerSpacing
        flow.itemSize = CGSize(width: Constants.cellWidth, height: Constants.cellHeight)

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
            MediaItemCell.self,
            forCellWithReuseIdentifier: MediaItemCell.identifier
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
    public func configure(viewModel: MediaListCellViewModel) {
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
            $0.horizontalEdges.equalToSuperview()
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(vStack.snp.bottom).offset(Paddings.spacing)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.cellHeight)
        }
    }
}

extension MediaListCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let selectedMedia: Media = viewModel.isMovieMedia ? viewModel.movies[indexPath.row] : viewModel.tvShows[indexPath.row]
        switch selectedMedia {
        case let movie as Movie: viewModel.didTapMovie?(movie)
        case let tvshow as TVSeries: viewModel.didTapTVShow?(tvshow)
        default: ()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.isMovieMedia ? viewModel.movies.count : viewModel.tvShows.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MediaItemCell.identifier, for: indexPath
        ) as? MediaItemCell else {
            fatalError("CMMovieListCell is not registered")
        }
        
        guard let viewModel = viewModel else { return cell }
        let vm = isShowingMovieMedia ? MediaItemCellViewModel(movie: viewModel.movies[indexPath.row]) :
        MediaItemCellViewModel(tvShow: viewModel.tvShows[indexPath.row])
        cell.configure(viewModel: vm)
        return cell
    }
}
