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
    
    let viewModel: MainMenuViewModel
    
    init(
        viewModel: MainMenuViewModel,
        collectionViewLayout layout: UICollectionViewLayout = UICollectionViewFlowLayout()
    ) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: layout)
        collectionView.register(MenuCollectionViewCell.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        title = "Home"
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
}

extension MainMenuViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MenuCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.backgroundColor = .white
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
        return 5
    }
    
}

#if DEBUG
struct VCPreview: PreviewProvider {
    
    static var previews: some View {
        VCContainerView()
    }
    
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
        
        func updateUIViewController(_ uiViewController: MainMenuViewController, context: Context) {
            
        }
        typealias UIViewControllerType = MainMenuViewController
    }
    
}




struct MockCoreDataStack: CoreDataStackType {
    var managedObjectContext: NSManagedObjectContext
}
#endif
