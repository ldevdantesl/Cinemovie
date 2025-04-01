//
//  TVSeriesDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit
import SnapKit

protocol TVSeriesDetailsScreenViewProtocol: AnyObject {
    var activeTooltipView: CMTooltipView? { get set }
    var activeTooltipWorkItem: DispatchWorkItem? { get set }
    var activeActorPopUpView: MediaDetailsActorPopupView? { get set }
    
    func didRecieveError(_ errorStr: String)
    func didGetAllTVSeriesData(_ details: TVSeriesDetails, cast: [Cast], videos: [Video])
}

final class TVSeriesDetailsScreenVC: UIViewController {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let collectionViewSpacing = 10.0
        static let aniDuration = 1.0
        static let hSpacing = 20.0
        static let biggerHSpacing = 30.0
        static let cellDefaultHeight = 100.0
    }

    // MARK: - VIPER
    var presenter: TVSeriesDetailsScreenPresenterProtocol?
    var activeTooltipView: CMTooltipView?
    var activeTooltipWorkItem: DispatchWorkItem?
    var activeActorPopUpView: MediaDetailsActorPopupView?
    
    // MARK: - PROPERTIES
    private var viewModels: [CellViewModelBaseClass] = []
    private var cachedCollectionViewCellHeights: [IndexPath : CGSize] = [:]
    private lazy var isFirstScreen = navigationController?.viewControllers.count ?? 0 > 1
    
    // MARK: - VIEW PROPERTIES
    private let downloadingView: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.collectionViewSpacing
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = CMColor.cmBackground
        cv.register(RateAndShareCell.self, forCellWithReuseIdentifier: RateAndShareCell.identifier)
        cv.register(ProductionInfoCell.self, forCellWithReuseIdentifier: ProductionInfoCell.identifier)
        cv.register(BackdropImageCell.self, forCellWithReuseIdentifier: BackdropImageCell.identifier)
        cv.register(TitleAndTaglineCell.self, forCellWithReuseIdentifier: TitleAndTaglineCell.identifier)
        cv.register(CastListCell.self, forCellWithReuseIdentifier: CastListCell.identifier)
        cv.register(TVSeriesDetailsSubDetailsView.self, forCellWithReuseIdentifier: TVSeriesDetailsSubDetailsView.identifier)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadingView.animateLogo()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
        view.addSubview(downloadingView)
        downloadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.bringSubviewToFront(downloadingView)
    }
}

extension TVSeriesDetailsScreenVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = viewModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier, for: indexPath)
        switch viewModel {
        case let vm as BackdropImageCellViewModel: (cell as? BackdropImageCell)?.configure(with: vm)
        case let vm as TitleAndTaglineCellViewModel: (cell as? TitleAndTaglineCell)?.configure(with: vm)
        case let vm as CastListCellViewModel: (cell as? CastListCell)?.configure(viewModel: vm)
        case let vm as TVSeriesDetailsSubDetailsViewModel: (cell as? TVSeriesDetailsSubDetailsView)?.configure(viewModel: vm)
        case let vm as ProductionInfoCellViewModel: (cell as? ProductionInfoCell)?.configure(with: vm)
        case let vm as RateAndShareCellViewModel: (cell as? RateAndShareCell)?.configure(with: vm)
        default: break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let size = cachedCollectionViewCellHeights[indexPath] {
            return size
        }
        
        let viewModel = viewModels[indexPath.row]
        let width = collectionView.frame.width
        
        let size: CGSize
        switch viewModel {
        case let vm as TVSeriesDetailsSubDetailsViewModel: size = CGSize(width: width - Constants.hSpacing, height: vm.cellHeight)
//        case let vm as BackdropImageCellViewModel: size = CGSize(width: width, height: vm.cellHeight)
//        case let vm as MediaDetailsTitleCellViewModel: size = CGSize(width: width - Constants.hSpacing, height: vm.cellHeight)
//        case let vm as CastListCellViewModel: size = CGSize(width: width - Constants.hSpacing, height: vm.cellHeight)
//        case let vm as ProductionInfoCellViewModel: size = CGSize(width: width - Constants.hSpacing, height: vm.cellHeight)
//        case let vm as RateAndShareCellViewModel: size = CGSize(width: width - Constants.biggerHSpacing, height: vm.cellHeight)
        default: return CGSize(width: width, height: Constants.cellDefaultHeight)
        }
        
        cachedCollectionViewCellHeights[indexPath] = size
        return size
    }
}

extension TVSeriesDetailsScreenVC: TVSeriesDetailsScreenViewProtocol {
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
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didGetAllTVSeriesData(_ details: TVSeriesDetails, cast: [Cast], videos: [Video]) {
        self.downloadingView.hide()
        
        self.viewModels = [
            BackdropImageCellViewModel(
                imagePath: details.backdropPath, size: .w1280,
                isBackButtonHidden: isFirstScreen, didTapBackButtonAction: presenter?.didTapBackButton
            ),
            TitleAndTaglineCellViewModel(movieName: details.name, movieTagline: details.tagline),
            
            TVSeriesDetailsSubDetailsViewModel(
                firstAirDate: details.firstAirDate, numberOfSeasons: details.numberOfSeasons ?? 1,
                numberOfEpisodes: details.numberOfEpisodes ?? 1, homepage: details.homepage,
                status: details.status ?? .canceled, nextEpisodeToAir: details.nextEpisodeToAir?.airDate,
                didTapView: presenter?.didTapTooltipView, didTapHomepage: presenter?.didTapHomepage
            ),
        ]
        
        !cast.isEmpty ? self.viewModels.append(CastListCellViewModel(cast: cast, didSelectCast: presenter?.didSelectActor)) : ()
        
        self.viewModels.append(ProductionInfoCellViewModel(companies: details.productionCompanies, countries: details.productionCountries))
        self.viewModels.append(RateAndShareCellViewModel(didTapShareButton: presenter?.didTapShareButton, didTapRateButton: presenter?.didTapRateButton))
        
        DispatchQueue.main.async {
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
            self.collectionView.reloadData()
            self.collectionView.performBatchUpdates(nil)
        }
    }
}
