//
//  CoreDataManager.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 26/01/2021.
//

import Foundation
import Combine
import CoreData

protocol DatabaseManagerType {
    func saveCity(_ domain: Domain.City)
    func getCities() -> [Domain.City] 
    var didPerformChanges: CurrentValueSubject<Void, Never> { get }
    
}

class CoreDataManager {
    let didPerformChanges: CurrentValueSubject<Void, Never> = CurrentValueSubject(())
    
    init(coreDataStack: CoreDataStackType) {
        self.coreDataStack = coreDataStack
        subscribeOnCoreDataStackChanges()
    }
    
    private let coreDataStack: CoreDataStackType
    private var subscriptions = Set<AnyCancellable>()
}

extension CoreDataManager: DatabaseManagerType {
    func saveCity(_ domain: Domain.City) {
        for i in 1...5000 {
            let city = City(context: coreDataStack.backgroundContext)
            city.title = "\(domain.title) - \(i)"
            //city.title = domain.title
            city.country = domain.country
        }
        
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
    
    func subscribeOnCoreDataStackChanges() {
        coreDataStack.viewContextPublisher.sink(receiveCompletion: {
            if case .failure = $0 {
                fatalError("Notification publisher crash")
            }
        }, receiveValue: { _ in
            self.didPerformChanges.send(())
        })
        .store(in: &subscriptions)
    }
}

