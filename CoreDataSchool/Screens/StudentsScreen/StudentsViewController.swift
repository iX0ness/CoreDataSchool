//
//  StudentsViewController.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 02/03/2021.
//

import UIKit

class StudentsViewController: UITableViewController, InputFormViewControllerDelegate {
    
    private let viewModel: StudentsViewModelType
    
    init(viewModel: StudentsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tableView.register(StudentTableViewCell.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.outputs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StudentTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//        let city = viewModel.outputs.city(at: indexPath)
//        cell.configure(with: city)
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
            inputConfigurators: [])
        present(inputController, animated: true)
        inputController.delegate = self
        
    }
    
    func didTapSaveFormInputs(inputs: [String : String]) {
        
    }
}
