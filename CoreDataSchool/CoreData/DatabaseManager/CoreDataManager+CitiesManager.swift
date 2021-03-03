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
        coreDataStack.performSave { context in
            for i in 0...5000 {
                let city = City.create(in: context)
                city.title = domain.title + "\(i)"
                city.country = domain.title
            }
        }
    }
    
    func getCities(completion: @escaping ([Domain.City]) -> Void) {
        coreDataStack.performFetch { context in
            let cities = City.read(in: context).map { $0.domain }
            completion(cities)
        }
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
