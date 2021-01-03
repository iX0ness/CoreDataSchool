//
//  Student+CoreDataProperties.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 03/01/2021.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var birthday: Date
    @NSManaged public var email: String
    @NSManaged public var firstname: String
    @NSManaged public var lastname: String
    @NSManaged public var sex: String
    @NSManaged public var city: City
    @NSManaged public var group: Group

}

extension Student : Identifiable {

}
