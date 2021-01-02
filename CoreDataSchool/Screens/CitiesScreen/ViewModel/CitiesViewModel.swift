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
protocol CitiesViewModelInputs {}
protocol CitiesViewModelOutputs {
    var count: Int { get }
    func city(at indexPath: IndexPath) -> MockCity
}

class CitiesViewModel: CitiesViewModelType,
                       CitiesViewModelInputs,
                       CitiesViewModelOutputs {
    
    var count: Int { cities.count }
    
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
