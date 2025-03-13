//
//  CMMovieSubDetailsView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.03.2025.
//

import UIKit
import SnapKit

final class CMMovieSubDetailsView: UIView {
    
    fileprivate enum Paddings {
        
    }
    
    fileprivate enum Constants {
        
    }
    
    fileprivate enum Tabs: Int {
        case collection = 0
        case recommendations = 1
        case trailers = 2
        case reviews = 3
    }
    
    private var selectedTab: Tabs = .recommendations
    private var contentView: UIView!
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var belongsToCollectionView: CMMovieBelongsToCollectionView = {
        let view = CMMovieBelongsToCollectionView()
        view.backgroundColor = .cmAccent
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieRecommendationsView: CMMovieRecommendationsView = {
        let view = CMMovieRecommendationsView()
        view.backgroundColor = .cmError
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var trailersView: CMMovieTrailersView = {
        let view = CMMovieTrailersView()
        view.backgroundColor = .cmSuccess
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
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public func
    public func configure(details: MovieDetails) {
        if let belongsToCollection = details.belongsToCollection {
            selectedTab = .collection
            let label = createLabel(withText: "Collection", tag: 0)
            hStack.addArrangedSubview(label)
            belongsToCollectionView.configure(belongsToCollection: belongsToCollection)
            contentView = belongsToCollectionView
            
            let recommendationsLabel = createLabel(withText: "Recommends", tag: 1)
            hStack.addArrangedSubview(recommendationsLabel)
        } else {
            let recommendationsLabel = createLabel(withText: "Recommends", tag: 1)
            hStack.addArrangedSubview(recommendationsLabel)
            contentView = movieRecommendationsView
        }
        
        let trailersLabel = createLabel(withText: "Trailers", tag: 2)
        hStack.addArrangedSubview(trailersLabel)
        
        let reviews = createLabel(withText: "Reviews", tag: 3)
        hStack.addArrangedSubview(reviews)

        setupUI()
    }
    
    // MARK: - Private func
    private func setupUI() {
        let divider = UIView()
        divider.backgroundColor = CMColor.cmDivider
        self.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        self.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }

        self.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(hStack.snp.bottom).offset(10)
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        label.addGestureRecognizer(tapGesture)
        return label
    }
    
    // MARK: - OBJC func
    @objc private func labelTapped(_ sender: UITapGestureRecognizer) {
        if let label = sender.view as? UILabel, label.tag != selectedTab.rawValue {
            for case let lbl as UILabel in hStack.arrangedSubviews {
                UIView.transition(with: lbl, duration: 0.3, options: .transitionCrossDissolve) {
                    lbl.textColor = CMColor.cmSecondary
                }
            }
            
            selectedTab = Tabs(rawValue: label.tag) ?? .recommendations
            UIView.transition(with: label, duration: 0.3, options: .transitionCrossDissolve) {
                label.textColor = CMColor.cmLabel
            }
            
            // Update the contentView reference
            let newContentView: UIView
            switch selectedTab {
            case .collection: newContentView = belongsToCollectionView
            case .recommendations: newContentView = movieRecommendationsView
            case .trailers: newContentView = trailersView
            case .reviews: newContentView = reviewsView
            }
            
            // Only update constraints if contentView is actually changing
            if newContentView != contentView {
                contentView.removeFromSuperview()
                contentView = newContentView
                self.addSubview(contentView)

                contentView.snp.makeConstraints {
                    $0.top.equalTo(hStack.snp.bottom).offset(10)
                    $0.leading.trailing.equalToSuperview()
                    $0.bottom.equalToSuperview()
                }
            }

            self.bringSubviewToFront(contentView)
            self.layoutIfNeeded()
        }
    }
}
