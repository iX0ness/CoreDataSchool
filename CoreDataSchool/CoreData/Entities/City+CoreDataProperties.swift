//
//  City+CoreDataProperties.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 03/01/2021.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var country: String
    @NSManaged public var title: String
    @NSManaged public var student: NSSet?

}

// MARK: Generated accessors for student
extension City {

    @objc(addStudentObject:)
    @NSManaged public func addToStudent(_ value: Student)

    @objc(removeStudentObject:)
    @NSManaged public func removeFromStudent(_ value: Student)

    @objc(addStudent:)
    @NSManaged public func addToStudent(_ values: NSSet)

    @objc(removeStudent:)
    @NSManaged public func removeFromStudent(_ values: NSSet)

}

extension City : Identifiable {}

extension City {
    var domain: Domain.City {
        Domain.City(title: title, country: country, students: nil)
    }
}
