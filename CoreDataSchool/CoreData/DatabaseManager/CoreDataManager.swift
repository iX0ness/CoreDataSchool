//
//  CoreDataManager.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 26/01/2021.
//

import Foundation
import Combine
import CoreData

protocol StoreObservable {
    var didPerformChanges: CurrentValueSubject<Void, Never> { get }
}

class CoreDataManager: StoreObservable {
    let didPerformChanges: CurrentValueSubject<Void, Never> = CurrentValueSubject(())
    let coreDataStack: CoreDataStackType
    
    init(coreDataStack: CoreDataStackType) {
        self.coreDataStack = coreDataStack
        subscribeOnCoreDataStackChanges()
    }
    
    
    private var subscriptions = Set<AnyCancellable>()
    
    private func subscribeOnCoreDataStackChanges() {
        coreDataStack.changesPublisher.sink(receiveCompletion: {
            if case .failure = $0 {
                fatalError("Notification publisher crash")
            }
        }, receiveValue: { _ in
            self.didPerformChanges.send(())
        })
        .store(in: &subscriptions)
    }
}
