//
//  TextFieldCollectionViewCell.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 02/01/2021.
//

import UIKit

protocol TextFieldCollectionViewCellDelegate: class {
    func textFiledEditingChanged(_ textField: UITextField, with placeholder: String, and text: String)
}

class TextFieldCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: TextFieldCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTextField()
        activateConstraints()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlaceholder(_ placeholder: String) {
        textField.placeholder = placeholder
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.setLeftPadding(5)
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(didEndEditting), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
}

private extension TextFieldCollectionViewCell {
    private func addTextField() {
        addSubview(textField)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @objc private func didEndEditting(_ sender: UITextField) {
        guard let placeholder = sender.placeholder,
              let text = sender.text else { return }
        delegate?.textFiledEditingChanged(sender, with: placeholder, and: text)
    }
}

extension TextFieldCollectionViewCell: ReusableView {}
