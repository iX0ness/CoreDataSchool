//
//  NSManagedObject+Managed.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 07/02/2021.
//

import CoreData
import Foundation

protocol Managed: NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] { [] }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
    
    public static func sortedFetchRequest(with predicate: NSPredicate) -> NSFetchRequest<Self> {
        let request = sortedFetchRequest
        request.predicate = predicate
        return request
    }
}

extension Managed where Self: NSManagedObject {
    static var entityName: String { entity().name! }
    
    static func create(in context: NSManagedObjectContext) -> Self {
        insert(entityName: entityName, into: context)
    }
    
    static func read(in context: NSManagedObjectContext, matching predicate: NSPredicate? = nil) -> [Self] {
        fetch(in: context) { request in
            request.predicate = predicate
        }
    }
    
    static func delete(in context: NSManagedObjectContext, matching predicate: NSPredicate? = nil) {
        let fetched =  fetch(in: context, using: { request in
            request.predicate = predicate
        })
        
        guard fetched.count > 0 else { return }
        fetched.forEach { context.delete($0) }
        
    }
}


// MARK: - Helper functions for CRUD operations
extension Managed where Self: NSManagedObject {
    static func insert<Entity: NSManagedObject>(entityName: String, into context: NSManagedObjectContext) -> Entity {
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? Entity else {
            fatalError("Cannot convert to \(entityName)")
        }
        return entity
    }
    
    static func fetch(in context: NSManagedObjectContext, using requestConfigurationCompletion: (NSFetchRequest<Self>) -> Void = { _ in }) -> [Self] {
        let fetchRequest = NSFetchRequest<Self>(entityName: Self.entityName)
        requestConfigurationCompletion(fetchRequest)
        return try! context.fetch(fetchRequest)
    }
}
