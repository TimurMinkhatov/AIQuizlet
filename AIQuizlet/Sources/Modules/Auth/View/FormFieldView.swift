//
//  FormFieldView.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 12/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class FormFieldView: UIView {

    // MARK: - Properties

    var text: String? { textField.text }

    func setPlaceholder(_ placeholder: String) {
        textField.placeholder = placeholder
    }

    // MARK: - UI Components

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.leftViewMode = .always
        return textField
    }()

    // MARK: - Init

    init(labelText: String, placeholder: String, isSecure: Bool = false, keyboardType: UIKeyboardType = .default, iconName: String) {
        super.init(frame: .zero)
        label.text = labelText
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        textField.keyboardType = keyboardType
        textField.leftView = makeIconView(systemName: iconName)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("Инициализатор не реализован")
    }
}

// MARK: - Private Methods

private extension FormFieldView {

    func setupLayout() {
        addSubview(label)
        addSubview(textField)

        label.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        textField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
    }

    func makeIconView(systemName: String) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        let imageView = UIImageView(image: UIImage(systemName: systemName))
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 10, y: 15, width: 20, height: 20)
        container.addSubview(imageView)
        return container
    }
}
