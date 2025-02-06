//
//  PopularMoviesPageVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation
import UIKit
import SnapKit

final class CMPopularMoviesPVC: UIPageViewController {
    private var autoScrollTimer: Timer?
    
    private var pages: [UIViewController] = []
    private var movies: [QueryMovie] = []

    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = .white
        control.pageIndicatorTintColor = .gray
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    init(movies: [QueryMovie]) {
        self.movies = movies
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        setupPageControl()
        startAutoScroll()
    }

    // MARK: - PRIVATE FUNC
    private func setupPages() {
        guard !movies.isEmpty else { return }
        dataSource = self
        delegate = self
        movies.forEach { pages.append(CMPopularMoviesPageContentVC(movie: $0)) }

        if let firstPage = pages.first {
            setViewControllers(
                [firstPage], direction: .forward, animated: false)
        }
    }

    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0

        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(25)
            $0.centerX.equalToSuperview()
        }
    }

    private func startAutoScroll() {
        autoScrollTimer = Timer.scheduledTimer(
            timeInterval: 3.0,
            target: self,
            selector: #selector(scrollToNextPage),
            userInfo: nil,
            repeats: true
        )
    }
    
    // MARK: - OBJC FUNCTIONS
    @objc private func scrollToNextPage() {
        guard let currentVC = self.viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentVC) else { return }
        let nextIndex = (currentIndex + 1) % pages.count
        let nextVC = pages[nextIndex]
        
        setViewControllers([nextVC], direction: .forward, animated: true)
        pageControl.currentPage = nextIndex
    }
    
    // MARK: - UIPAGEVC CYCLE
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentVC = viewControllers?.first, let index = pages.firstIndex(of: currentVC) else { return 0 }
        return index
    }
}

extension CMPopularMoviesPVC: UIPageViewControllerDataSource,
    UIPageViewControllerDelegate
{
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController),
            index < pages.count - 1
        else { return nil }
        return pages[index + 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed, let currentVC = viewControllers?.first,
            let index = pages.firstIndex(of: currentVC)
        {
            pageControl.currentPage = index
        }
    }
}
