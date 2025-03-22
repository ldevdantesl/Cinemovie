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
    let firstButton: CMCircularButton
    let secondButton: CMCircularButton?
    
    init(headerTitle: String, firstButton: CMCircularButton, secondButton: CMCircularButton? = nil) {
        self.headerTitle = headerTitle
        self.firstButton = firstButton
        self.secondButton = secondButton
    }
}

final class HomeScreenHeaderView: UIView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 5.0
        static let biggerSpacing = 10.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: HomeScreenHeaderViewModel
    
    // MARK: - VIEW PROPERTIES
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.headerTitle
        label.font = CMFont.font(size: .title, weight: .bold)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerLabel, UIView(), viewModel.firstButton])
        stack.axis = .horizontal
        stack.spacing = Constants.biggerSpacing
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        if let secondButton = viewModel.secondButton { stack.addArrangedSubview(secondButton) }
        return stack
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
        
        hStack.arrangedSubviews.forEach {
            hStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        hStack.addArrangedSubview(headerLabel)
        hStack.addArrangedSubview(UIView())
        hStack.addArrangedSubview(viewModel.firstButton)
        if let secondButton = viewModel.secondButton { hStack.addArrangedSubview(secondButton) }
    }
    
    public func addShadowToHeader() {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 1
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.layer.shadowRadius = 2
            self.layer.zPosition = 1
            
            let shadowHeight: CGFloat = 4
            let shadowRect = CGRect(x: 0, y: self.bounds.height - shadowHeight, width: self.bounds.width, height: shadowHeight)
            self.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        }
    }

    public func removeShadowFromHeader() {
        UIView.transition(with: self, duration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.layer.shadowOpacity = 0
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        self.backgroundColor = CMColor.cmBackground
        
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
