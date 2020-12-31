//
//  MenuCollectionViewCell.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 30/12/2020.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: UIFont.systemFontSize, weight: .bold, scale: .large)
        let image = UIImage(
            systemName: "graduationcap", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor(hexString: "#34415E")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructHierarchy()
        activateConstraints()
        setupRoundedCorners()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 10
        ).cgPath
    }
    
    func setOpacity(to value: Float) {
        layer.shadowOpacity = value
    }
    
    func setBorderColor(_ color: UIColor) {
        contentView.layer.borderColor = color.cgColor
    }
    
    
}

private extension MenuCollectionViewCell {
    func constructHierarchy() {
        addSubview(imageView)
    }
    
    func setupRoundedCorners() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        
        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.red.cgColor
        
        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = 10
        layer.masksToBounds = false
        
        // Apply a shadow
        layer.shadowRadius = 8.0
//        layer.shadowOpacity = 0.30
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: bounds.width * 0.4),
            imageView.heightAnchor.constraint(equalToConstant: bounds.width * 0.4),
        ])
    }
}

extension MenuCollectionViewCell: ReusableView {}
