//
//  FetchRequests.swift
//  CoreDataSchoolTests
//
//  Created by Mykhaylo Levchuk on 08/05/2021.
//

import Foundation
import CoreData
@testable import CoreDataSchool

enum FetchRequests {
    enum CityRequests {
        private static var citiesRequest: NSFetchRequest<City> { City.fetchRequest() }

        static func fetchCities(in context: NSManagedObjectContext) -> [City] {
            return try! context.fetch(citiesRequest)
        }

        static func citiesCount(in context: NSManagedObjectContext) -> Int {
            return try! context.count(for: citiesRequest)
        }
    }
    
    enum StudentRequests {
        private static var studentsRequest: NSFetchRequest<Student> { Student.fetchRequest() }

        static func fetchStudents(in context: NSManagedObjectContext) -> [Student] {
            return try! context.fetch(studentsRequest)
        }

        static func studentsCount(in context: NSManagedObjectContext) -> Int {
            return try! context.count(for: studentsRequest)
        }
    }
}
