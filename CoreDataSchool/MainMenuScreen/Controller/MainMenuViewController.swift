//
//  MainMenuViewController.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 27/12/2020.
//

import UIKit
import SwiftUI
import CoreData

class MainMenuViewController: UICollectionViewController {
    
    let viewModel: MainMenuViewModelType
    
    init(
        viewModel: MainMenuViewModelType,
        collectionViewLayout layout: UICollectionViewLayout = UICollectionViewFlowLayout()
    ) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: layout)
        collectionView.register(MenuCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(hexString: "#F5F5F5")
        setupNavigationBarAppearance()
    }
}

extension MainMenuViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MenuCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let item = viewModel.outputs.menuItem(at: indexPath)
        cell.setImage(of: item.asset)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.frame.width * 0.4,
            height: collectionView.frame.height * 0.3
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 16,
            left: 24,
            bottom: 0,
            right: 24
        )
    }
}

extension MainMenuViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputs.itemsCount
    }
}

private extension MainMenuViewController {
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
        title = "Home"
    }
}



#if DEBUG
struct VCPreview: PreviewProvider {
    
    static var previews: some View { VCContainerView() }
    
    struct VCContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> MainMenuViewController {
            MainMenuViewController(
                viewModel: MainMenuViewModel(
                    coreDataStack: MockCoreDataStack(
                        managedObjectContext: .init(concurrencyType: .mainQueueConcurrencyType
                        )
                    )
                )
            )
        }
        
        func updateUIViewController(_ uiViewController: MainMenuViewController, context: Context) {}
        typealias UIViewControllerType = MainMenuViewController
    }
    
}




struct MockCoreDataStack: CoreDataStackType {
    var managedObjectContext: NSManagedObjectContext
}
#endif
