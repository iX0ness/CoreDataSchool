//
//  CoreDataStackTests.swift
//  CoreDataSchoolTests
//
//  Created by Mykhaylo Levchuk on 18/02/2021.
//

import XCTest
import CoreData
@testable import CoreDataSchool

class CoreDataStackTests: XCTestCase {

    var sut: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        sut = CoreDataStack(modelName: "CoreDataSchool", storeType: .inMemory)
    }
    
    func test_configurePersistentContainer_ifCalled_persistenStoreCreated() {
        let configurePersistentStoreExpectation = expectation(description: "Persistent container setup completion called")
        
        _ = sut.configurePersistentContainer {
            configurePersistentStoreExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertTrue(self.sut.persistentContainer.persistentStoreCoordinator.persistentStores.count > 0)
        }
    }

}
