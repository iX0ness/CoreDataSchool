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
        let student: [Domain.Student]
    }
}
