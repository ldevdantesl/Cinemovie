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

final class TrendingPersonCell: ReusableCellBaseClass {
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
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var personAvaImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = CMColor.cmSecondaryBackground
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPersonImageView)))
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
        self.personAvaImageView.layer.cornerRadius = self.personAvaImageView.frame.width / 2
        self.personAvaImageView.layer.borderWidth = Constants.imageBorderWidth
        self.personAvaImageView.layer.borderColor = CMColor.cmLabel.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.personAvaImageView.image = nil
        self.personAvaImageView.contentMode = .scaleAspectFill
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: TrendingPersonCellViewModel) {
        self.viewModel = viewModel
        
        guard let imageURL = URLHelper.getImageURL(with: viewModel.person.profilePath, size: .w500) else {
            personAvaImageView.image = UIImage(systemName: Constants.imageDefaultName)
            personAvaImageView.preferredSymbolConfiguration = .init(pointSize: Constants.imageDefaultPointSize, weight: .bold)
            personAvaImageView.contentMode = .center
            return
        }
        
        self.loadingIndicator.startAnimating()
        personAvaImageView.sd_setImage(with: imageURL) { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        personAvaImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(Constants.loadingIndicatorSize)
        }
        
        addSubview(personAvaImageView)
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
