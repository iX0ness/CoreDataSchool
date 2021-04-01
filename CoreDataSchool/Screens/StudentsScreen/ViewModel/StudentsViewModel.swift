//
//  StudentsViewModel.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 02/03/2021.
//

import Foundation

protocol StudentsViewModelInputs {
    func saveStudent(_ city: Domain.Student)
}

protocol StudentsViewModelOutputs {
    var firstnameInputConfigurator: FormInputConfigurator { get }
    var lastnameInputConfigurator: FormInputConfigurator { get }
    var emailInputConfigurator: FormInputConfigurator { get }
    var count: Int { get }
}

protocol StudentsViewModelType {
    var inputs: StudentsViewModelInputs { get }
    var outputs: StudentsViewModelOutputs { get }
}

class StudentsViewModel: StudentsViewModelType,
                         StudentsViewModelInputs,
                         StudentsViewModelOutputs {
    func saveStudent(_ city: Domain.Student) {
    
    }
    
    
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
    
    var count: Int { 5 }
    
    init(databaseManager: StoreObservable) {
        self.databaseManager = databaseManager
    }
    
    private let databaseManager: StoreObservable
    var students: [Domain.Student] = []
    var inputs: StudentsViewModelInputs { self }
    var outputs: StudentsViewModelOutputs { self }
}
