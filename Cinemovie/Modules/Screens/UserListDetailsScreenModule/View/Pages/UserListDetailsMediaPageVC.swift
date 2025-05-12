//
//  UserListDetailsMediaPageVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 11.05.2025.
//

import UIKit
import SnapKit

final class UserListDetailsMediaPageVC: UIViewController {

    // MARK: - SECTIONS
    enum Sections: Hashable {
        case main
    }
    
    enum Items: Hashable {
        case mediaListVM(VerticalMediaListCellViewModel)
    }
    
    enum SupplementaryKinds {
        static let headerItem = SupplementaryHeaderCell.identifier
        static let headerBlur = TopBlurHeaderCell.identifier
    }
    
    // MARK: - PROPERTIES
    private let mediaType: MediaTypes
    private let media: [Media]
    private weak var presenter: UserListDetailsScreenPresenterProtocol?
    
    // MARK: - VIEW PROPERTIES
    private lazy var refreshController: UIRefreshControl = {
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(didCallRefresh), for: .valueChanged)
        refreshController.backgroundColor = .black
        refreshController.tintColor = CMColor.cmLabel
        return refreshController
    }()
    
    private lazy var collectionView: DiffableCollectionView = {
        let view = DiffableCollectionView<Sections, Items>(layout: createLayout(), ignoresTopSafeArea: false, showsTopBlur: false)
        view.backgroundColor = CMColor.cmBackground
        view.refreshControl = refreshController
        view.register(cellClass: VerticalMediaListCell.self)
        view.registerSupplementaryHeaderItem(cellClass: SupplementaryHeaderCell.self, elementKind: SupplementaryKinds.headerItem)
        view.registerSupplementaryHeaderItem(cellClass: TopBlurHeaderCell.self, elementKind: SupplementaryKinds.headerBlur)
        return view
    }()
    
    // MARK: - LIFECYCLE
    init(media: [Media], mediaType: MediaTypes, presenter: UserListDetailsScreenPresenterProtocol?) {
        self.media = media
        self.mediaType = mediaType
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        let mediaListVM = VerticalMediaListCellViewModel(media: media, didTapAnyMedia: presenter?.didTapAnyMedia)
        self.collectionView.applySnapshot(sections: [.main], itemsBySection: [.main : [.mediaListVM(mediaListVM)]])
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
            elementKind: SupplementaryKinds.headerBlur, alignment: .top
        )
        headerItem.pinToVisibleBounds = true
        headerItem.extendsBoundary = false
        
        config.boundarySupplementaryItems = [headerItem]
        
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, environment in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: item.layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
                elementKind: SupplementaryKinds.headerItem, alignment: .top
            )
            headerItem.pinToVisibleBounds = true
            
            section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.boundarySupplementaryItems = [headerItem]
            return section
        }, configuration: config)
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .mediaListVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? VerticalMediaListCell
                cell?.configure(viewModel: vm)
                return cell
            }
        }
        
        collectionView.setSupplementaryViewProvider { [weak self] collectionView, elementKind, indexPath in
            guard let self = self else { return nil }
            guard elementKind == SupplementaryKinds.headerItem else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: TopBlurHeaderCell.identifier, for: indexPath) as? TopBlurHeaderCell
            }
            
            guard let cell = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind, withReuseIdentifier: SupplementaryHeaderCell.identifier, for: indexPath
            ) as? SupplementaryHeaderCell else { return nil }
            let vm = SupplementaryHeaderViewModel(title: self.mediaType == .movie ? "Movies" : "TVSeries", subtitle: "Blah")
            cell.configure(viewModel: vm)
            return cell
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didCallRefresh() {
    }
}

