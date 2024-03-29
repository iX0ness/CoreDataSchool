//
//  CitiesViewController.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 01/01/2021.
//

import UIKit
import SwiftUI

class CitiesViewController: UITableViewController, InputFormViewControllerDelegate {

    private let viewModel: CitiesViewModelType
    
    init(viewModel: CitiesViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tableView.register(CityTableViewCell.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarAppearance()
        viewModel.outputs.reloadData = {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CityTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let city = viewModel.outputs.city(at: indexPath)
        cell.configure(with: city)
        return cell
    }
    
    func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(hexString: ColorPalette.pacificBlue.hex)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(hexString: ColorPalette.pacificBlue.hex)
        ]
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        let addBarButtonItem = UIBarButtonItem(systemItem: .add)
        addBarButtonItem.target = self
        addBarButtonItem.action = #selector(showInputFormViewController)
        navigationItem.rightBarButtonItem = addBarButtonItem
        navigationController?.navigationBar.tintColor = UIColor(hexString: ColorPalette.pacificBlue.hex)
        title = "Cities"
    }
    
    @objc func showInputFormViewController() {
        let inputController = InputFormViewController(
            inputConfigurators: [viewModel.outputs.cityTitleInputConfigurator,
                                 viewModel.outputs.cityCountryInputConfigurator,
            ])
        present(inputController, animated: true)
        inputController.delegate = self
        
    }
    
    func didTapSaveFormInputs(inputs: [String : String]) {
        let cityTitle = inputs[viewModel.outputs.cityTitleInputConfigurator.placeholder] ?? "No city title"
        let cityCountry = inputs[viewModel.outputs.cityCountryInputConfigurator.placeholder] ?? "No country title"
        let city = Domain.City(
            title: cityTitle,
            country: cityCountry)
        viewModel.inputs.saveCity(city)
    }
    
}

#if DEBUG
struct CitiesViewController_Preview: PreviewProvider {
    
    static var previews: some View { VCContainerView() }
    
    struct VCContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> CitiesViewController {
            MockAppDependencyContainer().makeCitiesViewController()
        }
        
        func updateUIViewController(_ uiViewController: CitiesViewController, context: Context) {}
        typealias UIViewControllerType = CitiesViewController
    }
    
}
#endif
