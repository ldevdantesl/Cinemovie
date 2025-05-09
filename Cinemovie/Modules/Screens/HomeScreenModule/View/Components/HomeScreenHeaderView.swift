//
//  CMHeaderView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import SnapKit
import UIKit
import SDWebImage

struct HomeScreenHeaderViewModel {
    let headerTitle: String
    let didStartSearching: ((String) -> Void)?
    let didFinishSearching: (() -> Void)?
    let didTapMediaButton: ((_ mediaType: MediaTypes) -> Void)?
}

final class HomeScreenHeaderView: UIView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let aniDuration = 0.25
        static let spacing = 5.0
        static let biggerSpacing = 10.0
        static let searchButtonSystemName = "magnifyingglass"
        static let xmarkButtonName = "xmark"
        static let buttonSize = 35.0
        static let buttonsCornerRadius = 15.0
        static let buttonsBorderWidth = 1.0
        
        static let farOffset = 100.0
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
    
    private lazy var searchButton: CMCircularButton = {
        let vm = CMCircularButtonViewModel(
            systemName: Constants.searchButtonSystemName, backColor: .clear,
            foreColor: CMColor.cmAccent, imageSizeByRespectingOuterCircle: 0.8, didTapAction: self.didTapSearchButton
        )
        let button = CMCircularButton(viewModel: vm)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchBarView: CMTextField = {
        let vm = CMTextFieldViewModel(
            backgroundColor: .cmSecondaryBackground, textColor: .cmLabel,
            placeholder: "Star wars...", font: CMFont.font(size: .body, fontName: .avenirBold)
        )
        let field = CMTextField(viewModel: vm)
        field.delegate = self
        field.isHidden = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var mediaButton: CMButton = {
        let vm = CMButtonViewModel(
            text: "Movies", foreColor: .cmLabel,
            font: CMFont.font(size: .footnote, fontName: .avenirBold), image: nil,
            backColor: CMColor.cmBackground, cornerRadius: Constants.buttonsCornerRadius,
            borderColor: CMColor.cmLabel, borderWidth: Constants.buttonsBorderWidth,
            didTapAction: self.didTapMediaButton
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
        UIView.transition(with: self, duration: Constants.aniDuration, options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            self.blurView.isHidden = false
        }
    }
    
    public func removeBlur() {
        UIView.transition(with: self, duration: Constants.aniDuration, options: .transitionCrossDissolve) { [weak self] in
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
            $0.top.equalToSuperview().offset(UIConstants.topInset)
            $0.leading.equalToSuperview().offset(Constants.biggerSpacing)
        }
        
        addSubview(mediaButton)
        mediaButton.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(Constants.biggerSpacing)
            $0.bottom.equalToSuperview().offset(-Constants.biggerSpacing)
        }
        
        addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIConstants.topInset)
            $0.trailing.equalToSuperview().offset(-Constants.biggerSpacing)
            $0.size.equalTo(Constants.buttonSize)
        }
        
        addSubview(searchBarView)
        searchBarView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom)
            $0.trailing.equalTo(searchButton.snp.leading).offset(Constants.farOffset)
            $0.leading.equalTo(searchBarView.snp.trailing)
            $0.bottom.equalToSuperview().offset(-Constants.biggerSpacing)
        }
        
        mediaButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        mediaButton.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    
    private func didTapMediaButton() {
        isShowingMovie.toggle()
        let newType: MediaTypes = isShowingMovie ? .movie : .tvShow

        let vm = CMButtonViewModel(
            text: newType == .movie ? "Movies" : "TVSeries", foreColor: .cmLabel,
            font: CMFont.font(size: .footnote, fontName: .avenirBold), image: nil,
            backColor: CMColor.cmBackground, cornerRadius: Constants.buttonsCornerRadius,
            borderColor: CMColor.cmLabel, borderWidth: Constants.buttonsBorderWidth,
            didTapAction: didTapMediaButton
        )

        UIView.transition(with: mediaButton, duration: Constants.aniDuration, options: [.transitionCrossDissolve]) { [weak self] in
            self?.mediaButton.configure(viewModel: vm)
        }

        viewModel.didTapMediaButton?(newType)
    }

    private func didTapSearchButton() {
        searchBarView.isHidden = false
        headerLabel.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(UIConstants.topInset)
            $0.horizontalEdges.equalToSuperview().inset(Constants.biggerSpacing)
        }
        
        searchBarView.snp.remakeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(Constants.biggerSpacing)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-Constants.biggerSpacing)
            $0.bottom.equalToSuperview().offset(-Constants.biggerSpacing)
        }
        
        searchButton.snp.remakeConstraints {
            $0.centerY.equalTo(searchBarView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-Constants.biggerSpacing)
            $0.size.equalTo(Constants.buttonSize)
        }
        
        mediaButton.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(-Constants.farOffset)
        }
        
        let newButtonVM = CMCircularButtonViewModel(
            systemName: Constants.xmarkButtonName, backColor: CMColor.cmSecondaryBackground,
            foreColor: CMColor.cmLabel, didTapAction: self.didTapXButton
        )
        searchButton.reconfigure(newVM: newButtonVM)
        
        UIView.animate(withDuration: Constants.aniDuration) { [weak self] in
            guard let self = self else { return }
            self.headerLabel.text = "Search"
            self.layoutIfNeeded()
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.searchBarView.becomeFirstResponder()
        }
    }
    
    private func didTapXButton() {
        let vm = CMCircularButtonViewModel(
            systemName: Constants.searchButtonSystemName, backColor: .clear,
            foreColor: CMColor.cmAccent, imageSizeByRespectingOuterCircle: 0.8, didTapAction: self.didTapSearchButton
        )
        searchButton.reconfigure(newVM: vm)
        
        headerLabel.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(UIConstants.topInset)
            $0.leading.equalToSuperview().offset(Constants.biggerSpacing)
        }
        
        searchButton.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(UIConstants.topInset)
            $0.trailing.equalToSuperview().offset(-Constants.biggerSpacing)
            $0.size.equalTo(Constants.buttonSize)
        }
        
        searchBarView.snp.remakeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom)
            $0.trailing.equalTo(searchButton.snp.leading).offset(Constants.farOffset)
            $0.leading.equalTo(searchBarView.snp.trailing)
            $0.bottom.equalToSuperview().offset(-Constants.biggerSpacing)
        }
        
        mediaButton.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(Constants.biggerSpacing)
        }
        
        viewModel.didFinishSearching?()
        UIView.animate(withDuration: Constants.aniDuration) { [weak self] in
            guard let self = self else { return }
            self.headerLabel.text = "Discover"
            self.layoutIfNeeded()
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.searchBarView.isHidden = true
            self.searchBarView.text = nil
            self.searchBarView.resignFirstResponder()
        }
    }
}

extension HomeScreenHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        guard let query = currentText else { return true }
        self.viewModel.didStartSearching?(query)
        return true
    }
}
