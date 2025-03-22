//
//  PersonDetailsBiographyView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 21.03.2025.
//

import UIKit
import SnapKit

final class PersonDetailsBiographyViewModel: PersonDetailsCellViewModel {
    let identifier: String = "PersonDetailsBiographyView"
    let biography: String
    var cellHeight: CGFloat = 10.0
    
    init(biography: String) {
        self.biography = biography
    }
}

final class PersonDetailsBiographyView: UICollectionViewCell {
    // MARK: - STATIC
    static let identifier = "PersonDetailsBiographyView"
    
    // MARK: - PROPERTIES
    private var viewModel: PersonDetailsBiographyViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let biographyLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .caption, fontName: .avenirDemiBold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    public func configure(viewModel: PersonDetailsBiographyViewModel) {
        self.viewModel = viewModel
        self.biographyLabel.text = viewModel.biography
        
        let targetSize = CGSize(width: contentView.frame.width, height: UIView.layoutFittingCompressedSize.height)
        let height = biographyLabel.systemLayoutSizeFitting(
            targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel
        ).height
        
        viewModel.cellHeight = height
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(biographyLabel)
        biographyLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
