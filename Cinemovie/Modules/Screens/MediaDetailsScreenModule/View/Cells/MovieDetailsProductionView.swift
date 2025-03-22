//
//  MovieDetailsProductionView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.03.2025.
//

import UIKit
import SnapKit

struct MovieDetailsProductionViewModel: MovieDetailsCellViewModel {
    let identifier: String = "MovieDetailsProductionView"
    
    let companies: [ProductionCompany]
    let countries: [ProductionCountry]
}

final class MovieDetailsProductionView: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacer = 5.0
        static let biggerSpacer = 10.0
    }
    
    // MARK: - STATIC
    static let identifier = "MovieDetailsProductionView"
    
    // MARK: - PROPERTIES
    private let companiesLabel: UILabel = {
        let label = UILabel()
        label.text = "Companies: "
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .caption, fontName: .avenirBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let companiesListLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .footnote, fontName: .avenirDemiBold)
        label.textAlignment = .right
        label.text = "Unknown"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Countries: "
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .caption, fontName: .avenirBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countriesListLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .footnote, fontName: .avenirDemiBold)
        label.textAlignment = .right
        label.text = "Unknown"
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
    public func configure(viewModel: MovieDetailsProductionViewModel) {
        let countriesStr = viewModel.countries.prefix(2).map(\.name).joined(separator: ", ")
        let companiesStr = viewModel.companies.filter { $0.name != nil }.prefix(2).map(\.name!).joined(separator: ", ")
        
        guard !countriesStr.isEmpty, !companiesStr.isEmpty else { return }
        countriesListLabel.text = countriesStr
        companiesListLabel.text = companiesStr
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(countriesLabel)
        countriesLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        contentView.addSubview(countriesListLabel)
        countriesListLabel.snp.makeConstraints {
            $0.leading.equalTo(countriesLabel.snp.trailing).offset(Constants.spacer)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(countriesLabel.snp.centerY)
        }
        
        contentView.addSubview(companiesLabel)
        companiesLabel.snp.makeConstraints {
            $0.top.equalTo(countriesLabel.snp.bottom).offset(Constants.biggerSpacer)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(companiesListLabel)
        companiesListLabel.snp.makeConstraints {
            $0.leading.equalTo(companiesLabel.snp.trailing).offset(Constants.spacer)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(companiesLabel.snp.centerY)
        }
        
        companiesLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        countriesLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
