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
        managedObjectContext: NSManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType
        )
    )
    
    func makeMainMenuViewController() -> MainMenuViewController {
        MainMenuViewController(
            viewModel: MainMenuViewModel(
                coreDataStack: mockCoreDataStack,
                assembler: self
            )
        )
    }
    
    func makeCitiesViewController() -> CitiesViewController {
        CitiesViewController(viewModel: CitiesViewModel())
    }
    
}

struct MockCoreDataStack: CoreDataStackType {
    var managedObjectContext: NSManagedObjectContext
}
#endif
