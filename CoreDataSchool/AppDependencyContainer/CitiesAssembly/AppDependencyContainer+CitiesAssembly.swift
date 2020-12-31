//
//  AppDependencyContainer+CitiesAssembly.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 01/01/2021.
//

import Foundation

protocol CitiesAssembly {
    func makeCitiesViewController() -> CitiesViewController
}

extension AppDependencyContainer: CitiesAssembly {
    func makeCitiesViewController() -> CitiesViewController {
        CitiesViewController(viewModel: makeCitiesViewModel())
    }
    
    private func makeCitiesViewModel() -> CitiesViewModel {
        CitiesViewModel()
    }
}
