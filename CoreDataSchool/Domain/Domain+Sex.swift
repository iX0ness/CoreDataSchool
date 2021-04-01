//
//  Domain+Sex.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 18/03/2021.
//

import Foundation

extension Domain {
    enum Sex: String {
        case M = "M"
        case W = "W"
        
        init?(rawValue: String) {
            switch rawValue {
            case "M": self = .M
            case "W": self = .W
            default: return nil
            }
        }
    }
}
