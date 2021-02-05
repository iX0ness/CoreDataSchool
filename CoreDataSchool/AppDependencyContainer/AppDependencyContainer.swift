//
//  AppDependencyContainer.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 27/12/2020.
//

import UIKit

class AppDependencyContainer {
    lazy var databaseManager: CoreDataManager = {
        CoreDataManager(coreDataStack: CoreDataStack(modelName: "CoreDataSchool"))
    }()
}
