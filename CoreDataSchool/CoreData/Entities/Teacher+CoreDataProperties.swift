//
//  Teacher+CoreDataProperties.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 03/01/2021.
//
//

import Foundation
import CoreData


extension Teacher {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teacher> {
        return NSFetchRequest<Teacher>(entityName: "Teacher")
    }

    @NSManaged public var birthday: Date
    @NSManaged public var firstname: String
    @NSManaged public var lastname: String
    @NSManaged public var salary: Int16
    @NSManaged public var sex: String

}

extension Teacher : Identifiable {

}
