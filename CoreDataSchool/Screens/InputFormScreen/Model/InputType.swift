//
//  InputType.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 06/01/2021.
//

import Foundation

enum TextFieldInput {
    case obligatory(InputType)
    case optional(InputType)
}

enum InputType {
    case String(Placeholder)
    case Integer(Placeholder)
    case Float(Placeholder)
    case Bool(Placeholder)
    case Date(Placeholder)
}

struct Placeholder {
    let value: String
    init(_ value: String) {
        self.value = value
    }
}


