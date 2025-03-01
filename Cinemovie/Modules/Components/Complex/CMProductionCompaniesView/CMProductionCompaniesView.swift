//
//  CMProductionCompaniesView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 28.02.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class CMProductionCompaniesView: UIView {
    
    private var productionCompanies: [ProductionCompany] = []
    
    private let productionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Production Companies"
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .body, fontName: .avenir)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hStack: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .leading
        hStack.distribution = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false
        return hStack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC METHODS
    public func configure(companies: [ProductionCompany]) {
        guard !companies.isEmpty else { return }
        
        self.productionCompanies = companies
        
        setupUI()
    }
    
    // MARK: - PRIVATE METHODS
    private func setupUI() {
        addSubview(productionTitleLabel)
        productionTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.equalTo(productionTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        productionCompanies.prefix(2).forEach { company in
            let companyView = createCompanyView(for: company)
            hStack.addArrangedSubview(companyView)
            hStack.addArrangedSubview(UIView())
        }
        
        hStack.layoutIfNeeded()
    }
    
    private func createCompanyView(for company: ProductionCompany) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 10
        container.alignment = .center
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "building.columns")
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { $0.width.equalTo(100); $0.height.equalTo(40) }
        
        imageView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
        
        if let url = URLHelper.getImageURL(with: company.logoPath, size: .original) {
            activityIndicator.startAnimating()
            imageView.sd_setImage(with: url) { image, _, _, _ in
                let rgbImage = image?.convertedToRGB()
                imageView.image = rgbImage
                activityIndicator.stopAnimating()
            }
        }
        
        let companyLabel = UILabel()
        companyLabel.text = company.name
        companyLabel.font = CMFont.font(size: .tiny, fontName: .avenir)
        companyLabel.numberOfLines = 1
        companyLabel.textColor = CMColor.cmSecondary
        companyLabel.textAlignment = .center
        
        container.addArrangedSubview(imageView)
        container.addArrangedSubview(companyLabel)
        return container
    }
}
