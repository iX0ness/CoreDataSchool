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
    
    let mockCoreDataStack = MockCoreDataStack()
    
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
    func performSave(_ completion: @escaping (NSManagedObjectContext) -> Void) {}
    func performFetch(_ completion: @escaping (NSManagedObjectContext) -> Void) {}
    var viewContextPublisher: NotificationCenter.Publisher = NotificationCenter.default.publisher(for: .CKAccountChanged)
}

struct MockDatabaseManager: StoreObservable,
                            CitiesManagerType {
    
    let didPerformChanges: CurrentValueSubject<Void, Never> = CurrentValueSubject(())
    
    func saveCity(_ domain: Domain.City) {}
    
    func getCities(completion: @escaping ([Domain.City]) -> Void) {}
    
    func getCity(by id: Int) -> Domain.City {
        Domain.City.mock
    }
    
    func getCity(by title: String) -> [Domain.City] { [] }
    
    func getCity(in country: String) -> [Domain.City] { [] }
    
    
}
#endif
