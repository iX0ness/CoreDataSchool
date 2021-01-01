//
//  AppDependencyContainer+MainMenuAssembly.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 30/12/2020.
//

import Foundation

protocol MainMenuAssembly {
    func makeMainMenuViewController() -> MainMenuViewController
}

extension AppDependencyContainer: MainMenuAssembly {
    func makeMainMenuViewController() -> MainMenuViewController {
        MainMenuViewController(viewModel: makeMainMenuViewModel())
    }
    
    private func makeMainMenuViewModel() -> MainMenuViewModel {
        MainMenuViewModel(coreDataStack: coreDataStack, assembler: self)
    }
}
