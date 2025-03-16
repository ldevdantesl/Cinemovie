//
//  CMMovieSubDetailsView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.03.2025.
//

import UIKit
import SnapKit

final class CMMovieSubDetailsView: UIView {
    
    // MARK: - CONSTANTS
    fileprivate enum Paddings {
        static let hStackSpacing: CGFloat = 10
        static let topSpacing: CGFloat = 10
    }
    
    fileprivate enum Constants {
        static let dividerHeight: CGFloat = 2
        static let aniDurations: CGFloat = 0.3
    }
    
    fileprivate enum Tabs: Int {
        case collection = 0
        case recommendations = 1
        case trailers = 2
        case reviews = 3
        case none = 4
    }
    
    // MARK: - PUBLIC PROPERTIES
    public var didTapRecommendedMovie: ((QueryMovie) -> Void)?
    
    // MARK: - PROPERTIES
    private var selectedTab: Tabs = .none
    private var contentView: UIView!
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Paddings.hStackSpacing
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var belongsToCollectionView: CMMovieBelongsToCollectionView = {
        let view = CMMovieBelongsToCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieRecommendationsView: CMMovieRecommendationsView = {
        let view = CMMovieRecommendationsView()
        view.didTapMovie = didTapRecommendedMovie
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var trailersView: CMMovieTrailersView = {
        let view = CMMovieTrailersView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var reviewsView: CMMovieReviewsView = {
        let view = CMMovieReviewsView()
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
    
    // MARK: - Public func
    public func configureCollections(with details: MovieDetails) {
        guard let belongsToCollection = details.belongsToCollection else { return }
        hStack.insertArrangedSubview(createLabel(withText: "Collection", tag: 0), at: 0)
        belongsToCollectionView.configure(belongsToCollection: belongsToCollection)
    }
    
    public func configureRecommendations(recommendationMovies: [QueryMovie]) {
        guard !recommendationMovies.isEmpty else { return }
        hStack.addArrangedSubview(createLabel(withText: "Recommends", tag: 1))
        let filteredMovies = recommendationMovies.filter { $0.posterPath != nil }.shuffled()
        movieRecommendationsView.configure(movies: filteredMovies)
    }
    
    public func configureVideos(with videos: [DomainVideo]) {
        guard !videos.isEmpty else { return }
        hStack.addArrangedSubview(createLabel(withText: "Trailers", tag: 2))
        trailersView.configure(videos: videos)
    }
    
    public func configureReviews(with reviews: [DomainReview], reviewCount: Int) {
        let reviewsLabel = createLabel(withText: "Reviews", tag: 3)
        hStack.addArrangedSubview(reviewsLabel)
        reviewsView.configureReviews(with: reviews, reviewCount: reviewCount)
    }
    
    public func switchToFirstAvailableTab() {
        guard let firstLabel = hStack.arrangedSubviews.first as? UILabel else { return }
        guard let firstTab = Tabs(rawValue: firstLabel.tag) else { return }
        
        switch firstTab {
        case .collection: switchToView(belongsToCollectionView, tab: .collection)
        case .recommendations: switchToView(movieRecommendationsView, tab: .recommendations)
        case .trailers: switchToView(trailersView, tab: .trailers)
        case .reviews: switchToView(reviewsView, tab: .reviews)
        case .none: break
        }
    }
    
    // MARK: - Private func
    private func setupUI() {
        let divider = UIView()
        divider.backgroundColor = CMColor.cmDivider
        self.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.dividerHeight)
        }
        
        self.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(Paddings.topSpacing)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalTo(hStack.snp.bottom).offset(Paddings.topSpacing)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func createLabel(withText text: String, tag: Int) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = CMFont.font(size: .caption, fontName: .avenir)
        label.textColor = selectedTab.rawValue == tag ? CMColor.cmLabel : CMColor.cmSecondary
        label.tag = tag
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTab))
        label.addGestureRecognizer(tapGesture)
        return label
    }
    
    private func switchToView(_ view: UIView, tab: Tabs) {
        guard selectedTab != tab else { return }
        
        let direction: CGFloat = tab.rawValue > selectedTab.rawValue ? 1 : -1
        
        selectedTab = tab
        
        hStack.arrangedSubviews.forEach { subview in
            guard let label = subview as? UILabel else { return }
            let isSelected = label.tag == tab.rawValue
            let newColor = isSelected ? CMColor.cmLabel : CMColor.cmSecondary
            
            if label.textColor != newColor {
                UIView.transition(with: label, duration: Constants.aniDurations, options: .transitionCrossDissolve) {
                    label.textColor = newColor
                }
            }
        }
        
        guard contentView != view else { return }
        
        
        let oldView = contentView
        contentView = view
        contentView.alpha = 0
        contentView.transform = CGAffineTransform(translationX: direction * containerView.frame.width, y: 0)
        containerView.addSubview(contentView)
        
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        UIView.animate(withDuration: Constants.aniDurations) {
            oldView?.transform = CGAffineTransform(translationX: -direction * self.containerView.frame.width, y: 0)
            oldView?.alpha = 0
            self.contentView.transform = .identity
            self.contentView.alpha = 1
        } completion: { _ in
            oldView?.removeFromSuperview()
        }
    }
    
    // MARK: - OBJC func
    @objc private func didTapTab(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel,
              let newTab = Tabs(rawValue: label.tag),
              newTab != selectedTab else { return }

        switch newTab {
        case .collection: switchToView(belongsToCollectionView, tab: .collection)
        case .recommendations: switchToView(movieRecommendationsView, tab: .recommendations)
        case .trailers: switchToView(trailersView, tab: .trailers)
        case .reviews: switchToView(reviewsView, tab: .reviews)
        case .none: break
        }
    }
}
