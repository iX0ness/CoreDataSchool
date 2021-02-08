//
//  PreviewMocks.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 01/01/2021.
//

import UIKit
import CoreData
import Combine

#if DEBUG
struct MockAppDependencyContainer: MainMenuAssembly,
                                   CitiesAssembly {
    
    let mockCoreDataStack = MockCoreDataStack(
        mainContext: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType),
        backgroundContext: NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
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
    var viewContextPublisher: NotificationCenter.Publisher = NotificationCenter.default.publisher(for: .CKAccountChanged)
    
    func performChanges(_ callback: () -> Void) {}
    func performChanges() {}
    
    var mainContext: NSManagedObjectContext
    var backgroundContext: NSManagedObjectContext
}

struct MockDatabaseManager: StoreObservable,
                            CitiesManagerType {

    let didPerformChanges: CurrentValueSubject<Void, Never> = CurrentValueSubject(())
    
    func saveCity(_ domain: Domain.City) {}
    
    func getCities() -> [Domain.City] { [] }
    
    func getCity(by id: Int) -> Domain.City {
        Domain.City.mock
    }
    
    func getCity(by title: String) -> [Domain.City] { [] }
    
    func getCity(in country: String) -> [Domain.City] { [] }
    
    
}
#endif
