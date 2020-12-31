//
//  ImageAssets.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 31/12/2020.
//

import UIKit

enum ImageAssets {
    case students
    case groups
    case cities
    
    var assetTitle: String {
        switch self {
        case .students: return "graduationcap"
        case .groups: return "person.3"
        case .cities: return "building.2"
        }
    }
}
