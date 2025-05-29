//
//  CMHeaderView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import SnapKit
import UIKit
import SDWebImage

struct DiscoverScreenHeaderViewModel {
    let didTapSearchButton: (() -> Void)?
    let didTapMediaButton: ((_ mediaType: MediaTypes) -> Void)?
}

final class DiscoverScreenHeaderView: UIView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let aniDuration = 0.25
        static let spacing = 5.0
        static let biggerSpacing = 10.0
        static let searchButtonSystemName = "magnifyingglass"
        static let movieButtonSystemName = "film.stack.fill"
        static let seriesButtonSystemName = "tv.and.hifispeaker.fill"
        static let xmarkButtonName = "xmark"
        static let buttonSize = 40.0
        static let buttonsCornerRadius = 15.0
        static let buttonsBorderWidth = 1.0
        
        static let farOffset = 100.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: DiscoverScreenHeaderViewModel
    private var isShowingMovie: Bool = true
    private var changeWorkItem: DispatchWorkItem?
    
    // MARK: - VIEW PROPERTIES
    private lazy var searchButton: CMCircularButton = {
        let vm = CMCircularButtonViewModel(
            systemName: Constants.searchButtonSystemName, backColor: .cmSecondaryBackground,
            foreColor: CMColor.cmAccent, didTapAction: viewModel.didTapSearchButton
        )
        let button = CMCircularButton(viewModel: vm)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var mediaButton: CMButton = {
        let vm = CMButtonViewModel(
            font: CMFont.font(size: .body, fontName: .avenirBold),
            image: UIImage(systemName: "film.stack.fill"),
            backColor: .black, didTapAction: self.didTapMediaButton
        )
        let button = CMButton(viewModel: vm)
        button.setCornerRadius(Constants.buttonsCornerRadius)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - LIFECYCLE
    init(viewModel: DiscoverScreenHeaderViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        self.backgroundColor = .clear
        
        addSubview(mediaButton)
        mediaButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIConstants.topInset - 10)
            $0.leading.equalToSuperview().offset(Constants.biggerSpacing)
        }
        
        addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIConstants.topInset - 10)
            $0.trailing.equalToSuperview().offset(-Constants.biggerSpacing)
            $0.size.equalTo(Constants.buttonSize)
        }
    }
    
    private func didTapMediaButton() {
        changeWorkItem?.cancel()
        isShowingMovie.toggle()
        let newType: MediaTypes = isShowingMovie ? .movie : .tvShow
        let vm = CMButtonViewModel(
            text: newType == .movie ? "Movies" : "Series",
            font: CMFont.font(size: .body, fontName: .avenirBold),
            image: UIImage(systemName: newType == .movie ? "film.stack.fill" : "tv.fill"),
            backColor: .black, didTapAction: self.didTapMediaButton
        )
        self.mediaButton.reconfigure(viewModel: vm)
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let newVm = CMButtonViewModel(
                font: CMFont.font(size: .body, fontName: .avenirBold),
                image: UIImage(systemName: newType == .movie ? "film.stack.fill" : "tv.fill"),
                backColor: .black, didTapAction: self.didTapMediaButton
            )
            self.mediaButton.reconfigure(viewModel: newVm)
        }
        self.changeWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: workItem)
        viewModel.didTapMediaButton?(newType)
    }
}
