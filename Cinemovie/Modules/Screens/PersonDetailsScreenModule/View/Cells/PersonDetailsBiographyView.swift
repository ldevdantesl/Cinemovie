//
//  PersonDetailsBiographyView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 21.03.2025.
//

import UIKit
import SnapKit

struct PersonDetailsBiographyViewModel: PersonDetailsCellViewModel {
    let identifier: String = "PersonDetailsBiographyView"
    let biography: String
    let cellHeight: CGFloat
    
    init(biography: String) {
        self.biography = biography
        self.cellHeight = Self.calculateHeight(for: biography)
    }
    
    private static func calculateHeight(for text: String) -> CGFloat {
        let width = UIScreen.main.bounds.width - 20
        let font = CMFont.font(size: .caption, fontName: .avenirDemiBold)
        let bounding = NSString(string: text).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return ceil(bounding.height) + 20
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
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(biographyLabel)
        biographyLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
