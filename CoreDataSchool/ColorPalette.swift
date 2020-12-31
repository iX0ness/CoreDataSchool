//
//  ColorPalette.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 31/12/2020.
//

import UIKit

enum ColorPalette {
    case menuItem
    
    var hex: String {
        switch self {
        case .menuItem: return "34415E"
        }
    }
}
