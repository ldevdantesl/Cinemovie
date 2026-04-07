//
//  WatchlistDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit
import SnapKit

protocol AccountListDetailsScreenViewProtocol: AnyObject {
    // MARK: - PROPERTIES
    var downloadView: CMSplashView { get }
    
    // MARK: - PROGRAMMATIC
    func didRecieveMedia(movies: [Movie], series: [TVSeries])
    func didRecieveNewMedia(mediaType: MediaTypes, media: [MediaProtocol], paginating: Bool)
    
    // MARK: - OTHER
    func didRecieveError(_ errorStr: String, goesBack: Bool)
}

final class AccountListDetailsScreenVC: UIPageViewController {
    // MARK: - VIPER
    var presenter: AccountListDetailsScreenPresenterProtocol?
    let downloadView: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - PROPERTIES
    private lazy var viewControllersList: [UIViewController] = []
    
    // MARK: - VIEW PROPERTIES
    private let topDecorLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.opacity = 0
        return layer
    }()
    
    init() { super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil) }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        downloadView.show()
        dataSource = self
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.topDecorLayer.frame = CGRect(
            x: 0, y: 0,
            width: view.bounds.width,
            height: UIConstants.topInset
        )
    }
    
    private func setupUI() {
        view.layer.addSublayer(topDecorLayer)
        view.backgroundColor = CMColor.cmBackground
        
        view.addSubview(downloadView)
        downloadView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension AccountListDetailsScreenVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersList.firstIndex(of: viewController), index > 0 else { return nil }
        return viewControllersList[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersList.firstIndex(of: viewController), index < viewControllersList.count - 1 else { return nil }
        return viewControllersList[index + 1]
    }
}

extension AccountListDetailsScreenVC: AccountListDetailsScreenViewProtocol {
    // MARK: - PROGRAMMATIC
    func didRecieveMedia(movies: [Movie], series: [TVSeries]) {
        viewControllersList = []
        
        defer {
            if let firstVC = viewControllersList.first {
                setViewControllers([firstVC], direction: .forward, animated: true)
            }
            downloadView.hide {
                UIView.animate(withDuration: 2) { [weak self] in
                    guard let self = self else { return }
                    self.topDecorLayer.opacity = 1
                }
            }
        }
        
        guard !movies.isEmpty || !series.isEmpty else {
            let notFoundVC = AccountListDetailsMediaPageVC(media: [], mediaType: .movie, presenter: self.presenter)
            viewControllersList.append(notFoundVC)
            return
        }
        
        if !movies.isEmpty {
            let moviesVC = AccountListDetailsMediaPageVC(media: movies, mediaType: .movie, presenter: self.presenter)
            viewControllersList.append(moviesVC)
        }
        
        if !series.isEmpty {
            let seriesVC = AccountListDetailsMediaPageVC(media: series, mediaType: .tvShow, presenter: self.presenter)
            viewControllersList.append(seriesVC)
        }
    }
    
    func didRecieveNewMedia(mediaType: MediaTypes, media: [any MediaProtocol], paginating: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let currentVC = viewControllers?.first as? AccountListDetailsMediaPageVC else { return }
            guard currentVC.mediaType == mediaType else { return }
            currentVC.applySnapshotWithNewMedia(media, paginating: paginating)
        }
    }
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ errorStr: String, goesBack: Bool) {
        let alert = UIAlertController(title: "Oops...", message: errorStr, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            guard goesBack, let self = self else { return }
            self.presenter?.didTapBackButton()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
