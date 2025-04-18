//
//  TrendingPeopleCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.04.2025.
//

import UIKit
import SnapKit

final class TrendingPeopleCellViewModel: CellViewModelBaseClass {
    let people: [Person]
    let title: String
    let subtitle: String?
    let didTapPerson: ((Person) -> Void)?
    
    init(people: [Person], title: String = "Trending People", subtitle: String? = "Celebs in Spotlight", didTapPerson: ((Person) -> Void)?) {
        self.people = people
        self.title = title
        self.subtitle = subtitle
        self.didTapPerson = didTapPerson
        super.init(cellIdentifier: "TrendingPeopleCell")
    }
}

final class TrendingPeopleCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 5.0
        static let biggerSpacing = 10.0
        
        static let itemSpacing: CGFloat = 10
        static let itemsPerRow: CGFloat = 4
        static let totalSpacing = itemSpacing * (itemsPerRow + 1)
        static let itemWidth = floor((UIConstants.screenWidth - totalSpacing) / itemsPerRow)
        static let itemHeight = itemWidth
        static let targetInset = (itemWidth + itemSpacing) / 2
        static var collectionViewHeight: CGFloat {
            let totalItemsHeight = itemHeight * CGFloat(3)
            let totalSpacing = itemSpacing * CGFloat(3 - 1)
            return totalItemsHeight + totalSpacing
        }
    }
    
    // MARK: - PROPERTIES
    private var viewModel: TrendingPeopleCellViewModel?
    private var items: [TrendingPersonCellViewModel] = []
    
    // MARK: - VIEW PROPERTIES
    private let trendingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trendingSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .footnote, fontName: .avenirDemiBoldItalic)
        label.textColor = CMColor.cmSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var peopleCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CMColor.cmBackground
        view.delegate = self
        view.dataSource = self
        view.register(cellClass: TrendingPersonCell.self)
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let fittingSizeHeight = trendingTitleLabel.intrinsicContentSize.height + trendingSubtitleLabel.intrinsicContentSize.height +
        Constants.collectionViewHeight + Constants.spacing + Constants.biggerSpacing
        layoutAttributes.frame.size.height = fittingSizeHeight
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: TrendingPeopleCellViewModel) {
        self.viewModel = viewModel
        self.trendingTitleLabel.text = viewModel.title
        self.trendingSubtitleLabel.text = viewModel.subtitle
        self.items = viewModel.people.map { TrendingPersonCellViewModel(person: $0, didTapAction: viewModel.didTapPerson) }
        self.peopleCollectionView.reloadData()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(trendingTitleLabel)
        trendingTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        addSubview(trendingSubtitleLabel)
        trendingSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(trendingTitleLabel.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
        }
        
        addSubview(peopleCollectionView)
        peopleCollectionView.snp.makeConstraints {
            $0.top.equalTo(trendingSubtitleLabel.snp.bottom).offset(Constants.biggerSpacing)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            let item3 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(Constants.itemWidth), heightDimension: .absolute(Constants.itemHeight)))
            
            let groupBy3 = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Constants.itemHeight)),
                subitem: item3, count: Int(Constants.itemsPerRow - 1)
            )
            groupBy3.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.targetInset, bottom: 0, trailing: Constants.targetInset)
            groupBy3.interItemSpacing = .fixed(Constants.itemSpacing)
            
            let item4 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(Constants.itemWidth), heightDimension: .absolute(Constants.itemHeight)))
            
            let groupBy4 = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Constants.itemHeight)),
                subitem: item4, count: Int(Constants.itemsPerRow)
            )
            groupBy4.interItemSpacing = .fixed(Constants.itemSpacing)
            
            let vGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)),
                subitems: [groupBy3, groupBy4, groupBy3]
            )
            vGroup.interItemSpacing = .fixed(Constants.itemSpacing)
            
            let section = NSCollectionLayoutSection(group: vGroup)
            section.orthogonalScrollingBehavior = .none
            return section
        }
    }
}

extension TrendingPeopleCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrendingPersonCell.identifier, for: indexPath
        ) as? TrendingPersonCell else { return UICollectionViewCell() }
        
        let itemVM = items[indexPath.row]
        cell.configure(viewModel: itemVM)
        return cell
    }
}
