//
//  CMMovieTitleAndOverviewCVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.03.2025.
//

import UIKit
import SnapKit

struct TitleAndTaglineCellViewModel: CellViewModel, Hashable {
    let id: String = UUID().uuidString
    let cellIdentifier: String = "TitleAndTaglineCell"
    
    let movieName: String
    let movieTagline: String
    static let estimatedCellHeight: CGFloat = 70.0
    
    init(movieName: String, movieTagline: String) {
        self.movieName = movieName
        self.movieTagline = CMTextFormatter.formatToCleanString(movieTagline)
    }
}

final class TitleAndTaglineCell: UICollectionViewCell, ReusableCell {
    typealias ViewModel = TitleAndTaglineCellViewModel
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let cinemovieLogoSize: CGFloat = 25
        static let spacer: CGFloat = 5
        static let biggerSpacing: CGFloat = 10
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
        let stack = UIStackView(arrangedSubviews: [movieNameLabel])
        stack.axis = .vertical
        stack.spacing = Constants.spacer
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
    
    // MARK: - PUBLIC FUNC
    public func configure(with viewModel: ViewModel) {
        movieNameLabel.text = viewModel.movieName
        guard !viewModel.movieTagline.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        vStack.removeArrangedSubview(movieTaglineLabel)
        movieTaglineLabel.text = viewModel.movieTagline
        vStack.addArrangedSubview(movieTaglineLabel)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        cinemovieLogoImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.cinemovieLogoSize)
        }
        
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.top.equalTo(hStack.snp.bottom).offset(Constants.spacer)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
