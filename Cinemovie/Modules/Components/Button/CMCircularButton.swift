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
    
    init(
        systemName: String,
        backColor: UIColor = .cmSecondary,
        foreColor: UIColor = .cmLabel,
        didTapAction: (() -> Void)? = nil
    ) {
        self.systemName = systemName
        self.backColor = backColor
        self.foreColor = foreColor
        self.didTapAction = didTapAction
    }
}

final class CMCircularButton: UIView {
    
    // MARK: - PROPERTIES
    private var viewModel: CMCircularButtonViewModel?
    
    // MARK: - VIEW PROPERTIES
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init(viewModel: CMCircularButtonViewModel) {
        self.init(frame: .zero)
        self.viewModel = viewModel
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.backgroundColor = viewModel.backColor
        imageView.image = UIImage(systemName: viewModel.systemName)
        imageView.tintColor = viewModel.foreColor
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapButton)))
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
        imageView.image = UIImage(systemName: viewModel.systemName)
        imageView.tintColor = viewModel.foreColor
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapButton)))
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapButton() {
        guard let viewModel = viewModel else { return }
        viewModel.didTapAction?()
    }
}
