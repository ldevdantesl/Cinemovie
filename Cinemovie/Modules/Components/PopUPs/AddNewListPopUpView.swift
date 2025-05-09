//
//  AddNewListPopUpView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 8.05.2025.
//

import UIKit
import SnapKit

struct AddNewListPopUpViewModel: PopUPViewModel {
    let didTapAdd: ((String, String?) -> Void)?
    let onClose: (() -> Void)?
}

final class AddNewListPopUpView: PopUPView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let listNameCornerRadius = 15.0
        static let addButtonName = "plus"
        static let closeButtonName = "xmark"
        static let closeButtonSize = 25.0
        static let addButtonCornerRadius = 15.0
        static let spacing = 5.0
        static let hSpacing = 10.0
        static let hugeSpacing = 20.0
        static let textFieldHeight = 40.0
        static let addButtonHeight = 40.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: AddNewListPopUpViewModel
    
    // MARK: - VIEW PROPERTIES
    private let addNewListLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.text = "New list"
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addNewListSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.text = "Create your custom collection"
        label.font = CMFont.font(size: .footnote, fontName: .avenirMediumItalic)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmError
        label.font = CMFont.font(size: .footnote, fontName: .avenirDemiBoldItalic)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.alpha = 0
        return label
    }()
    
    private lazy var closeButton: CMCircularButton = {
        let vm = CMCircularButtonViewModel(
            systemName: Constants.closeButtonName, backColor: .clear,
            foreColor: CMColor.cmLabel, imageSizeByRespectingOuterCircle: 0.9
        ) { [weak self] in
            guard let self = self else { return }
            self.dismiss()
        }
        let button = CMCircularButton(viewModel: vm)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addButton: CMButton = {
        let vm = CMButtonViewModel(
            text: "Add", foreColor: CMColor.cmLabel,
            font: CMFont.font(size: .subtitle, fontName: .avenirBold),
            image: UIImage(systemName: Constants.addButtonName),
            backColor: CMColor.cmSystem, cornerRadius: Constants.addButtonCornerRadius
        )
        let button = CMButton(viewModel: vm)
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var listNameTextField: CMTextField = {
        let vm = CMTextFieldViewModel(
            backgroundColor: CMColor.cmSecondaryBackground, textColor: CMColor.cmLabel,
            cornerRadius: Constants.listNameCornerRadius, placeholder: "* List name...",
            font: CMFont.font(size: .body, fontName: .avenirDemiBold), returnKeyType: .done
        )
        let view = CMTextField(viewModel: vm)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var listDescriptionTextField: CMTextField = {
        let vm = CMTextFieldViewModel(
            backgroundColor: CMColor.cmSecondaryBackground, textColor: CMColor.cmLabel,
            cornerRadius: Constants.listNameCornerRadius, placeholder: "? List description (optional)...",
            font: CMFont.font(size: .body, fontName: .avenirDemiBold), returnKeyType: .done
        )
        let view = CMTextField(viewModel: vm)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    init(viewModel: AddNewListPopUpViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel, closesOnBackgroundTap: false)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(addNewListLabel)
        addNewListLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIConstants.topInset)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
        }
        
        addSubview(addNewListSubtitleLabel)
        addNewListSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(addNewListLabel.snp.bottom).offset(Constants.spacing)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
        }
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIConstants.topInset)
            $0.trailing.equalToSuperview().offset(-Constants.hSpacing)
            $0.size.equalTo(Constants.closeButtonSize)
        }
        
        addSubview(listNameTextField)
        listNameTextField.snp.makeConstraints {
            $0.top.equalTo(addNewListSubtitleLabel.snp.bottom).offset(Constants.hugeSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
            $0.height.equalTo(Constants.textFieldHeight)
        }
        
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(listNameTextField.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
        }
        
        addSubview(listDescriptionTextField)
        listDescriptionTextField.snp.makeConstraints {
            $0.top.equalTo(errorLabel.snp.bottom).offset(Constants.hSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
            $0.height.equalTo(Constants.textFieldHeight)
        }
        
        addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-Constants.hugeSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
            $0.height.equalTo(Constants.addButtonHeight)
        }
    }
    
    private func validateTextField() -> Bool {
        guard let text = listNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return false }
        if text.isEmpty || text.count < 3 {
            self.showOrHideErorrLabel(withText: "Title should be more then 3 characters", showing: true)
            return false
        } else {
            self.showOrHideErorrLabel(withText: nil, showing: false)
            return true
        }
    }
    
    private func showOrHideErorrLabel(withText: String?, showing: Bool) {
        self.errorLabel.text = withText
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.errorLabel.alpha = showing ? 1 : 0
        }
    }
    
    // MARK: - OBJC
    @objc private func didTapAddButton() {
        guard let name = listNameTextField.text, validateTextField() else { return }
        let descriptionText = (listDescriptionTextField.text ?? "").isEmpty ? nil : listDescriptionTextField.text
        viewModel.didTapAdd?(name, descriptionText)
    }
}

extension AddNewListPopUpView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
