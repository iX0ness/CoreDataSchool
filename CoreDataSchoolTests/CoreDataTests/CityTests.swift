//
//  CityTests.swift
//  CoreDataSchoolTests
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
    
    func test_delete_shouldDelete_allCitiesInStorage() {
        let saving = XCTestExpectation(description: "Saving to storage")
        let deletion = XCTestExpectation(description: "Deleting from storage")
        
        let afterSaveExpectedCount = 2
        let afterDeleteExpectedCount = 0
        
        let berlin = City.create(in: coreDataStack.backgroundContext)
        berlin.id = UUID()
        berlin.title = "Berlin"
        berlin.country = "Germany"
        
        let kyiv = City.create(in: coreDataStack.backgroundContext)
        kyiv.id = UUID()
        kyiv.title = "Kyiv"
        kyiv.country = "Ukraine"
        
        coreDataStack.backgroundContext.performAndWait {
            coreDataStack.backgroundContext.saveIfNeeded()
            saving.fulfill()
        }
        
        let resultAfterSaveCount = citiesCount(in: coreDataStack.mainContext)
        
        coreDataStack.backgroundContext.performAndWait {
            City.delete(in: coreDataStack.backgroundContext)
            coreDataStack.backgroundContext.saveIfNeeded()
            deletion.fulfill()
        }
        
        let resultAfterDeleteCount = citiesCount(in: coreDataStack.mainContext)
        
        wait(for: [saving, deletion], timeout: 1.0)
        
        XCTAssertEqual(afterSaveExpectedCount, resultAfterSaveCount, "Cities has not been saved")
        XCTAssertEqual(afterDeleteExpectedCount, resultAfterDeleteCount, "Cities have not been saved")
    }
    
    func test_delete_shouldDelete_citiesMatchingPredicate() {
        let saving = XCTestExpectation(description: "Saving to storage")
        let deletion = XCTestExpectation(description: "Deleting from storage")
        
        let afterSaveExpectedCount = 3
        let afterDeleteExpectedCount = 1
        
        let citiesCountry = "Germany"
        let predicate = NSPredicate(format: "%K == %@", #keyPath(City.country), citiesCountry)
        
        let berlin = City.create(in: coreDataStack.backgroundContext)
        berlin.id = UUID()
        berlin.title = "Berlin"
        berlin.country = citiesCountry
        
        let munich = City.create(in: coreDataStack.backgroundContext)
        munich.id = UUID()
        munich.title = "Munich"
        munich.country = citiesCountry
        
        let kyiv = City.create(in: coreDataStack.backgroundContext)
        kyiv.id = UUID()
        kyiv.title = "Kyiv"
        kyiv.country = "Ukraine"
        
        coreDataStack.backgroundContext.performAndWait {
            coreDataStack.backgroundContext.saveIfNeeded()
            saving.fulfill()
        }
        
        let resultAfterSaveCount = citiesCount(in: coreDataStack.mainContext)
        
        coreDataStack.backgroundContext.performAndWait {
            City.delete(in: coreDataStack.backgroundContext, matching: predicate)
            coreDataStack.backgroundContext.saveIfNeeded()
            deletion.fulfill()
        }
        
        let resultAfterDeleteCount = citiesCount(in: coreDataStack.mainContext)
        
        wait(for: [saving, deletion], timeout: 1.0)
        
        XCTAssertEqual(afterSaveExpectedCount, resultAfterSaveCount, "Cities has not been saved")
        XCTAssertEqual(afterDeleteExpectedCount, resultAfterDeleteCount, "Cities matching predicate have not been saved")
    }
}

fileprivate var citiesRequest: NSFetchRequest<City> { City.fetchRequest() }

fileprivate func fetchCities(in context: NSManagedObjectContext) -> [City] {
    return try! context.fetch(citiesRequest)
}

fileprivate func citiesCount(in context: NSManagedObjectContext) -> Int {
    return try! context.count(for: citiesRequest)
}
