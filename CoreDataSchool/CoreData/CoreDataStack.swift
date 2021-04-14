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

    init(modelName: String, storeType: StoreType = .persistent) {
        self.modelName = modelName
        self.storeType = storeType
    }
    

    
    private let modelName: String
    private let storeType: StoreType
    
    private lazy var persistentContainer: NSPersistentContainer = {
        configurePersistentContainer()
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
}

private extension CoreDataStack {
    func loadPersistentStore(container: NSPersistentContainer, completion: @escaping () -> Void = {} ) {
        container.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
            completion()
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
    }

    func configurePersistentContainer() -> NSPersistentContainer {
        let persistentContainer = NSPersistentContainer(name: modelName,
                                                        managedObjectModel: managedObjectModel)
        
        let containerDescription = NSPersistentStoreDescription()
        let storeURL = getStoreURL(for: storeType).appendingPathComponent(modelName)
        containerDescription.url = storeURL
        
        persistentContainer.persistentStoreDescriptions = [containerDescription]
        loadPersistentStore(container: persistentContainer)
        return persistentContainer
    }
    
    func getStoreURL(for storeType: StoreType) -> URL {
        switch storeType {
        case .inMemory: return URL(fileURLWithPath: "/dev/null")
        case .persistent: return getDocumentsURL()
        }
    }
    
    func getDocumentsURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
