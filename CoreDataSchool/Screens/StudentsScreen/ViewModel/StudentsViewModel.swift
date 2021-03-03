//
//  StudentsViewModel.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 02/03/2021.
//

import Foundation

protocol StudentsViewModelInputs {}

protocol StudentsViewModelOutputs {
    var count: Int { get }
}

protocol StudentsViewModelType {
    var inputs: StudentsViewModelInputs { get }
    var outputs: StudentsViewModelOutputs { get }
}

class StudentsViewModel: StudentsViewModelType,
                         StudentsViewModelInputs,
                         StudentsViewModelOutputs {
    
    var count: Int { 5 }
    
    init(databaseManager: StoreObservable) {
        self.databaseManager = databaseManager
    }
    
    private let databaseManager: StoreObservable
    var students: [Domain.Student] = []
    var inputs: StudentsViewModelInputs { self }
    var outputs: StudentsViewModelOutputs { self }
}
