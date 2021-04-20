//
//  Domain+City.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 03/01/2021.
//

import Foundation

extension Domain {
    struct City {
        let id: UUID
        let title: String
        let country: String
        let students: [Domain.Student]?
        
        init(id: UUID = UUID(), title: String, country: String, students: [Domain.Student]? = nil) {
            self.id = id
            self.title = title
            self.country = country
            self.students = students
        }
    }
}

extension Domain.City {
    static func mock(title: String = "Berlin", country: String = "Germany", students: [Domain.Student]? = nil) -> Domain.City {
        .init(title: title,
            country: country,
            students: students)
    }
}
