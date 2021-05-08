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
        
        let count = FetchRequests.CityRequests.citiesCount(in: coreDataStack.mainContext)
        
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
        
        let fetchedCity = FetchRequests.CityRequests.fetchCities(in: coreDataStack.mainContext).first!
        
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
        
        let resultAfterSaveCount = FetchRequests.CityRequests.citiesCount(in: coreDataStack.mainContext)
        
        coreDataStack.backgroundContext.performAndWait {
            City.delete(in: coreDataStack.backgroundContext)
            coreDataStack.backgroundContext.saveIfNeeded()
            deletion.fulfill()
        }
        
        let resultAfterDeleteCount = FetchRequests.CityRequests.citiesCount(in: coreDataStack.mainContext)
        
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
        
        let resultAfterSaveCount = FetchRequests.CityRequests.citiesCount(in: coreDataStack.mainContext)
        
        coreDataStack.backgroundContext.performAndWait {
            City.delete(in: coreDataStack.backgroundContext, matching: predicate)
            coreDataStack.backgroundContext.saveIfNeeded()
            deletion.fulfill()
        }
        
        let resultAfterDeleteCount = FetchRequests.CityRequests.citiesCount(in: coreDataStack.mainContext)
        
        wait(for: [saving, deletion], timeout: 1.0)
        
        XCTAssertEqual(afterSaveExpectedCount, resultAfterSaveCount, "Cities has not been saved")
        XCTAssertEqual(afterDeleteExpectedCount, resultAfterDeleteCount, "Cities matching predicate have not been saved")
    }
    
    func test_cascadeDeleteRule_cityDeletionShouldDelete_allRelatedStudents() {
        let saving = XCTestExpectation(description: "Saving to storage")
        let deletion = XCTestExpectation(description: "Deleting from storage")
        
        let expectedCitiesCount = 0
        let expectedStudentsCount = 0
        
        let berlin = City.create(in: coreDataStack.backgroundContext)
        berlin.id = UUID()
        berlin.title = "Berlin"
        berlin.country = "Germany"
        
        let student1 = Student.create(in: coreDataStack.backgroundContext)
        student1.id = UUID()
        student1.firstname = "Sergey"
        student1.lastname = "Brin"
        student1.sex = "M"
        student1.email = "sergey.brin@gmail.com"
        
        let student2 = Student.create(in: coreDataStack.backgroundContext)
        student2.id = UUID()
        student2.firstname = "Larry"
        student2.lastname = "Page"
        student2.sex = "M"
        student2.email = "larry.page@gmail.com"
        
        let student3 = Student.create(in: coreDataStack.backgroundContext)
        student3.id = UUID()
        student3.firstname = "Marilyn"
        student3.lastname = "Monroe"
        student3.sex = "W"
        student3.email = "marilyn.monroe@gmail.com"
        
        let sudents = Set<Student>(arrayLiteral: student1, student2, student3) as NSSet
        
        berlin.addToStudents(sudents)
        
        coreDataStack.backgroundContext.performAndWait {
            coreDataStack.backgroundContext.saveIfNeeded()
            saving.fulfill()
        }
        
        let city = FetchRequests.CityRequests.fetchCities(in: coreDataStack.mainContext).first!
        
        coreDataStack.backgroundContext.performAndWait {
            let fetchedCity = coreDataStack.backgroundContext.object(with: city.objectID)
            coreDataStack.backgroundContext.delete(fetchedCity)
            coreDataStack.backgroundContext.saveIfNeeded()
            deletion.fulfill()
        }
        
        wait(for: [saving, deletion], timeout: 1.0)
        
        let fetchedCitiesCount = FetchRequests.CityRequests.citiesCount(in: coreDataStack.mainContext)
        let fetchedStudentsCount = FetchRequests.StudentRequests.studentsCount(in: coreDataStack.mainContext)
        
        XCTAssertEqual(fetchedCitiesCount, expectedCitiesCount, "City hs not been deleted")
        XCTAssertEqual(fetchedStudentsCount, expectedStudentsCount, "All students related to the city should be removed")
       
        
    }
}
