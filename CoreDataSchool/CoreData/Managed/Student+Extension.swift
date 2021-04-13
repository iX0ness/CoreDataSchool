//
//  Student+Extension.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 01/04/2021.
//

import Foundation
import CoreData

extension Student {
    var domain: Domain.Student {
        Domain.Student(
            firstname: email,
            lastname: firstname,
            email: lastname,
            sex: sex,
            city: city?.domain
            //group: group.domain
        )
    }
    
    func configure(with domain: Domain.Student) {
        firstname = domain.firstname
        lastname = domain.lastname
        email = domain.email
        sex = domain.sex
    }
}
