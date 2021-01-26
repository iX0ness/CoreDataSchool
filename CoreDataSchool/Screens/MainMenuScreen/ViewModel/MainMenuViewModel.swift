//
//  MainMenuViewModel.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 30/12/2020.
//

import UIKit
import Combine

protocol MainMenuViewModelType {
    var inputs: MainMenuViewModelInputs { get }
    var outputs: MainMenuViewModelOutputs { get }
}

protocol MainMenuViewModelInputs {
    func pushViewController(at indexPath: IndexPath) 
}

protocol  MainMenuViewModelOutputs {
    var navigationTransition: PassthroughSubject<() -> UIViewController, Never> { get }
    var itemsCount: Int { get }
    func menuItem(at indexPath: IndexPath) -> MenuItem
}


class MainMenuViewModel: MainMenuViewModelType,
                         MainMenuViewModelInputs,
                         MainMenuViewModelOutputs {
    
    let navigationTransition: PassthroughSubject<() -> UIViewController, Never> = PassthroughSubject()
    var itemsCount: Int { items.count }
    
    init(assembler: CitiesAssembly) {
        self.assembler = assembler
    }

    func menuItem(at indexPath: IndexPath) -> MenuItem {
        items[indexPath.row]
    }
    
    func pushViewController(at indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            navigationTransition.send(
                assembler.makeCitiesViewController
            )
        default: break
        }
    }
    
    private let assembler: CitiesAssembly
    private let items = [
        MenuItem(asset: ImageAssets.students.assetTitle),
        MenuItem(asset: ImageAssets.groups.assetTitle),
        MenuItem(asset: ImageAssets.cities.assetTitle),
    ]
    
    var inputs: MainMenuViewModelInputs { return self }
    var outputs: MainMenuViewModelOutputs { return self }
}
