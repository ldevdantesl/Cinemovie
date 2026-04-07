//
//  TrendingPeopleItemCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.04.2025.
//

import UIKit
import SDWebImage
import SnapKit

final class TrendingPersonCellViewModel: CellViewModelBaseClass {
    let person: Person
    let didTapAction: ((Person) -> Void)?
    
    init(person: Person, didTapAction: ((Person) -> Void)?) {
        self.person = person
        self.didTapAction = didTapAction
        super.init(cellIdentifier: "TrendingPersonCell")
    }
}

final class TrendingPersonCell: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let imageBorderWidth = 0.5
        static let imageDefaultName = "person"
        static let imageDefaultPointSize = 15.0
        
        static let loadingIndicatorSize = 10.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: TrendingPersonCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var personAvaImageView: AsyncImageView = {
        let view = AsyncImageView()
        view.setAction(target: self, action: #selector(didTapPersonImageView))
        view.setBorder(width: Constants.imageBorderWidth, borderColor: CMColor.cmLabel)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.personAvaImageView.makeCircular()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.personAvaImageView.image = nil
        self.personAvaImageView.contentMode = .scaleAspectFill
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: TrendingPersonCellViewModel) {
        self.viewModel = viewModel
        let imagePath = viewModel.person.profilePath
        personAvaImageView.setAsyncImage(
            path: imagePath, size: .w500,
            notFoundImageSystemName: Constants.imageDefaultName,
            notFoundPointSize: Constants.imageDefaultPointSize
        )
        self.layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(personAvaImageView)
        personAvaImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapPersonImageView() {
        guard let viewModel = viewModel else { return }
        viewModel.didTapAction?(viewModel.person)
    }
}
