//
//  StudentTests.swift
//  CoreDataSchoolTests
//
//  Created by Mykhaylo Levchuk on 21/04/2021.
//

import XCTest
import CoreData
@testable import CoreDataSchool

class StudentTests: XCTestCase {

    var coreDataStack: CoreDataStackType!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(storeType: .inMemory)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
    }
    
    func test_create_shouldCreateStudent_inStorage() {
        let expectedCount = 1
        
        let student = Student.create(in: coreDataStack.backgroundContext)
        student.id = UUID()
        student.firstname = "John"
        student.lastname = "Doe"
        student.sex = "M"
        student.email = "john.doe@gmail.com"
        
        coreDataStack.backgroundContext.performAndWait {
            coreDataStack.backgroundContext.saveIfNeeded()
        }
        
        let count = FetchRequests.StudentRequests.studentsCount(in: coreDataStack.mainContext)
        
        XCTAssertEqual(count, expectedCount, "Unexpected students count found in storage")
    }
    
    func test_create_shouldNotAddCity_toStudentRelation() {
        let student = Student.create(in: coreDataStack.backgroundContext)
        student.id = UUID()
        student.firstname = "John"
        student.lastname = "Doe"
        student.sex = "M"
        student.email = "john.doe@gmail.com"
        
        coreDataStack.backgroundContext.performAndWait {
            coreDataStack.backgroundContext.saveIfNeeded()
        }
        
        let fetchedStudent = FetchRequests.StudentRequests.fetchStudents(in: coreDataStack.mainContext).first!
        
        XCTAssertNil(fetchedStudent.city, "Unexpectedly student has city relation")
    }
    
    func test_delete_shouldDelete_allStudentsInStorage() {
        let saving = XCTestExpectation(description: "Saving to storage")
        let deletion = XCTestExpectation(description: "Deleting from storage")
        
        let afterSaveExpectedCount = 2
        let afterDeleteExpectedCount = 0
        
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
        
        coreDataStack.backgroundContext.performAndWait {
            coreDataStack.backgroundContext.saveIfNeeded()
            saving.fulfill()
        }
        
        let resultAfterSaveCount = FetchRequests.StudentRequests.studentsCount(in: coreDataStack.mainContext)
        
        coreDataStack.backgroundContext.performAndWait {
            Student.delete(in: coreDataStack.backgroundContext)
            coreDataStack.backgroundContext.saveIfNeeded()
            deletion.fulfill()
        }
        
        let resultAfterDeleteCount = FetchRequests.StudentRequests.studentsCount(in: coreDataStack.mainContext)
        
        wait(for: [saving, deletion], timeout: 1.5)
        
        XCTAssertEqual(afterSaveExpectedCount, resultAfterSaveCount, "Students has not been saved")
        XCTAssertEqual(afterDeleteExpectedCount, resultAfterDeleteCount, "Students have not been saved")
    }
    
    func test_delete_shouldDelete_studentsMatchingPredicate() {
        let saving = XCTestExpectation(description: "Saving to storage")
        let deletion = XCTestExpectation(description: "Deleting from storage")
        
        let afterSaveExpectedCount = 3
        let afterDeleteExpectedCount = 2
        
        let sex = "W"
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Student.sex), sex)
        
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
        
        coreDataStack.backgroundContext.performAndWait {
            coreDataStack.backgroundContext.saveIfNeeded()
            saving.fulfill()
        }
        
        let resultAfterSaveCount = FetchRequests.StudentRequests.studentsCount(in: coreDataStack.mainContext)
        
        coreDataStack.backgroundContext.performAndWait {
            Student.delete(in: coreDataStack.backgroundContext, matching: predicate)
            coreDataStack.backgroundContext.saveIfNeeded()
            deletion.fulfill()
        }
        
        let resultAfterDeleteCount = FetchRequests.StudentRequests.studentsCount(in: coreDataStack.mainContext)
        
        wait(for: [saving, deletion], timeout: 1.0)
        
        XCTAssertEqual(afterSaveExpectedCount, resultAfterSaveCount, "Students has not been saved")
        XCTAssertEqual(afterDeleteExpectedCount, resultAfterDeleteCount, "Students matching predicate have not been saved")
    }
    
    func test_nulifyDeleteRule_studentDeletionShouldNulify_relationInRelatedCity() {
        let saving = XCTestExpectation(description: "Saving to storage")
        let deletion = XCTestExpectation(description: "Deleting from storage")
        
        let expectedStudentsCount = 2
        
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
        
        let fetchedStudent = FetchRequests.StudentRequests.fetchStudents(in: coreDataStack.mainContext).first!
        
        coreDataStack.backgroundContext.performAndWait {
            let student = coreDataStack.backgroundContext.object(with: fetchedStudent.objectID)
            coreDataStack.backgroundContext.delete(student)
            coreDataStack.backgroundContext.saveIfNeeded()
            deletion.fulfill()
        }
        
        wait(for: [saving, deletion], timeout: 1.0)
        
        let fetchedCity = FetchRequests.CityRequests.fetchCities(in: coreDataStack.backgroundContext).first!
        
        XCTAssertEqual(fetchedCity.students?.count, expectedStudentsCount, "Reletion has not been set to nil")
    }
}


