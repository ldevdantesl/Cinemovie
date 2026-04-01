//
//  MovieDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit
import SnapKit
import SDWebImage

protocol MovieDetailsScreenViewProtocol: AnyObject {
    // MARK: - PROPERTIES
    var activeTooltipView: CMTooltipView? { get set }
    var activeTooltipWorkItem: DispatchWorkItem? { get set }
    var activePopUpView: ActorPopupView? { get set }

    // MARK: - OTHER
    func applySnapshot(sections: [MovieDetailsScreenVC.Sections], items: [MovieDetailsScreenVC.Sections : [MovieDetailsScreenVC.Items]])
    
    // MARK: - LOADING
    func showLoading()
    func hideLoading()
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ errorStr: String, goesBack: Bool)
}

final class MovieDetailsScreenVC: UIViewController {
    
    // MARK: - OTHER
    enum Sections: CaseIterable, Hashable {
        case backdropImage
        case titleAndTagline
        case subDetails
        case watchlistButton
        case overview
        case cast
        case production
        case rateAndShare
        case mediaExtras
        case unavailable
    }
    
    enum Items: Hashable {
        case backdropImage(BackdropImageCellViewModel)
        case titleAndTagline(TitleAndTaglineCellViewModel)
        case subDetails(MovieDetailsSubDetailsCellViewModel)
        case watchListButton(WatchlistButtonCellViewModel)
        case overview(OverviewCellViewModel)
        case cast(CastListCellViewModel)
        case production(ProductionInfoCellViewModel)
        case rateAndShare(RateAndShareCellViewModel)
        case mediaExtras(MediaExtrasCellViewModel)
        case unavailable(UnavailableInfoCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: MovieDetailsScreenPresenterProtocol?
    var activeTooltipView: CMTooltipView?
    var activeTooltipWorkItem: DispatchWorkItem?
    var activePopUpView: ActorPopupView?
    
    // MARK: - PROPERTIES
    private var viewModels: [CellViewModelBaseClass] = []
    private var sectionStore = CMDiffableSectionStore<Sections>()
    
    // MARK: - VIEW PROPERTIES
    private let downloadingView: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: DiffableCollectionView = {
        let cv = DiffableCollectionView<Sections, Items>(layout: createLayout())
        cv.backgroundColor = CMColor.cmBackground
        cv.layer.zPosition = 0
        cv.register(cellClass: MovieDetailsSubDetailsCell.self)
        cv.register(cellClass: WatchlistButtonCell.self)
        cv.register(cellClass: OverviewCell.self)
        cv.register(cellClass: RateAndShareCell.self)
        cv.register(cellClass: ProductionInfoCell.self)
        cv.register(cellClass: BackdropImageCell.self)
        cv.register(cellClass: TitleAndTaglineCell.self)
        cv.register(cellClass: CastListCell.self)
        cv.register(cellClass: UnavailableInfoCell.self)
        cv.register(cellClass: MediaExtrasCell.self)
        cv.delegate = self
        return cv
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupUI()
        configureDataSource()
        downloadingView.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.alpha = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SDImageCache.shared.clearMemory()
    }
    
    deinit {
        print("MovieDetails is deinited")
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(downloadingView)
        downloadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let self = self else {
                let group = NSCollectionLayoutGroup(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                return NSCollectionLayoutSection(group: group)
            }
            let section = self.sectionStore.section(at: sectionIndex)
            let edgeInsets: NSDirectionalEdgeInsets
            switch section {
            case .backdropImage: edgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0)
            case .titleAndTagline: edgeInsets =  NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
            default: edgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
            }
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: item.layoutSize, subitems: [item])
            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.contentInsets = edgeInsets
            return layoutSection
        }
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .mediaExtras(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? MediaExtrasCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .backdropImage(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? BackdropImageCell
                cell?.layer.zPosition = -1
                cell?.configure(with: vm)
                return cell
                
            case .subDetails(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? MovieDetailsSubDetailsCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .watchListButton(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? WatchlistButtonCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .cast(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? CastListCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .titleAndTagline(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? TitleAndTaglineCell
                cell?.layer.zPosition = 1
                cell?.configure(with: vm)
                return cell
                
            case .overview(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? OverviewCell
                cell?.configure(with: vm)
                return cell
                
            case .production(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? ProductionInfoCell
                cell?.configure(with: vm)
                return cell
                
            case .rateAndShare(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? RateAndShareCell
                cell?.configure(with: vm)
                return cell
                
            case .unavailable(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? UnavailableInfoCell
                cell?.configure(viewModel: vm)
                return cell
            }
        }
    }
}

extension MovieDetailsScreenVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? BackdropImageCell else { return }
        let offsetY = scrollView.contentOffset.y
        offsetY <= 0 ? cell.scaleImage(to: offsetY) : cell.resetScale()
    }
}

extension MovieDetailsScreenVC: MovieDetailsScreenViewProtocol {
    
    func applySnapshot(sections: [Sections], items: [Sections : [Items]]) {
        sectionStore.update(sections)
        collectionView.applySnapshot(sections: sections, itemsBySection: items)
    }
    
    func showLoading() {
        downloadingView.show()
    }
    
    func hideLoading() {
        downloadingView.hide()
    }
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ errorStr: String, goesBack: Bool) {
        guard presentedViewController == nil else { return }
        let alert = UIAlertController(
            title: "Oops..",
            message: errorStr,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            goesBack ? presenter?.didTapBackButton() : ()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
