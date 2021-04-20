//
//  CoreDataManger+CityTests.swift
//  CoreDataManger+CityTests
//
//  Created by Mykhaylo Levchuk on 18/04/2021.
//

import XCTest
import CoreData
@testable import CoreDataSchool

class CityTests: XCTestCase {
    
    var coreDataStack: CoreDataStackType!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(storeType: .inMemory)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
    }
    
    func test_create_shouldCreateCity_inStorage() {
        let expectedCount = 1
        
        let city = City.create(in: coreDataStack.backgroundContext)
        city.id = UUID()
        city.title = "Berlin"
        city.country = "Germany"
        
        coreDataStack.backgroundContext.performAndWait {
            coreDataStack.backgroundContext.saveIfNeeded()
        }
        
        let count = citiesCount(in: coreDataStack.mainContext)
        
        XCTAssertEqual(count, expectedCount, "Unexpected cities count found in storage")
    }
    
    func test_create_shouldNotAddStudents_toCityRelation() {
        let city = City.create(in: coreDataStack.backgroundContext)
        city.id = UUID()
        city.title = "Berlin"
        city.country = "Germany"
        
        coreDataStack.backgroundContext.performAndWait {
            coreDataStack.backgroundContext.saveIfNeeded()
        }
        
        let fetchedCity = fetchCities(in: coreDataStack.mainContext).first!
        
        XCTAssertTrue(fetchedCity.students!.isEmpty, "Unexpectedly city has some students in relation")
    }
}

fileprivate var citiesRequest: NSFetchRequest<City> { City.fetchRequest() }

fileprivate func fetchCities(in context: NSManagedObjectContext) -> [City] {
    return try! context.fetch(citiesRequest)
}

fileprivate func citiesCount(in context: NSManagedObjectContext) -> Int {
    return try! context.count(for: citiesRequest)
}
