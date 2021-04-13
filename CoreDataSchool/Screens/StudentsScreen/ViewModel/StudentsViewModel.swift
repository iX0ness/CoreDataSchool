//
//  StudentsViewModel.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 02/03/2021.
//

import Foundation
import Combine

protocol StudentsViewModelInputs {
    func saveStudent(_ student: Domain.Student)
}

protocol StudentsViewModelOutputs {
    var count: Int { get }
    var reloadData: (() -> Void)? { get set }
    var firstnameInputConfigurator: FormInputConfigurator { get }
    var lastnameInputConfigurator: FormInputConfigurator { get }
    var emailInputConfigurator: FormInputConfigurator { get }
    func student(at indexPath: IndexPath) -> Domain.Student
    
}

protocol StudentsViewModelType {
    var inputs: StudentsViewModelInputs { get }
    var outputs: StudentsViewModelOutputs { get }
}

class StudentsViewModel: StudentsViewModelType,
                         StudentsViewModelInputs,
                         StudentsViewModelOutputs {

    let firstnameInputConfigurator = FormInputConfigurator(
        placeholder: "First name",
        validator: ValidatorFactory.validatorFor(type: .requiredField(validatorType: .personAlias)),
        cellType: .textField)
    
    let lastnameInputConfigurator = FormInputConfigurator(
        placeholder: "Last name",
        validator: ValidatorFactory.validatorFor(type: .requiredField(validatorType: .personAlias)),
        cellType: .textField)
    
    let emailInputConfigurator = FormInputConfigurator(
        placeholder: "Email",
        validator: ValidatorFactory.validatorFor(type: .email),
        cellType: .textField)
    
    var reloadData: (() -> Void)?
    var count: Int { students.count }
    
    func student(at indexPath: IndexPath) -> Domain.Student {
        students[indexPath.row]
    }
    
    init(databaseManager: StoreObservable & StudentsManagerType) {
        self.databaseManager = databaseManager
        databaseManager.didPerformChanges
            .sink(receiveValue: {
                print("saved notification fired")
                self.databaseManager.getStudents { students in
                    self.students = students
                }
                self.reloadData?()
            })
            .store(in: &subscriptions)
    }
    
    func saveStudent(_ student: Domain.Student) {
        databaseManager.saveStudent(student)
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private let databaseManager: StoreObservable & StudentsManagerType
    private var students: [Domain.Student] = []
    
    var inputs: StudentsViewModelInputs { self }
    var outputs: StudentsViewModelOutputs { self }
}
