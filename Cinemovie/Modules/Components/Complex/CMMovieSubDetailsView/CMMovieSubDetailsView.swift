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
    }
    
    // MARK: - PUBLIC PROPERTIES
    public var didTapRecommendedMovie: ((QueryMovie) -> Void)?
    
    // MARK: - PROPERTIES
    private var selectedTab: Tabs = .recommendations
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
        if let belongsToCollection = details.belongsToCollection{
            selectedTab = .collection
            hStack.insertArrangedSubview(createLabel(withText: "Collection", tag: 0), at: 0)
            belongsToCollectionView.configure(belongsToCollection: belongsToCollection)
            switchToView(belongsToCollectionView)
        } else {
            selectedTab = .recommendations
            switchToView(movieRecommendationsView)
        }
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
    
    private func switchToView(_ view: UIView) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print(type(of: view))
            if self.contentView == view { return }
            
            self.contentView?.removeFromSuperview()

            self.contentView = view
            self.contentView.translatesAutoresizingMaskIntoConstraints = false
            
            UIView.transition(with: containerView, duration: Constants.aniDurations, options: .showHideTransitionViews) {
                self.containerView.addSubview(self.contentView)
            }

            self.contentView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }

            UIView.animate(withDuration: Constants.aniDurations) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - OBJC func
    @objc private func didTapTab(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel, label.tag != selectedTab.rawValue else { return }

        for case let lbl as UILabel in hStack.arrangedSubviews {
            UIView.transition(with: lbl, duration: Constants.aniDurations, options: .transitionCrossDissolve) {
                lbl.textColor = CMColor.cmSecondary
            }
        }
        selectedTab = Tabs(rawValue: label.tag) ?? .recommendations
        UIView.transition(with: label, duration: Constants.aniDurations, options: .transitionCrossDissolve) {
            label.textColor = CMColor.cmLabel
        }

        switch selectedTab {
        case .collection: switchToView(belongsToCollectionView)
        case .recommendations: switchToView(movieRecommendationsView)
        case .trailers: switchToView(trailersView)
        case .reviews: switchToView(reviewsView)
        }

    }
}
