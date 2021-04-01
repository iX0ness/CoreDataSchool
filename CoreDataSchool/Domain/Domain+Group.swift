//
//  Domain+Group.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 03/01/2021.
//

import Foundation

extension Domain {
    struct Group {
        let speciality: String
        let title: String
        let students: [Domain.Student]?
    }
}

extension Domain.Group {
    static var mock: Domain.Group {
        Domain.Group(speciality: "Informatics",
                     title: "I-A",
                     students: [])
    }
}
