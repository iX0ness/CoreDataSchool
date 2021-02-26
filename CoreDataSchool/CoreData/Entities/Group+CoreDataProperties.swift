//
//  Group+CoreDataProperties.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 26/02/2021.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var speciality: String
    @NSManaged public var title: String
    @NSManaged public var students: Set<Student>?

}

// MARK: Generated accessors for student
extension Group {

    @objc(addStudentObject:)
    @NSManaged public func addToStudent(_ value: Student)

    @objc(removeStudentObject:)
    @NSManaged public func removeFromStudent(_ value: Student)

    @objc(addStudent:)
    @NSManaged public func addToStudent(_ values: Set<Student>)

    @objc(removeStudent:)
    @NSManaged public func removeFromStudent(_ values: Set<Student>)

}

extension Group : Identifiable {}

extension Group {
    var domain: Domain.Group {
        Domain.Group(
            speciality: speciality,
            title: title,
            students: students?.map { $0.domain} )
    }
}
