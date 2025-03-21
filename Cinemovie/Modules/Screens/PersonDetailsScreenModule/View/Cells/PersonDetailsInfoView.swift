//
//  PersonDetailsInfoView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 20.03.2025.
//

import UIKit
import SnapKit

struct PersonDetailsInfoViewModel: PersonDetailsCellViewModel {
    let identifier: String = "PersonDetailsInfoView"
    let name: String
    let job: String
    let birthday: String?
    let hometown: String?
    let gender: Int
    
    init(name: String, job: String, birthday: String?, hometown: String?, gender: Int) {
        self.name = name
        self.job = job
        self.birthday = birthday
        self.hometown = hometown
        self.gender = gender
    }
    
    var totalAvailableInfo: Int {
        var counter: Int = 3
        counter = hometown == nil ? counter : counter + 1
        counter = birthday == nil ? counter : counter + 1
        return counter
    }
}

final class PersonDetailsInfoView: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 5.0
    }
    
    // MARK: - STATIC
    static let identifier = "PersonDetailsInfoView"
    
    // MARK: - PROPERTIES
    private var viewModel: PersonDetailsInfoViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hometownLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .caption, fontName: .avenir)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.spacing
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
    public func configure(viewModel: PersonDetailsInfoViewModel) {
        self.viewModel = viewModel
        
        labelConfig(labelDescription: "Name:", text: viewModel.name, view: nameLabel)
        labelConfig(labelDescription: "Job: ", text: viewModel.job, view: jobLabel)
        labelConfig(labelDescription: "Birthday: ", text: CMDateFormatter.formatToNormalDate(dateString: viewModel.birthday ?? ""), view: birthdayLabel)
        labelConfig(labelDescription: "Hometown: ", text: viewModel.hometown, view: hometownLabel)
        labelConfig(labelDescription: "Gender: ", text: GenderHelper.identifyGender(gender: viewModel.gender), view: genderLabel)
        infoStackView.addArrangedSubview(UIView())
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(infoStackView)
        infoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func labelConfig(labelDescription: String, text: String?, view: UILabel) {
        if let text = text, !text.isEmpty {
            let label = UILabel()
            label.text = labelDescription
            label.font = CMFont.font(size: .body, fontName: .avenirBold)
            label.textColor = CMColor.cmLabel
            
            let hStack = UIStackView(arrangedSubviews: [label, UIView(), view])
            hStack.axis = .horizontal
            hStack.distribution = .fill
            
            infoStackView.addArrangedSubview(hStack)
            view.text = text
        }
    }
}
