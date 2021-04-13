//
//  Domain+Student.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 03/01/2021.
//

import Foundation

extension Domain {
    struct Student {
        //let birthday: Date
        let firstname: String
        let lastname: String
        let email: String
        let sex: String
        let city: Domain.City?
        //let group: Domain.Group
    }
}

extension Domain.Student {
    static var mock: Domain.Student {
        .init(firstname: "John",
              lastname: "Doe",
              email: "john.doe@gmail.com",
              sex: "M",
              city: Domain.City.mock
              //group: Domain.Group.mock
        )
    }
}
