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
    func getCities() -> [Domain.City]
    func getCity(by id: Int) -> Domain.City
    func getCity(by title: String) -> [Domain.City]
    func getCity(in country: String) -> [Domain.City]
}

extension CoreDataManager: CitiesManagerType {
    func saveCity(_ domain: Domain.City) {
        let city = City.create(in: coreDataStack.backgroundContext)
        city.title = domain.title
        city.country = domain.title
        
        coreDataStack.performChanges()
    }
    
    func getCities() -> [Domain.City] {
        let citiesrequest: NSFetchRequest = City.fetchRequest()
        let cities: [City] = try! coreDataStack.mainContext.fetch(citiesrequest)
        var citiesDomain = [Domain.City]()
        cities.forEach {
            let domainCity = Domain.City(title: $0.title, country: $0.country, students: nil)
            citiesDomain.append(domainCity)
        }
        return  citiesDomain
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
