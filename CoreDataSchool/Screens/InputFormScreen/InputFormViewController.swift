//
//  InputFormViewController.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 02/01/2021.
//

import UIKit
import SwiftUI
import Combine

final class InputFormViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = UIColor(hexString: ColorPalette.daisyWhite.hex)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(textFieldsPlaceholders: [String]) {
        self.textFieldsPlaceholders = textFieldsPlaceholders
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
        collectionView.register(InputCollectionViewCell.self)
        collectionView.register(SaveButtonCollectionViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarAppearance()
    }
    
    deinit {
        print("Deinitialized")
    }
    
    private func activateConstraints() {
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
    
    private func constructHierarchy() {
        view.addSubview(collectionView)
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(hexString: ColorPalette.pacificBlue.hex)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(hexString: ColorPalette.pacificBlue.hex)
        ]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Add new"
    }
    
    @objc func save() {
        collectionView.visibleCells.forEach { $0.endEditing(true) }
    }
    
    private let textFieldsPlaceholders: [String]
    private var subscriptions = Set<AnyCancellable>()
}

extension InputFormViewController: UICollectionViewDataSource,
                                   UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return textFieldsPlaceholders.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: InputCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setPlaceholder(textFieldsPlaceholders[indexPath.row])
            //cell.textField.delegate = self
            return cell
        }
        
        let cell: SaveButtonCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        return cell
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
}

//extension InputFormViewController: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard let placeholder = textField.placeholder else { return }
//        if textFieldsPlaceholders.contains(placeholder) {
//            print(textField.text)
//        }
//    }
//    
//}






















final class InputViewController: UINavigationController {
    
    convenience init(textFieldsPlaceholders: [String]) {
        self.init(rootViewController: InputFormViewController(textFieldsPlaceholders: textFieldsPlaceholders))
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG
struct InputFormViewController_Preview: PreviewProvider {
    
    static var previews: some View { VCContainerView() }
    
    struct VCContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> InputFormViewController {
            InputFormViewController(textFieldsPlaceholders: ["1", "2", "3"])
        }
        
        func updateUIViewController(_ uiViewController: InputFormViewController, context: Context) {}
        typealias UIViewControllerType = InputFormViewController
    }
    
}
#endif
