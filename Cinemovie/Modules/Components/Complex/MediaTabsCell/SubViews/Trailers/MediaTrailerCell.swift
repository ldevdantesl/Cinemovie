//
//  MediaTrailerCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.04.2025.
//

import UIKit
import SnapKit

final class MediaTrailerCellViewModel: CellViewModelBaseClass {
    let trailer: Video
    
    init(trailer: Video) {
        self.trailer = trailer
        super.init(cellIdentifier: "MediaTrailerCell")
    }
}

final class MediaTrailerCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let youtubeViewHeight = 200.0
        static let youtubeViewCornerRadius = 15.0
        static let spacing = 10.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MediaTrailerCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let youtubeView: YouTubeWebPlayerView = {
        let view = YouTubeWebPlayerView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let trailerName: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        youtubeView.layer.cornerRadius = Constants.youtubeViewCornerRadius
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: MediaTrailerCellViewModel) {
        self.viewModel = viewModel
        self.trailerName.text = viewModel.trailer.name
        youtubeView.setupVideo(video: viewModel.trailer)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(youtubeView)
        youtubeView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.youtubeViewHeight)
        }
        
        contentView.addSubview(trailerName)
        trailerName.snp.makeConstraints {
            $0.top.equalTo(youtubeView.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
