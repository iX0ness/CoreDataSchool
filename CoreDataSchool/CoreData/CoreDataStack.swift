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
    func performChanges(in completion: @escaping (NSManagedObjectContext) -> Void)
    var viewContextPublisher: NotificationCenter.Publisher { get }
}

final class CoreDataStack: CoreDataStackType {
    
    // MARK: - Properties
    private let modelName: String
    private let storeType: StoreType
    //private let persistentContainer: NSPersistentContainer
    
    
    
    init(modelName: String, storeType: StoreType = .persistent) {
        self.modelName = modelName
        self.storeType = storeType
    }
    
//    func performChanges() {
//        
//    }
    
    func performChanges(in completion: @escaping (NSManagedObjectContext) -> Void = { _ in }) {
        
        
        //DispatchQueue.global().async {
            persistentContainer.performBackgroundTask() { context in
                do {
                    completion(context)
                    print("Current thread (seems to be background): \(Thread.current)")
                    try context.save()
                } catch let error as NSError {
                    context.rollback()
                    print("---Could not save---\n\(error)\n\(error.userInfo)")
                }
                
                self.mainContext.performAndWait {
                    do {
                        print("Current thread (seems to be main): \(Thread.current)")
                        try self.mainContext.save()
                    } catch let error as NSError {
                        self.mainContext.rollback()
                        print("---Could not save---\n\(error)\n\(error.userInfo)")
                    }
                }
                
                
            }
        
        
        //}
        
        
    
        
        
    }
    
    lazy var viewContextPublisher: NotificationCenter.Publisher = {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave,
                                             object: mainContext)
    }()
    
    
    
    // MARK: - Core Data Stack Setup
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()

    lazy var mainContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        //context.parent = backgroundContext
        return context
    }()
    
    
//    private(set) lazy var mainContext: NSManagedObjectContext = {
//        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        managedObjectContext.parent = backgroundContext
//        return managedObjectContext
//    }()
//
//    private(set) lazy var backgroundContext: NSManagedObjectContext = {
//        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
//        return managedObjectContext
//    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let fileManager = FileManager.default
        let storeName = "\(self.modelName)1.sqlite"
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
       configurePersistentContainer()
    }()
    
    
    
}



private extension CoreDataStack {
    func loadPersistentStore(container: NSPersistentContainer, completion: @escaping () -> Void = {}) {
        container.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
            completion()
        }
    }
    
//    func save(_ completion: () -> Void = {}) {
//        guard backgroundContext.hasChanges else { return }
//
//        DispatchQueue.global().async {
//            self.backgroundContext.performAndWait {
//                do {
//                    print("Current thread (seems to be background): \(Thread.current)")
//                    try self.backgroundContext.save()
//
//                } catch let error as NSError {
//                    self.backgroundContext.rollback()
//                    print("---Could not save---\n\(error)\n\(error.userInfo)")
//                }
//            }
//
//            self.mainContext.performAndWait {
//                do {
//                    print("Current thread (seems to be main): \(Thread.current)")
//                    try self.mainContext.save()
//                } catch let error as NSError {
//                    self.mainContext.rollback()
//                    print("---Could not save---\n\(error)\n\(error.userInfo)")
//                }
//            }
//        }
//
//        completion()
//    }
    
    
    
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
