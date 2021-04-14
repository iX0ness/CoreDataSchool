//
//  CitiesManager.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 08/02/2021.
//

import Foundation
import CoreData

protocol CitiesManagerType {
    func saveCity(_ domain: Domain.City)
    func getCities(completion: @escaping ([Domain.City]) -> Void)
    func getCity(by id: Int) -> Domain.City
    func getCity(by title: String) -> [Domain.City]
    func getCity(in country: String) -> [Domain.City]
}

extension CoreDataManager: CitiesManagerType {
    func saveCity(_ domain: Domain.City) {
        let city = City.create(in: coreDataStack.backgroundContext)
        city.id = domain.id
        city.title = domain.title
        city.country = domain.title
        
        coreDataStack.backgroundContext.saveIfNeeded()
    }
    
    func getCities(completion: @escaping ([Domain.City]) -> Void) {
        let cities = City.read(in: coreDataStack.mainContext).map { $0.domain }
        completion(cities)
    }
    
    
    func getCity(by id: Int) -> Domain.City {
        Domain.City.mock
    }
    
    func getCity(by title: String) -> [Domain.City] {
        [Domain.City.mock,
         Domain.City.mock,
         Domain.City.mock,
         Domain.City.mock,
        ]
    }
    
    func getCity(in country: String) -> [Domain.City] {
        [Domain.City.mock,
         Domain.City.mock,
         Domain.City.mock,
         Domain.City.mock,
        ]
    }
}
