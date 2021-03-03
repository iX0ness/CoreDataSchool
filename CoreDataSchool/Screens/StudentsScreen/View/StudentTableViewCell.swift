//
//  StudentTableViewCell.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 03/03/2021.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupLabelsTextColor()
        textLabel?.text = "Name"
        detailTextLabel?.text = "Group"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with city: Domain.City) {
        textLabel?.text = city.title
        detailTextLabel?.text = city.country
    }
    
    private func setupLabelsTextColor() {
        textLabel?.textColor = UIColor(hexString: ColorPalette.pacificBlue.hex)
        detailTextLabel?.textColor = UIColor(hexString: ColorPalette.pacificBlue.hex)
    }
}

extension CityTableViewCell: ReusableView {}
