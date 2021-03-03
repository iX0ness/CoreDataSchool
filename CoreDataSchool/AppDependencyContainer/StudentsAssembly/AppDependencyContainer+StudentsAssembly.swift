//
//  AppDependencyContainer+StudentsAssembly.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 03/03/2021.
//

import Foundation

protocol StudentsAssembly {
    func makeStudentsViewController() -> StudentsViewController
}

extension AppDependencyContainer: StudentsAssembly {
    func makeStudentsViewController() -> StudentsViewController {
        StudentsViewController(viewModel: makeStudentsViewModel())
    }
    
    private func makeStudentsViewModel() -> StudentsViewModel {
        StudentsViewModel(databaseManager: databaseManager)
    }
}
