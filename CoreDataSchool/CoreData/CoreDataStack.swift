//
//  CoreDataManager.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 27/12/2020.
//

import Foundation
import CoreData

protocol CoreDataStackType {
    var mainContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }
    func performChanges()
    var viewContextPublisher: NotificationCenter.Publisher { get }
}

final class CoreDataStack: CoreDataStackType {
    
    // MARK: - Properties
    private let modelName: String
    
    // MARK: - Initialization
    init(modelName: String) {
        self.modelName = modelName
    }
    
    func performChanges() {
        save()
    }
    
    lazy var viewContextPublisher: NotificationCenter.Publisher = {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave,
                                             object: mainContext)
    }()
    
    private func save(_ completion: () -> Void = {}) {
        guard backgroundContext.hasChanges else { return }
        
        DispatchQueue.global().async {
            self.backgroundContext.performAndWait {
                do {
                    print("Current thread (seems to be background): \(Thread.current)")
                    try self.backgroundContext.save()
                    
                } catch let error as NSError {
                    self.backgroundContext.rollback()
                    print("---Could not save---\n\(error)\n\(error.userInfo)")
                }
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
        
        completion()
    }
    
    // MARK: - Core Data Stack Setup
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = backgroundContext
        return managedObjectContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
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
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
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
    
}



