//
//  CMTextField.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import SnapKit
import UIKit

class CMFloatingTextField: UIView {

    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.backgroundColor = .systemGray5
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.textColor = .gray
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        return placeholderLabel
    }()
    
    init(placeholder: String) {
        super.init(frame: .zero)
        setup(placeholder: placeholder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(placeholder: "")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - PRIVATE FUNC
    private func setup(placeholder: String) {
        placeholderLabel.text = placeholder
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)

        addSubview(textField)
        addSubview(placeholderLabel)
        
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(55)
        }
     
        placeholderLabel.snp.makeConstraints {
            $0.leading.equalTo(textField.snp_leadingMargin)
            $0.centerY.equalTo(textField.snp.centerY)
        }
    }

    private func updatePlaceholderPosition() {
        UIView.animate(withDuration: 0.2) {
            if let text = self.textField.text, !text.isEmpty {
                self.placeholderLabel.font = UIFont.systemFont(ofSize: 12)
                self.placeholderLabel.transform = CGAffineTransform(translationX: 0, y: -18)
            } else {
                self.placeholderLabel.font = UIFont.systemFont(ofSize: 16)
                self.placeholderLabel.transform = .identity
            }
        }
    }
    
    // MARK: - OBJC
    @objc private func textFieldEditingChanged() {
        updatePlaceholderPosition()
    }
}

extension CMFloatingTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updatePlaceholderPosition()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updatePlaceholderPosition()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
