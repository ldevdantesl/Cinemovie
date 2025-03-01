//
//  CMMovieCastList.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.02.2025.
//

import UIKit
import SnapKit

final class CMMovieCastList: UIView {
    private var cast: [Cast] = []

    private let cellHeight = (UIConstants.screenHeight / 4)
    private let cellWidth = (UIConstants.screenWidth / 4)
    
    private let castLabel: UILabel = {
        let label = UILabel()
        label.text = "Cast"
        label.font = CMFont.font(size: .body, fontName: .avenir)
        label.textColor = CMColor.cmSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var castCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(
            CMMovieCastListCell.self,
            forCellWithReuseIdentifier: CMMovieCastListCell.identifier
        )
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNCTIONS
    public func reloadData(cast: [Cast]) {
        self.cast = cast
        self.castCollectionView.reloadData()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        self.addSubview(castLabel)
        castLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        
        self.addSubview(castCollectionView)
        castCollectionView.snp.makeConstraints {
            $0.top.equalTo(castLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension CMMovieCastList: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CMMovieCastListCell.identifier,
            for: indexPath
        ) as? CMMovieCastListCell else {
            fatalError()
        }
        
        let item = cast[indexPath.row]
        cell.configure(item: item)
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
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}
