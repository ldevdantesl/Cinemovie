//
//  TVSeriesDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit
import SnapKit
import SDWebImage

protocol TVSeriesDetailsScreenViewProtocol: AnyObject {
    var activeTooltipView: CMTooltipView? { get set }
    var activeTooltipWorkItem: DispatchWorkItem? { get set }
    var activePopUpView: PopUPView? { get set }
    
    func didRecieveError(_ errorStr: String)
    // MARK: - OTHER
    func applySnapshot(sections: [TVSeriesDetailsScreenVC.Sections], items: [TVSeriesDetailsScreenVC.Sections : [TVSeriesDetailsScreenVC.Items]])
    
    // MARK: - LOADING
    func showLoading()
    func hideLoading()
}

final class TVSeriesDetailsScreenVC: UIViewController {
    
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
        case subDetails(TVSeriesDetailsSubDetailsViewModel)
        case watchListButton(WatchlistButtonCellViewModel)
        case overview(OverviewCellViewModel)
        case cast(CastListCellViewModel)
        case production(ProductionInfoCellViewModel)
        case rateAndShare(RateAndShareCellViewModel)
        case mediaExtras(MediaExtrasCellViewModel)
        case unavailable(UnavailableInfoCellViewModel)
    }

    // MARK: - VIPER
    var presenter: TVSeriesDetailsScreenPresenterProtocol?
    var activeTooltipView: CMTooltipView?
    var activeTooltipWorkItem: DispatchWorkItem?
    var activePopUpView: PopUPView?
    
    // MARK: - PROPERTIES
    private var viewModels: [CellViewModelBaseClass] = []
    private var sectionStore: CMDiffableSectionStore = CMDiffableSectionStore<Sections>()
    private lazy var isFirstScreen = navigationController?.viewControllers.count ?? 0 > 1
    
    // MARK: - VIEW PROPERTIES
    private let downloadView: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: DiffableCollectionView = {
        let cv = DiffableCollectionView<Sections, Items>(layout: createLayout())
        cv.contentInsetAdjustmentBehavior = .never
        cv.backgroundColor = CMColor.cmBackground
        cv.layer.zPosition = 0
        cv.register(cellClass: WatchlistButtonCell.self)
        cv.register(cellClass: OverviewCell.self)
        cv.register(cellClass: RateAndShareCell.self)
        cv.register(cellClass: ProductionInfoCell.self)
        cv.register(cellClass: BackdropImageCell.self)
        cv.register(cellClass: TitleAndTaglineCell.self)
        cv.register(cellClass: CastListCell.self)
        cv.register(cellClass: MediaExtrasCell.self)
        cv.register(cellClass: TVSeriesDetailsSubDetailsView.self)
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupUI()
        configureDataSource()
        downloadView.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SDImageCache.shared.clearMemory()
    }
    
    deinit {
        print("TVSeriesDetails is deinited")
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
        view.addSubview(downloadView)
        downloadView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.bringSubviewToFront(downloadView)
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
                cell?.configure(with: vm)
                return cell
                
            case .subDetails(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? TVSeriesDetailsSubDetailsView
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

extension TVSeriesDetailsScreenVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? BackdropImageCell else { return }
        let offsetY = scrollView.contentOffset.y
        offsetY <= 0 ? cell.scaleImage(to: offsetY) : cell.resetScale()
    }
}

extension TVSeriesDetailsScreenVC: TVSeriesDetailsScreenViewProtocol {
    
    func applySnapshot(sections: [Sections], items: [Sections : [Items]]) {
        sectionStore.update(sections)
        collectionView.applySnapshot(sections: sections, itemsBySection: items)
    }
    
    func showLoading() {
        downloadView.show()
    }
    
    func hideLoading() {
        downloadView.hide()
    }
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ errorStr: String) {
        let alert = UIAlertController(
            title: "Oops..",
            message: errorStr,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            isFirstScreen ? self.dismiss(animated: true) : presenter?.didTapBackButton()
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}
