//
//  MediaSearchCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 25.04.2025.
//

import UIKit
import SnapKit

final class MediaSearchCellViewModel: CellViewModelBaseClass {
    let movies: [Movie]
    let tvSeries: [TVSeries]
    let people: [Person]
    
    init(movies: [Movie], tvSeries: [TVSeries], people: [Person]) {
        self.movies = movies
        self.tvSeries = tvSeries
        self.people = people
        super.init(cellIdentifier: "MediaSearchCell")
    }
}

final class MediaSearchCell: ReusableCellBaseClass {
    // MARK: - TYPEALIAS
    typealias CellVMs = CellViewModelBaseClass & CellWithHeightProtocol
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let tabsSpacing = 10.0
    }
    
    fileprivate enum Tabs: CaseIterable {
        case movies
        case tvSeries
        case people
        case none
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MediaSearchCellViewModel?
    private var selectedTab: Tabs = .none
    private var items: [Tabs : CellVMs] = [:]
    private var visibleTabs: [Tabs] {
        return Tabs.allCases.filter { items[$0] != nil }
    }
    
    // MARK: - VIEW PROPERTIES
    private lazy var tabsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.tabsSpacing
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = CMColor.cmBackground
        view.register(cellClass: TabItemCell.self)
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = CMColor.cmBackground
        view.delegate = self
        view.dataSource = self
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
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: MediaSearchCellViewModel) {
        self.viewModel = viewModel
        
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() { }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, env in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: item.layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    // MARK: - OBJC FUNC
}

extension MediaSearchCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
