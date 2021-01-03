//
//  Domain+Student.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 03/01/2021.
//

import Foundation

extension Domain {
    struct Student {
        let birthday: Date
        let email: String
        let firstname: String
        let lastname: String
        let sex: String
        let city: Domain.City
        let group: Domain.Group
    }
}
