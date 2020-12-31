//
//  AppDependencyContainer.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 27/12/2020.
//

import UIKit

class AppDependencyContainer {
    
    lazy var coreDataStack: CoreDataStack = {
        let coreDataStack = CoreDataStack(modelName: "CoreDataSchool")
        return coreDataStack
    }()
    
    
}
