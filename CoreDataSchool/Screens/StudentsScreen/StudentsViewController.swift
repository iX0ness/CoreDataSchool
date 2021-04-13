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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarAppearance()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StudentTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let student = viewModel.outputs.student(at: indexPath)
        cell.configure(with: student)
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
        title = "Students"
    }
    
    @objc func showInputFormViewController() {
        let inputController = InputFormViewController(
            inputConfigurators: [viewModel.outputs.firstnameInputConfigurator,
                                 viewModel.outputs.lastnameInputConfigurator,
                                 viewModel.outputs.emailInputConfigurator,
            ])
        present(inputController, animated: true)
        inputController.delegate = self
        
    }
    
    func didTapSaveFormInputs(inputs: [String : String]) {
        let firstname = inputs[viewModel.outputs.firstnameInputConfigurator.placeholder] ?? "No firstname"
        let lastname = inputs[viewModel.outputs.lastnameInputConfigurator.placeholder] ?? "No lastname"
        let email = inputs[viewModel.outputs.lastnameInputConfigurator.placeholder] ?? "No email"
        let student = Domain.Student(firstname: firstname,
                                     lastname: lastname,
                                     email: email,
                                     sex: "M",
                                     city: Domain.City.mock)
        
        viewModel.inputs.saveStudent(student)
    }
}
