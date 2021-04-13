//
//  CoreDataManaged+StudentsManager.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 01/04/2021.
//

import Foundation

protocol StudentsManagerType {
    func saveStudent(_ domain: Domain.Student)
    func getStudents(completion: @escaping ([Domain.Student]) -> Void)
    func getStudent(by id: Int) -> Domain.Student
    func getStudent(by firstname: String) -> [Domain.Student]
    func getStudent(in country: String) -> [Domain.Student]
}

extension CoreDataManager: StudentsManagerType {
    func saveStudent(_ domain: Domain.Student) {
        coreDataStack.performSave { context in
            let student = Student(context: context)
            student.firstname = domain.firstname
            student.lastname = domain.lastname
            student.sex = domain.sex
            student.email = domain.email
            student.city = nil
        }
    }
    
    func getStudents(completion: @escaping ([Domain.Student]) -> Void) {
        coreDataStack.performFetch { context in
            let students = Student.read(in: context).map { $0.domain }
            completion(students)
        }
    }
    
    func getStudent(by id: Int) -> Domain.Student {
        Domain.Student.mock
    }
    
    func getStudent(by firstname: String) -> [Domain.Student] {
        [Domain.Student.mock,
         Domain.Student.mock,
         Domain.Student.mock,
         Domain.Student.mock,
        ]
    }
    
    func getStudent(in country: String) -> [Domain.Student] {
        [Domain.Student.mock,
         Domain.Student.mock,
         Domain.Student.mock,
         Domain.Student.mock,
        ]
    }
}
