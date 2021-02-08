//
//  Domain+City.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 03/01/2021.
//

import Foundation

extension Domain {
    struct City {
        let title: String
        let country: String
        let students: [Domain.Student]?
    }
}

extension Domain.City {
    static var mock: Domain.City {
        Domain.City(title: "MockCity", country: "MockCountry", students: [])
    }
}
