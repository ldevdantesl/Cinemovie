//
//  WatchlistScreenHeaderView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.05.2025.
//

import UIKit
import SnapKit

struct WatchlistScreenHeaderViewModel {
    let didTapAddListAction: (() -> Void)?
}

final class WatchlistScreenHeaderView: UIView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let aniDuration = 0.25
        static let addListButtonName = "plus"
        static let addListButtonSize = 35.0
        static let biggerSpacing = 10.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: WatchlistScreenHeaderViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let myListsLabel: UILabel = {
        let label = UILabel()
        label.text = "My Lists"
        label.font = CMFont.font(size: .subtitle, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addListButton: CMCircularButton = {
        let button = CMCircularButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: WatchlistScreenHeaderViewModel) {
        self.viewModel = viewModel
        
        let vm = CMCircularButtonViewModel(
            systemName: Constants.addListButtonName, backColor: .clear,
            foreColor: CMColor.cmAccent, imageSizeByRespectingOuterCircle: 0.8,
            didTapAction: viewModel.didTapAddListAction
        )
        addListButton.configure(viewModel: vm)
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
        addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(myListsLabel)
        myListsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIConstants.topInset)
            $0.leading.equalToSuperview().offset(Constants.biggerSpacing)
        }
        
        addSubview(addListButton)
        addListButton.snp.makeConstraints {
            $0.centerY.equalTo(myListsLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-Constants.biggerSpacing)
            $0.size.equalTo(Constants.addListButtonSize)
        }
    }
}
