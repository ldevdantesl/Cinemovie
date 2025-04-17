//
//  CMHeaderView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import SnapKit
import UIKit

struct HomeScreenHeaderViewModel {
    let headerTitle: String
    let didTapSearchButton: (() -> Void)?
    let didTapMovieButton: (() -> Void)?
    let didTapTVSeriesButton: (() -> Void)?
    
    init(headerTitle: String, didTapSearchButton: (() -> Void)? = nil, didTapMovieButton: (() -> Void)? = nil, didTapTVSeriesButton: (() -> Void)? = nil) {
        self.headerTitle = headerTitle
        self.didTapSearchButton = didTapSearchButton
        self.didTapTVSeriesButton = didTapTVSeriesButton
        self.didTapMovieButton = didTapMovieButton
    }
}

final class HomeScreenHeaderView: UIView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 5.0
        static let biggerSpacing = 10.0
        static let searchButtonSystemName = "magnifyingglass"
        static let searchButtonSize = 25.0
        static let buttonsCornerRadius = 15.0
        static let buttonsBorderWidth = 1.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: HomeScreenHeaderViewModel
    
    // MARK: - VIEW PROPERTIES
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.headerTitle
        label.font = CMFont.font(size: .title, fontName: .avenirDemiBold)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchButtonImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: Constants.searchButtonSystemName)
        view.tintColor = CMColor.cmAccent
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mediaButton: CMButton = {
        let vm = CMButtonViewModel(
            text: "Movies", foreColor: .cmLabel,
            font: CMFont.font(size: .footnote, fontName: .avenirBold), image: nil,
            backColor: CMColor.cmBackground, cornerRadius: Constants.buttonsCornerRadius,
            borderColor: CMColor.cmLabel, borderWidth: Constants.buttonsBorderWidth,
            didTapAction: didTapMediaButton
        )
        let button = CMButton(viewModel: vm)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - LIFECYCLE
    init(viewModel: HomeScreenHeaderViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: HomeScreenHeaderViewModel) {
        self.viewModel = viewModel
        headerLabel.text = viewModel.headerTitle
    }
    
    public func addBlur() {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            self.blurView.isHidden = false
        }
    }
    
    public func removeBlur() {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            self.blurView.isHidden = true
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        self.backgroundColor = .clear
        addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        addSubview(searchButtonImageView)
        searchButtonImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(Constants.searchButtonSize)
        }
        
        addSubview(mediaButton)
        mediaButton.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(Constants.spacing)
            $0.leading.equalToSuperview()
        }
    }
    
    private func didTapMediaButton() {
    
    }
}
