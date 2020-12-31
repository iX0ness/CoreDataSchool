//
//  ColorPalette.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 31/12/2020.
//

import UIKit

enum ColorPalette {
    case pacificBlue
    case ashGray
    
    var hex: String {
        switch self {
        case .pacificBlue: return "34415E"
        case .ashGray: return "484848"
        }
    }
}
