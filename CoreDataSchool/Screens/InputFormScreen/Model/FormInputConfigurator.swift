//
//  FormInputConfigurator.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 06/01/2021.
//

import Foundation

enum InputCellType {
    case textField
}

struct FormInputConfigurator {
    let placeholder: String
    let validator: ValidatorConvertible
    let cellType: InputCellType
}
