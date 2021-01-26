//
//  InputFormViewController.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 02/01/2021.
//

import UIKit
import SwiftUI

protocol InputFormViewControllerDelegate: class {
    func didTapSaveFormInputs(inputs: [String: String])
}

final class InputFormViewController: UIViewController {
    
    weak var delegate: InputFormViewControllerDelegate?
    
    init(inputConfigurators: [FormInputConfigurator]) {
        self.inputConfigurators = inputConfigurators
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: ColorPalette.daisyWhite.hex)
        constructHierarchy()
        activateConstraints()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TextFieldCollectionViewCell.self)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(SaveButtonCollectionViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        print("Deinitialized")
    }
    
    private let inputConfigurators: [FormInputConfigurator]
    private var inputsValues = [String: String]()
    
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = UIColor(hexString: ColorPalette.daisyWhite.hex)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var standaloneItem: UINavigationItem = {
        let navigationItem = UINavigationItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .close)
        navigationItem.titleView = UILabel()
        navigationItem.title = "Add new"
        return navigationItem
    }()
    
    private lazy var standaloneNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.isTranslucent = false
        navigationBar.delegate = self
        navigationBar.backgroundColor = .white
        navigationBar.prefersLargeTitles = true
        navigationBar.items = [standaloneItem]
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(hexString: ColorPalette.pacificBlue.hex)
        ]
        navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor(hexString: ColorPalette.pacificBlue.hex)
        ]
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
}

extension InputFormViewController: TextFieldCollectionViewCellDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, with placeholder: String, and text: String) {
        colorizeOnInput(of: textField, with: placeholder, and: text)
        storeInput(of: textField, with: placeholder, and: text)
    }
    
    func textFiledEditingChanged(_ textField: UITextField, with placeholder: String, and text: String) {
        colorizeOnInput(of: textField, with: placeholder, and: text)
        storeInput(of: textField, with: placeholder, and: text)
    }
    
    private func storeInput(of textField: UITextField, with placeholder: String, and text: String) {
        guard let _ = inputConfigurators.first(where: { $0.placeholder == placeholder }) else { return }
        inputsValues[placeholder] = text
    }
    
    private func colorizeOnInput(of textField: UITextField, with placeholder: String, and text: String) {
        guard let inputConfigurator = inputConfigurators.first(where: { $0.placeholder == placeholder }) else { return }
        if let _ = inputConfigurator.validator.validated(text) {
            textField.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            textField.layer.borderColor = UIColor.red.cgColor
        }
    }
}

// MARK: - CollectionViewDelegate CollectionViewDataSource

extension InputFormViewController: UICollectionViewDataSource,
                                   UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return inputConfigurators.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let inputCell = dequeueInputCell(at: indexPath, for: inputConfigurators)
            return inputCell
        }
        
        let buttonCell: SaveButtonCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        buttonCell.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        return buttonCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height * 0.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets.zero
        }
        
        return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    func dequeueInputCell(at indexPath: IndexPath, for textFieldPlaceholders: [FormInputConfigurator]) -> UICollectionViewCell {
        switch textFieldPlaceholders[indexPath.row].cellType {
        
        case .textField:
            let cell: TextFieldCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setPlaceholder(inputConfigurators[indexPath.row].placeholder)
            cell.delegate = self
            return cell
            
            
        default: fatalError("Should be able to dequeue cell")
        }
    }
}

// MARK: - Setup UI

private extension InputFormViewController {
    func constructHierarchy() {
        view.addSubview(standaloneNavigationBar)
        view.addSubview(collectionView)
    }
    
    func activateConstraints() {
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: standaloneNavigationBar.bottomAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            standaloneNavigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            standaloneNavigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            standaloneNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
}

extension InputFormViewController: UINavigationBarDelegate {
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

private extension InputFormViewController {
    @objc func save() {
        guard let configurator = inputConfigurators.first(where: {
            $0.validator.validated(inputsValues[$0.placeholder] ?? "") == nil
        }) else {
            delegate?.didTapSaveFormInputs(inputs: inputsValues)
            return
        }
        
        alert(text: "Invalid input",
              message: "Filed \(configurator.placeholder) has invalid input")
    }
}


#if DEBUG
struct InputFormViewController_Preview: PreviewProvider {
    
    static var previews: some View { VCContainerView() }
    
    struct VCContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> InputFormViewController {
            InputFormViewController(inputConfigurators: [ FormInputConfigurator(placeholder: "Title",
                                                                                validator: VaildatorFactory.validatorFor(type: .requiredField(validatorType: .localityAlias)),
                                                                                cellType: .textField),
                                                          FormInputConfigurator(placeholder: "Country",
                                                                                validator: VaildatorFactory.validatorFor(type: .requiredField(validatorType: .localityAlias)),
                                                                                cellType: .textField)
                                                          
            ])
        }
        
        func updateUIViewController(_ uiViewController: InputFormViewController, context: Context) {}
        typealias UIViewControllerType = InputFormViewController
    }
    
}
#endif
