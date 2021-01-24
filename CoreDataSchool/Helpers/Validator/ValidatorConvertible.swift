//
//  ValidatorConvertible.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 18/01/2021.
//

import Foundation

protocol ValidatorConvertible {
    var pattern: String { get }
    func validated(_ value: String) -> String?
}

extension ValidatorConvertible {
    var pattern: String { "[.*]" }
    
    func validated(_ value: String) -> String? {
        let regex = NSRegularExpression(pattern)
        return regex.isMatching(value) ? value : nil
    }
}
