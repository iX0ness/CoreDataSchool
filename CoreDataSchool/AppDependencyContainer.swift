//
//  AppDependencyContainer.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 27/12/2020.
//

import Foundation

class AppDependencyContainer {
    
    lazy var coreDataStack: CoreDataStack = {
        let coreDataStack = CoreDataStack(modelName: "CoreDataSchool")
        return coreDataStack
    }()
    
    func makeStartViewController() -> ViewController {
        let viewController = ViewController(coreDataStack: coreDataStack)
        return viewController
    }
}
