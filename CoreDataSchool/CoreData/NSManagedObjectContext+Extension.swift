//
//  NSManagedObjectContext+Extension.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 14/04/2021.
//

import Foundation
import CoreData


extension NSManagedObjectContext {
    
    /// Checks whether there are actually changes that will change the persistent store.
    /// The `hasChanges` method would return `true` for transient changes as well which can lead to false positives.
    private var hasPersistentChanges: Bool {
        return !insertedObjects.isEmpty || !deletedObjects.isEmpty || updatedObjects.contains(where: { $0.hasPersistentChangedValues })
    }
    
    /// Saves the context, only if it has any changes and if it has a place to save the changes to (parent or persistent store). Calling this method instead of the regular save() will increase performance. It is also useful to use this function when having a memory store, since this configuration doesn't have a persistent store but may use parent contexts to save their changes to.
    /// - throws: A Core Data NSError when saving fails.
    /// - returns: Whether the save was needed.
    @discardableResult
    public func saveIfNeeded() -> Bool {
        let hasPurpose = parent != nil || persistentStoreCoordinator?.persistentStores.isEmpty == false
        guard hasPersistentChanges && hasPurpose else {
            // Saving won't do anything now, except for decreasing performance. Skip it for now.
            return false
        }
        
        return saveOrRollback()
    }
    
    private func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            print("❌ Got exception from Core Data while saving: \(error) ❌")
            rollback()
            return false
        }
    }
}

