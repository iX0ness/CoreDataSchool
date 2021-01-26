//
//  DatabaseManager.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 26/01/2021.
//

import Foundation

protocol DatabaseManagerType {
    func saveCity(_ city: Domain.City)
}

class DatabaseManager: DatabaseManagerType {
    let coreDataStack: CoreDataStackType
    
    init(coreDataStack: CoreDataStackType) {
        self.coreDataStack = coreDataStack
    }
    
    func saveCity(_ city: Domain.City) {
        print("City \(city) saved")
    }
}
