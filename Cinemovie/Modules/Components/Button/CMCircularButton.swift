//
//  CMCircularButton.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import UIKit
import SnapKit

struct CMCircularButtonViewModel {
    let systemName: String
    let backColor: UIColor
    let foreColor: UIColor
    let didTapAction: (() -> Void)?
    let imageSizeByRespectingOuterCircle: CGFloat?
    
    init(
        systemName: String,
        backColor: UIColor = .cmSecondary,
        foreColor: UIColor = .cmLabel,
        imageSizeByRespectingOuterCircle: CGFloat? = nil,
        didTapAction: (() -> Void)? = nil
    ) {
        self.systemName = systemName
        self.backColor = backColor
        self.foreColor = foreColor
        self.imageSizeByRespectingOuterCircle = min(0.99, imageSizeByRespectingOuterCircle ?? 0.6)
        self.didTapAction = didTapAction
    }
}

final class CMCircularButton: UIView {
    
    // MARK: - PROPERTIES
    private var viewModel: CMCircularButtonViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
    }
    
    convenience init(viewModel: CMCircularButtonViewModel) {
        self.init(frame: .zero)
        self.viewModel = viewModel
        self.configure(viewModel: viewModel)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 2
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: CMCircularButtonViewModel) {
        self.viewModel = viewModel
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.backgroundColor = viewModel.backColor
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapButton)))
        self.imageView.image = UIImage(systemName: viewModel.systemName)
        self.imageView.tintColor = viewModel.foreColor
        self.imageView.snp.removeConstraints()
        self.setupConstraints()
    }
    
    public func reconfigure(newVM viewModel: CMCircularButtonViewModel, transitionDuration: TimeInterval = 0.25, transitionOptions: UIView.AnimationOptions = .transitionCrossDissolve) {
        self.viewModel = viewModel
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.backgroundColor = viewModel.backColor
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapButton)))
        self.imageView.tintColor = viewModel.foreColor
        
        UIView.transition(with: imageView, duration: transitionDuration, options: transitionOptions) { [weak self] in
            guard let self = self else { return }
            self.imageView.image = UIImage(systemName: viewModel.systemName)
        }
        
        self.imageView.snp.removeConstraints()
        self.setupConstraints()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupImage() {
        addSubview(imageView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview().multipliedBy(viewModel?.imageSizeByRespectingOuterCircle ?? 0.6)
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapButton() {
        guard let viewModel = viewModel else { return }
        viewModel.didTapAction?()
    }
}
