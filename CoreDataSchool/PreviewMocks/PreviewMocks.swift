//
//  PreviewMocks.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 01/01/2021.
//

import UIKit
import CoreData

#if DEBUG
struct MockAppDependencyContainer: MainMenuAssembly,
                                   CitiesAssembly {
    
    let mockCoreDataStack = MockCoreDataStack(
        mainContext: NSManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType
        )
    )
    
    func makeMainMenuViewController() -> MainMenuViewController {
        MainMenuViewController(
            viewModel: MainMenuViewModel(assembler: self)
        )
    }
    
    func makeCitiesViewController() -> CitiesViewController {
        CitiesViewController(viewModel: CitiesViewModel(databaseManager: MockDatabaseManager()))
    }
    
}

struct MockCoreDataStack: CoreDataStackType {
    var mainContext: NSManagedObjectContext
}

struct MockDatabaseManager: DatabaseManagerType {
    func saveCity(_ city: Domain.City) {}
}
#endif
