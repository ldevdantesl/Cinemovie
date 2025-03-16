//
//  CMProductionCompaniesView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 28.02.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class CMProductionInfoView: UIView {
    
    // MARK: - CONSTANTS
    fileprivate enum Paddings {
        static let vSpacing: CGFloat = 10
        static let hSpacing: CGFloat = 10
    }
    
    fileprivate enum Constants {
        static let hstackSpacing: CGFloat = 8
        static let productionCompaniesPrefix: Int = 2
        
        static let imageViewImageName: String = "building.columns"
        static let imageViewImageWidth: CGFloat = 100
        static let imageViewImageHeight: CGFloat = 40
    }
    
    private let companiesStack: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.distribution = .fill
        hstack.alignment = .leading
        hstack.translatesAutoresizingMaskIntoConstraints = false
        return hstack
    }()
    
    private let countriesStack: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.distribution = .fill
        hstack.alignment = .leading
        hstack.translatesAutoresizingMaskIntoConstraints = false
        return hstack
    }()
    
    // MARK: - PROPERTIES
    private let productionCompaniesLabel: UILabel = {
        let label = UILabel()
        label.text = "Companies: "
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .caption, fontName: .avenirBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productionCountriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Countries: "
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .caption, fontName: .avenirBold)
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
    
    // MARK: - PUBLIC METHODS
    public func configure(companies: [ProductionCompany], countries: [ProductionCountry]) {
        guard !companies.isEmpty else { return }
        
        companies.map { $0.name }.prefix(2).forEach {
            guard let name = $0 else { return }
            let label = UILabel()
            label.text = "\(name), "
            label.textColor = CMColor.cmSecondary
            label.font = CMFont.font(size: .tiny, fontName: .avenir)
            companiesStack.addArrangedSubview(label)
        }
        
        countries.map { $0.name }.prefix(2).forEach {
            let label = UILabel()
            label.text = "\($0), "
            label.textColor = CMColor.cmSecondary
            label.font = CMFont.font(size: .tiny, fontName: .avenir)
            countriesStack.addArrangedSubview(label)
        }
        
        self.layoutIfNeeded()
    }
    
    // MARK: - PRIVATE METHODS
    private func setupUI() {
        addSubview(productionCountriesLabel)
        productionCountriesLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        addSubview(countriesStack)
        countriesStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(productionCountriesLabel.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
        }
        
        addSubview(productionCompaniesLabel)
        productionCompaniesLabel.snp.makeConstraints {
            $0.top.equalTo(productionCountriesLabel.snp.bottom).offset(Paddings.vSpacing)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        addSubview(companiesStack)
        companiesStack.snp.makeConstraints {
            $0.top.equalTo(productionCompaniesLabel.snp.top)
            $0.leading.equalTo(productionCompaniesLabel.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
