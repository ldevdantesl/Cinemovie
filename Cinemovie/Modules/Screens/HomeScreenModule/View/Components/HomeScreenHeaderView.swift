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
    let didTapMediaButton: (_ mediaType: MediaTypes) -> Void
}

final class HomeScreenHeaderView: UIView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let aniDuration = 0.25
        static let spacing = 5.0
        static let biggerSpacing = 10.0
        static let searchButtonSystemName = "magnifyingglass"
        static let searchButtonSize = 25.0
        static let buttonsCornerRadius = 15.0
        static let buttonsBorderWidth = 1.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: HomeScreenHeaderViewModel
    private var isShowingMovie: Bool = true
    
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
        
        addSubview(mediaButton)
        mediaButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.biggerSpacing)
            $0.bottom.equalToSuperview().inset(Constants.biggerSpacing)
        }
        
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints {
            $0.bottom.equalTo(mediaButton.snp.top).offset(-Constants.spacing)
            $0.leading.equalToSuperview().offset(Constants.biggerSpacing)
        }
        
        addSubview(searchButtonImageView)
        searchButtonImageView.snp.makeConstraints {
            $0.bottom.equalTo(mediaButton.snp.top).offset(-Constants.spacing)
            $0.trailing.equalToSuperview().inset(Constants.biggerSpacing)
            $0.size.equalTo(Constants.searchButtonSize)
        }
    }
    
    private func didTapMediaButton() {
        isShowingMovie.toggle()
        let newType: MediaTypes = isShowingMovie ? .movie : .tvShow

        let vm = CMButtonViewModel(
            text: newType == .movie ? "Movies" : "TVSeries",
            foreColor: .cmLabel,
            font: CMFont.font(size: .footnote, fontName: .avenirBold),
            image: nil,
            backColor: CMColor.cmBackground,
            cornerRadius: Constants.buttonsCornerRadius,
            borderColor: CMColor.cmLabel,
            borderWidth: Constants.buttonsBorderWidth,
            didTapAction: didTapMediaButton
        )

        UIView.transition(with: mediaButton, duration: Constants.aniDuration, options: [.transitionCrossDissolve]) { [weak self] in
            self?.mediaButton.configure(viewModel: vm)
        }

        viewModel.didTapMediaButton(newType)
    }
}
