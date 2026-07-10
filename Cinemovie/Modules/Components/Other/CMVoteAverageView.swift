//
//  CMVoteAverage.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.07.2026.
//

import UIKit
import SnapKit

final class CMVoteAverageView: UIView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let starCount = 5
        static let starSize: CGFloat = 12
        static let starSpacing: CGFloat = 2
        static let filledColor = UIColor.systemYellow
        static let emptyColor = CMColor.cmSecondary.withAlphaComponent(0.35)
        static let maxVote = 10.0
    }

    // MARK: - PROPERTIES
    private let emptyStack = makeStarStack(color: Constants.emptyColor)
    private let filledStack = makeStarStack(color: Constants.filledColor)
    private let filledContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let voteCountLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenirDemiBold)
        label.textColor = CMColor.cmSecondary
        return label
    }()

    private var fillFraction: CGFloat = 0

    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init(voteAverage: Double, voteCount: Int) {
        self.init(frame: .zero)
        self.configure(voteAverage: voteAverage, voteCount: voteCount)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateFillWidth()
    }

    // MARK: - PUBLIC FUNC
    public func configure(voteAverage: Double, voteCount: Int) {
        let clamped = min(max(voteAverage, 0), Constants.maxVote)
        fillFraction = CGFloat(clamped / Constants.maxVote)
        voteCountLabel.text = voteCount.compactCount
        updateFillWidth()
    }

    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(emptyStack)
        addSubview(filledContainer)
        filledContainer.addSubview(filledStack)
        addSubview(voteCountLabel)

        voteCountLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(emptyStack)
        }
        emptyStack.snp.makeConstraints {
            $0.leading.equalTo(voteCountLabel.snp.trailing).offset(4)
            $0.top.bottom.trailing.equalToSuperview()
        }
        filledContainer.snp.makeConstraints {
            $0.leading.top.bottom.equalTo(emptyStack)
        }
        filledStack.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
    }

    private func updateFillWidth() {
        let fullWidth = emptyStack.bounds.width
        guard fullWidth > 0 else { return }
        filledContainer.snp.remakeConstraints {
            $0.leading.top.bottom.equalTo(emptyStack)
            $0.width.equalTo(fullWidth * fillFraction)
        }
    }

    private static func makeStarStack(color: UIColor) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.starSpacing
        for _ in 0..<Constants.starCount {
            let iv = UIImageView(image: UIImage(systemName: "star.fill"))
            iv.tintColor = color
            iv.contentMode = .scaleAspectFit
            iv.snp.makeConstraints { $0.size.equalTo(Constants.starSize) }
            stack.addArrangedSubview(iv)
        }
        return stack
    }
}
