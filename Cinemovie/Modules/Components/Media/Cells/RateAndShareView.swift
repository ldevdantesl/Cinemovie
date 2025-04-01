//
//  MovieDetailsRateAndShareView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.03.2025.
//

import UIKit
import SnapKit

final class RateAndShareCellViewModel: CellViewModelBaseClass {
    let didTapShareButton: (() -> Void)?
    let didTapRateButton: (() -> Void)?
    static let cellHeight = 25.0
    
    init(didTapShareButton: (() -> Void)?, didTapRateButton: (() -> Void)?) {
        self.didTapShareButton = didTapShareButton
        self.didTapRateButton = didTapRateButton
        super.init(cellIdentifier: "RateAndShareCell")
    }
}

final class RateAndShareCell: UICollectionViewCell, ReusableCell {
    typealias ViewModel = RateAndShareCellViewModel
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let rateimageSize = 25.0
        static let shareImageSize = 20.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: ViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var rateImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageNames.like.rawValue)
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRate)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var shareImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageNames.share.rawValue)
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapShare)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    public func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(rateImageView)
        rateImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(Constants.rateimageSize)
        }
        
        addSubview(shareImageView)
        shareImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(Constants.shareImageSize)
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapShare() {
        viewModel?.didTapShareButton?()
    }
    
    @objc private func didTapRate() {
        viewModel?.didTapRateButton?()
    }
}
