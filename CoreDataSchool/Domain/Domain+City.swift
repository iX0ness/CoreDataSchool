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
    static var mock: Domain.City {
        .init(title: "MockCity",
              country: "MockCountry",
              students: [])
    }
}
