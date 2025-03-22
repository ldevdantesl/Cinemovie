//
//  CMMovieCastList.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.02.2025.
//

import UIKit
import SnapKit

struct MediaDetailsCastListViewModel: MovieDetailsCellViewModel {
    let identifier: String = "MediaDetailsCastList"
    
    let cast: [Cast]?
    let didSelectCast: ((Cast) -> Void)?
    
    init(cast: [Cast]?, didSelectCast: ((Cast) -> Void)?) {
        self.cast = cast
        self.didSelectCast = didSelectCast
    }
}

final class MediaDetailsCastList: UICollectionViewCell {
    // MARK: - STATIC
    static let identifier = "MediaDetailsCastList"
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing: CGFloat = 5
        static let hSpacing: CGFloat = 15
        static let itemWidth = UIConstants.screenWidth / 4
        static let itemHeight = 120.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MediaDetailsCastListViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var castLabel: UILabel = {
        let label = UILabel()
        label.text = "Cast"
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.textColor = CMColor.cmSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: Constants.itemWidth, height: Constants.itemHeight)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = CMColor.cmBackground
        cv.register(MediaDetailsCastListCell.self, forCellWithReuseIdentifier: MediaDetailsCastListCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
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
    public func configure(viewModel: MediaDetailsCastListViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        self.addSubview(castLabel)
        castLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(castLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension MediaDetailsCastList: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.cast?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MediaDetailsCastListCell.identifier, for: indexPath
        ) as? MediaDetailsCastListCell else {
            return UICollectionViewCell()
        }
        let vm = MediaDetailsCastListCellViewModel(cast: viewModel?.cast?[indexPath.row])
        cell.configure(viewModel: vm)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cast = viewModel?.cast?[indexPath.row] else { return }
        viewModel?.didSelectCast?(cast)
    }
}
