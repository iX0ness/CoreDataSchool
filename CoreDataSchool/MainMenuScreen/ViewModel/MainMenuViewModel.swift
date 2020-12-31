//
//  MainMenuViewModel.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 30/12/2020.
//

import Foundation

protocol MainMenuViewModelType {
    var inputs: MainMenuViewModelInputs { get }
    var outputs: MainMenuViewModelOutputs { get }
}

protocol MainMenuViewModelInputs {}

protocol  MainMenuViewModelOutputs {
    var itemsCount: Int { get }
    func menuItem(at indexPath: IndexPath) -> MenuItem
}


class MainMenuViewModel: MainMenuViewModelType,
                         MainMenuViewModelInputs,
                         MainMenuViewModelOutputs {
    
    var itemsCount: Int { items.count }
    
    init(coreDataStack: CoreDataStackType) {
        self.coreDataStack = coreDataStack
    }

    func menuItem(at indexPath: IndexPath) -> MenuItem {
        items[indexPath.row]
    }
    
    private let coreDataStack: CoreDataStackType
    private let items = [
        MenuItem(asset: ImageAssets.students.assetTitle),
        MenuItem(asset: ImageAssets.groups.assetTitle),
        MenuItem(asset: ImageAssets.cities.assetTitle),
    ]
    
    var inputs: MainMenuViewModelInputs { return self }
    var outputs: MainMenuViewModelOutputs { return self }
}
