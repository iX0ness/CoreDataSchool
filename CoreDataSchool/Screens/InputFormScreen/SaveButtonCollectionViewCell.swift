//
//  SaveButtonCollectionViewCell.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 03/01/2021.
//

import UIKit

class SaveButtonCollectionViewCell: UICollectionViewCell {
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        button.backgroundColor = UIColor(hexString: ColorPalette.berry.hex)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructHierarchy()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constructHierarchy() {
        addSubview(saveButton)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 16),
            saveButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalTo: layoutMarginsGuide.heightAnchor),
        ])
    }
    
    @objc func save() {
        print("save")
    }
}

extension SaveButtonCollectionViewCell: ReusableView {}
