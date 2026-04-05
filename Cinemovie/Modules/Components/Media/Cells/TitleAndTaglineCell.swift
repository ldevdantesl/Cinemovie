//
//  CMMovieTitleAndOverviewCVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.03.2025.
//

import UIKit
import SnapKit

final class TitleAndTaglineCellViewModel: CellViewModelBaseClass {
    let mediaName: String
    let mediaTagline: String?
    
    init(mediaName: String, mediaTagline: String?) {
        self.mediaName = mediaName
        self.mediaTagline = CMTextFormatter.formatToCleanString(mediaTagline)
        super.init(cellIdentifier: "TitleAndTaglineCell")
    }
}

final class TitleAndTaglineCell: UICollectionViewCell {
    typealias ViewModel = TitleAndTaglineCellViewModel
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let cinemovieLogoSize: CGFloat = 25
        static let spacer: CGFloat = 5
        static let biggerSpacing: CGFloat = 10
        static let selfCornerRadius = 15.0
    }
    
    // MARK: - PROPERTIES
    private let cinemovieLogoImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: ImageNames.logoAlt.rawValue))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let cinemovieLabel: UILabel = {
        let label = UILabel()
        label.text = "Cinemovie"
        label.font = CMFont.font(size: .caption, fontName: .avenirBold)
        label.textColor = CMColor.cmSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [cinemovieLogoImageView, cinemovieLabel, UIView()])
        hStack.axis = .horizontal
        hStack.spacing = Constants.spacer
        hStack.alignment = .bottom
        hStack.distribution = .fill
        return hStack
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenirDemiBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieTaglineLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .footnote, fontName: .avenirDemiBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hStack, movieNameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        return stack
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = Constants.selfCornerRadius
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(with viewModel: ViewModel) {
        movieNameLabel.text = viewModel.mediaName
        guard let tagline = viewModel.mediaTagline, !tagline.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        vStack.removeArrangedSubview(movieTaglineLabel)
        movieTaglineLabel.text = tagline
        vStack.addArrangedSubview(movieTaglineLabel)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.backgroundColor = CMColor.cmBackground
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.biggerSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.biggerSpacing)
            $0.bottom.equalToSuperview()
        }
        
        cinemovieLogoImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.cinemovieLogoSize)
        }
    }
}
