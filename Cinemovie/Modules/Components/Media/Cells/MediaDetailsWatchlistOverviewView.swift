//
//  CMMovieAddToWatchlistAndOverviewCVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.03.2025.
//

import UIKit
import SnapKit

struct MediaDetailsWatchlistOverviewViewModel: MediaDetailsCellViewModel {
    let identifier: String = "MediaDetailsWatchlistOverviewView"
    let movieOverview: String
    let cellHeight: CGFloat
    
    init(movieOverview: String) {
        self.movieOverview = movieOverview
        self.cellHeight = Self.calculateCellHeight(for: movieOverview)
    }
    
    private static func calculateCellHeight(for overview: String) -> CGFloat {
        guard !overview.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return 40.0
        }
        let width = UIConstants.screenWidth - 20
        let font = CMFont.font(size: .footnote, fontName: .avenirDemiBold)
        let bounding = NSString(string: overview).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return ceil(bounding.height) + 50
    }
}

final class MediaDetailsWatchlistOverviewView: UICollectionViewCell {
    
    // MARK: - STATIC
    static let identifier = "MediaDetailsWatchlistOverviewView"
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let imageName: String = "plus"
        static let buttonHeight: CGFloat = 40
        static let buttonCornerRadius: CGFloat = 15
        static let buttonName = "Watchlist"
        static let spacing: CGFloat = 10
    }
    
    // MARK: - PROPERTIES
    private let addToWatchlistButton: CMButton = {
        let vm = CMButtonViewModel(
            text: Constants.buttonName, foreColor: .cmDivider,
            font: CMFont.font(size: .body, fontName: .avenirBold), image: UIImage(systemName: Constants.imageName),
            backColor: .cmLabel, cornerRadius: Constants.buttonCornerRadius
        )
        let button = CMButton(viewModel: vm)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = CMFont.font(size: .footnote, fontName: .avenirDemiBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [addToWatchlistButton])
        stack.axis = .vertical
        stack.spacing = Constants.spacing
        stack.alignment = .fill
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
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
    public func configure(viewModel: MediaDetailsWatchlistOverviewViewModel) {
        guard !viewModel.movieOverview.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        vStack.removeArrangedSubview(movieOverviewLabel)
        movieOverviewLabel.text = viewModel.movieOverview
        vStack.addArrangedSubview(movieOverviewLabel)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addToWatchlistButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(Constants.buttonHeight)
        }
    }
}
