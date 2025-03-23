//
//  PersonDetailsSourcesView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 20.03.2025.
//

import UIKit
import SnapKit

fileprivate final class SourceImageView: UIImageView {
    var sourceID: String?
    var sourceType: ExternalSource.SourceTypes?
}

struct PersonDetailsSourcesViewModel: PersonDetailsCellViewModel {
    let identifier: String = "PersonDetailsSourcesView"
    let externalSource: ExternalSource
    var didTapLogo: ((String, ExternalSource.SourceTypes) -> Void)?
    
    init(externalSource: ExternalSource, didTapLogo: ((String, ExternalSource.SourceTypes) -> Void)?) {
        self.externalSource = externalSource
        self.didTapLogo = didTapLogo
    }
}

final class PersonDetailsSourcesView: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 5.0
        static let bigPadding = 10.0
        static let sourceStackHeight = 30.0
        static let superPadding = 15.0
    }
    
    // MARK: - STATIC
    static let identifier = "PersonDetailsSourcesView"
    
    // MARK: - PROPERTIES
    private var viewModel: PersonDetailsSourcesViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let sourcesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.bigPadding
        stack.distribution = .equalSpacing
        stack.isUserInteractionEnabled = true
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
    public func configure(viewModel: PersonDetailsSourcesViewModel) {
        self.viewModel = viewModel
        
        sourcesStack.arrangedSubviews.forEach {
            sourcesStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        addSource(id: viewModel.externalSource.instagramID, image: .instaLogo)
        addSource(id: viewModel.externalSource.facebookID, image: .facebookLogo)
        addSource(id: viewModel.externalSource.twitterID, image: .twitterLogo)
        addSource(id: viewModel.externalSource.wikidataID, image: .wikiLogo)
        addSource(id: viewModel.externalSource.imdbID, image: .imdbLogo)
        addSource(id: viewModel.externalSource.youtubeID, image: .youtubeLogo)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(sourcesStack)
        sourcesStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func addSource(id: String?, image: ImageNames) {
        guard let identifiedSourceType = image.identifiedSourceType else { return }
        guard let id = id else { return }
        
        let idImageView = SourceImageView()
        idImageView.image = UIImage(named: image.rawValue)
        idImageView.contentMode = .scaleAspectFit
        idImageView.translatesAutoresizingMaskIntoConstraints = false
        idImageView.isUserInteractionEnabled = true
        idImageView.sourceID = id
        idImageView.sourceType = identifiedSourceType
        
        idImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLogo)))
        idImageView.snp.makeConstraints { $0.size.equalTo(Constants.sourceStackHeight) }
        sourcesStack.addArrangedSubview(idImageView)
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapLogo(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? SourceImageView else { return }
        guard let sourceID = view.sourceID else { return }
        guard let sourceType = view.sourceType else { return }
        viewModel?.didTapLogo?(sourceID, sourceType)
    }
}
