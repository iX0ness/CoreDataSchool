//
//  CitiesViewModel.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 01/01/2021.
//

import Foundation

protocol CitiesViewModelType {
    var inputs: CitiesViewModelInputs { get }
    var outputs: CitiesViewModelOutputs { get }
}
protocol CitiesViewModelInputs {
    func saveCity(_ city: Domain.City)
}
protocol CitiesViewModelOutputs {
    var count: Int { get }
    var cityTitleInputConfigurator: FormInputConfigurator { get }
    var cityCountryInputConfigurator: FormInputConfigurator { get }
    func city(at indexPath: IndexPath) -> MockCity
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
    
    init(databaseManager: DatabaseManagerType) {
        self.databaseManager = databaseManager
    }
    
    func saveCity(_ city: Domain.City) {
        databaseManager.saveCity(city)
    }
    
    
    private let databaseManager: DatabaseManagerType
    private let cities = [
        MockCity(title: "Kyiv", country: "Ukraine"),
        MockCity(title: "Vienna", country: "Austria"),
        MockCity(title: "Prague", country: "Czech Republic"),
    ]
    
    func city(at indexPath: IndexPath) -> MockCity {
        return cities[indexPath.row]
    }
    
    // TODO: add repository to view model
    
    
    
    var inputs: CitiesViewModelInputs { return self }
    var outputs: CitiesViewModelOutputs { return self }
    
}
