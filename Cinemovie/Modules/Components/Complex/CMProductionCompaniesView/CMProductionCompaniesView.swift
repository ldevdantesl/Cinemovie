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
    
    fileprivate enum Paddings {
        static let hStackTopPadding: CGFloat = 10
        static let containerSpacing: CGFloat = 10
    }
    
    fileprivate enum Constants {
        static let hstackSpacing: CGFloat = 8
        static let productionCompaniesPrefix: Int = 2
        
        static let imageViewImageName: String = "building.columns"
        static let imageViewImageWidth: CGFloat = 100
        static let imageViewImageHeight: CGFloat = 40
    }
    
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
        hStack.spacing = Constants.hstackSpacing
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
            $0.top.equalTo(productionTitleLabel.snp.bottom).offset(Paddings.hStackTopPadding)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        productionCompanies.prefix(Constants.productionCompaniesPrefix).forEach { company in
            let companyView = createCompanyView(for: company)
            hStack.addArrangedSubview(companyView)
            hStack.addArrangedSubview(UIView())
        }
        
        hStack.layoutIfNeeded()
    }
    
    private func createCompanyView(for company: ProductionCompany) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = Paddings.containerSpacing
        container.alignment = .center
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: Constants.imageViewImageName)
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { $0.width.equalTo(Constants.imageViewImageWidth); $0.height.equalTo(Constants.imageViewImageHeight) }
        
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
