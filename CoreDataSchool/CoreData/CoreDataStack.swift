//
//  CoreDataManager.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 27/12/2020.
//

import Foundation
import CoreData

enum StoreType {
    case persistent
    case inMemory
}

protocol CoreDataStackType {
    var mainContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }
    var changesPublisher: NotificationCenter.Publisher { get }
}

final class CoreDataStack: CoreDataStackType {
    
    lazy var changesPublisher: NotificationCenter.Publisher = {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange,
                                             object: mainContext)
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()

    init(storeType: StoreType = .persistent) {
        self.storeType = storeType
        persistentContainer = NSPersistentContainer(
            name: DataModelConfig.modelName,
            managedObjectModel: managedObjectModel
        )
        
        setup()
    }
    

    

    private let storeType: StoreType
    private let persistentContainer: NSPersistentContainer
}

private extension CoreDataStack {
    func setup() {
        if case .inMemory = self.storeType {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("\(Self.self) Failed loading persistent store: \(description) error: \(error)")
                fatalError("\(Self.self) non recoverable error")
            } else {
                print("\(Self.self) loaded persistent store: \(description)")
            }
        }
    }
}

fileprivate var managedObjectModel: NSManagedObjectModel = {
    guard let modelURL = Bundle.main.url(
            forResource: DataModelConfig.modelName,
            withExtension: DataModelConfig.fileExtension) else {
        fatalError("Unable to Find Data Model")
    }
    
    guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
        fatalError("Unable to Load Data Model")
    }
    
    return managedObjectModel
}()

fileprivate enum DataModelConfig {
    static let modelName = "CoreDataSchool"
    static let fileExtension = "momd"
}
