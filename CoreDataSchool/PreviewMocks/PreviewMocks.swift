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
                                   CitiesAssembly, StudentsAssembly {
    
    
    
    let mockCoreDataStack = MockCoreDataStack()
    
    func makeMainMenuViewController() -> MainMenuViewController {
        MainMenuViewController(
            viewModel: MainMenuViewModel(assembler: self)
        )
    }
    
    func makeCitiesViewController() -> CitiesViewController {
        CitiesViewController(viewModel: CitiesViewModel(databaseManager: MockDatabaseManager()))
    }
    
    func makeStudentsViewController() -> StudentsViewController {
        StudentsViewController(viewModel: StudentsViewModel(databaseManager: MockDatabaseManager()))
    }
    
}

struct MockCoreDataStack: CoreDataStackType {
    var mainContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    var backgroundContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    var changesPublisher: NotificationCenter.Publisher = NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)
    
    
    
}

struct MockDatabaseManager: StoreObservable,
                            CitiesManagerType,
                            StudentsManagerType {
    func saveStudent(_ domain: Domain.Student) {}
    
    func getStudents(completion: @escaping ([Domain.Student]) -> Void) {}
    
    func getStudent(by id: Int) -> Domain.Student { Domain.Student.mock }
    
    func getStudent(by firstname: String) -> [Domain.Student] { [] }
    
    func getStudent(in country: String) -> [Domain.Student] { [] }
    
    
    let didPerformChanges: CurrentValueSubject<Void, Never> = CurrentValueSubject(())
    
    func saveCity(_ domain: Domain.City) {}
    
    func getCities(completion: @escaping ([Domain.City]) -> Void) {}
    
    func getCity(by id: Int) -> Domain.City {
        Domain.City.mock()
    }
    
    func getCity(by title: String) -> [Domain.City] { [] }
    
    func getCity(in country: String) -> [Domain.City] { [] }
    
    
}
#endif
