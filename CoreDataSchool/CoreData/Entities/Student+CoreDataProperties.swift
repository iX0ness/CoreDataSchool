//
//  Student+CoreDataProperties.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 13/04/2021.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var email: String
    @NSManaged public var firstname: String
    @NSManaged public var id: UUID
    @NSManaged public var lastname: String
    @NSManaged public var sex: String
    @NSManaged public var city: City?

}

extension Student : Identifiable {}
