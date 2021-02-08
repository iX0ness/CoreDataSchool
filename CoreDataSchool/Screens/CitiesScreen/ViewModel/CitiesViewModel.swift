//
//  CitiesViewModel.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 01/01/2021.
//

import Foundation
import Combine

protocol CitiesViewModelType {
    var inputs: CitiesViewModelInputs { get }
    var outputs: CitiesViewModelOutputs { get }
}
protocol CitiesViewModelInputs {
    func saveCity(_ city: Domain.City)
}
protocol CitiesViewModelOutputs: AnyObject {
    var count: Int { get }
    var reloadData: (() -> Void)? { get set }
    var cityTitleInputConfigurator: FormInputConfigurator { get }
    var cityCountryInputConfigurator: FormInputConfigurator { get }
    func city(at indexPath: IndexPath) -> Domain.City
}

class CitiesViewModel: CitiesViewModelType,
                       CitiesViewModelInputs,
                       CitiesViewModelOutputs {
    
    let cityTitleInputConfigurator = FormInputConfigurator(
        placeholder: "Title",
        validator: VaildatorFactory.validatorFor(type: .requiredField(validatorType: .localityAlias)),
        cellType: .textField)
    
    let cityCountryInputConfigurator = FormInputConfigurator(
        placeholder: "Country",
        validator: VaildatorFactory.validatorFor(type: .requiredField(validatorType: .localityAlias)),
        cellType: .textField)
    
    var count: Int { cities.count }
    var reloadData: (() -> Void)?
    
    init(databaseManager: StoreObservable & CitiesManagerType) {
        self.databaseManager = databaseManager
        databaseManager.didPerformChanges
            .sink(receiveValue: { _ in
                print("saved notification fired")
                self.cities = self.databaseManager.getCities()
                self.reloadData?()
            })
            .store(in: &subscriptions)
        
    }
    
    func saveCity(_ city: Domain.City) {
        databaseManager.saveCity(city)
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private let databaseManager: StoreObservable & CitiesManagerType
    private var cities: [Domain.City] = []
    
    
    
    func city(at indexPath: IndexPath) -> Domain.City {
        return cities[indexPath.row]
    }
    
    // TODO: add repository to view model
    
    var inputs: CitiesViewModelInputs { return self }
    var outputs: CitiesViewModelOutputs { return self }
}
