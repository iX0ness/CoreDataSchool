//
//  City+Extension.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 13/04/2021.
//

import Foundation
import CoreData

extension City {
    var domain: Domain.City {
        Domain.City(
            
            title: title,
            country: country,
            students: students?.map { $0.domain }
        )
    }
    
    func configure(with domain: Domain.City) {}
}
