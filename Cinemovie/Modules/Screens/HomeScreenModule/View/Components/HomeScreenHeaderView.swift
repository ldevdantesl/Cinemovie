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
    
    init(headerTitle: String, didTapSearchButton: (() -> Void)? = nil) {
        self.headerTitle = headerTitle
        self.didTapSearchButton = didTapSearchButton
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
    
    private let tvShowButton: CMButton = {
        let vm = CMButtonViewModel(
            text: "TV Show", foreColor: .cmLabel,
            font: CMFont.font(size: .footnote, fontName: .avenirBold), image: nil,
            backColor: CMColor.cmBackground, cornerRadius: Constants.buttonsCornerRadius,
            borderColor: CMColor.cmLabel, borderWidth: Constants.buttonsBorderWidth
        )
        let button = CMButton(viewModel: vm)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let moviesButton: CMButton = {
        let vm = CMButtonViewModel(
            text: "Movies", foreColor: .cmLabel,
            font: CMFont.font(size: .footnote, fontName: .avenirBold), image: nil,
            backColor: CMColor.cmBackground, cornerRadius: Constants.buttonsCornerRadius,
            borderColor: CMColor.cmLabel, borderWidth: Constants.buttonsBorderWidth
        )
        let button = CMButton(viewModel: vm)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var headerStack: UIStackView = {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let stack = UIStackView(arrangedSubviews: [headerLabel, spacer, searchButtonImageView])
        stack.axis = .horizontal
        stack.spacing = Constants.biggerSpacing
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tvShowButton, moviesButton, UIView()])
        stack.axis = .horizontal
        stack.spacing = Constants.biggerSpacing
        stack.alignment = .leading
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var vStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [headerStack, buttonsStack])
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.spacing = Constants.spacing
        vStack.alignment = .fill
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.layoutMargins = UIEdgeInsets(top: Constants.biggerSpacing, left: Constants.biggerSpacing, bottom: Constants.biggerSpacing, right: Constants.biggerSpacing)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
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
    
    public func addBlurToHeader() {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            self.blurView.isHidden = false
        }
    }
    
    public func removeBlurFromHeader() {
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
        
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.top.lessThanOrEqualToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        searchButtonImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.searchButtonSize)
        }
        
        tvShowButton.setContentHuggingPriority(.required, for: .horizontal)
        moviesButton.setContentHuggingPriority(.required, for: .horizontal)
    }
}
