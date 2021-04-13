//
//  Domain+Student.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 03/01/2021.
//

import Foundation

extension Domain {
    struct Student {
        let id: UUID
        let firstname: String
        let lastname: String
        let email: String
        let sex: String
        let city: Domain.City?
        
        init(id: UUID = UUID(), firstname: String, lastname: String, email: String, sex: String, city: Domain.City? = nil) {
            self.id = id
            self.firstname = firstname
            self.lastname = lastname
            self.email = email
            self.sex = sex
            self.city = city
        }
    }
}

extension Domain.Student {
    static var mock: Domain.Student {
        .init(firstname: "John",
              lastname: "Doe",
              email: "john.doe@gmail.com",
              sex: "M",
              city: Domain.City.mock
        )
    }
}
