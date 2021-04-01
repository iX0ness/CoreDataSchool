//
//  Validator.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 16/01/2021.
//

import Foundation

enum ValidatorType {
    case email
    case personAlias
    case groupTitle
    case localityAlias
    indirect case requiredField(validatorType: ValidatorType)
}

struct EmailValidator: ValidatorConvertible {
    let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
}

struct PersonAliasValidator: ValidatorConvertible {
    let pattern = "(?<! )[-a-zA-Z' ]{2,26}"
}

struct GroupTitleValidator: ValidatorConvertible {}

struct LocalityAliasValidator: ValidatorConvertible {
    let pattern = "^[A-Za-z]{3,12}$"
}

struct RequiredFieldValidator: ValidatorConvertible {
    let validator: ValidatorConvertible
    
    init(validator: ValidatorConvertible) {
        if let _ = validator as? RequiredFieldValidator {
            fatalError("Required field validator must accept other type then itself")
        }
        self.validator = validator
    }
    
    func validated(_ value: String) -> String? {
        return validator.validated(value)
    }
}

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        case .personAlias: return PersonAliasValidator()
        case .groupTitle: return GroupTitleValidator()
        case .localityAlias: return LocalityAliasValidator()
        case .requiredField(let validatorType): return RequiredFieldValidator(validator: validatorFor(type: validatorType))
        }
    }
}
