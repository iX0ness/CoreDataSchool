//
//  CoreDataManager.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 26/01/2021.
//

import Foundation

protocol DatabaseManagerType {
    func saveCity(_ city: Domain.City)
}

class CoreDataManager: DatabaseManagerType {
    private let coreDataStack: CoreDataStackType
    
    init(coreDataStack: CoreDataStackType) {
        self.coreDataStack = coreDataStack
    }
    
    func saveCity(_ city: Domain.City) {
        print("City: \(city) saved")
    }
}

private extension CoreDataManager {
    func save(_ model: Domain) {
        let context = coreDataStack.mainContext
        
    }
}
