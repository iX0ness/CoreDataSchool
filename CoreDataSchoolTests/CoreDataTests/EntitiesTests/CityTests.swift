//
//  CityTests.swift
//  CoreDataSchoolTests
//
//  Created by Mykhaylo Levchuk on 24/02/2021.
//

import XCTest
import CoreData
@testable import CoreDataSchool

class CityTests: XCTestCase {

    var storage: CoreDataStackType!
    let citiesRequest: NSFetchRequest = City.fetchRequest()
    
    override func setUp() {
        super.setUp()
        storage = CoreDataStack(modelName: "CoreDataSchool", storeType: .inMemory)
    }
    
    func test_save_storageShouldSaveCity() {
        let expectation = XCTestExpectation(description: "City saved to storage")
        
        storage.perform { context in
            let city = City(context: context)
            city.title = "London"
            city.country = "UK"
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        
        
    }

}
