//
//  MainMenuViewController.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 27/12/2020.
//

import UIKit
import SwiftUI
import CoreData
import Combine

class MainMenuViewController: UICollectionViewController {

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
        collectionView.backgroundColor = UIColor(hexString: ColorPalette.daisyWhite.hex)
        setupNavigationBarAppearance()
        bind()
    }
    
    private let viewModel: MainMenuViewModelType
    private var subscriptions = Set<AnyCancellable>()
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputs.pushViewController(at: indexPath)
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
    
    func bind() {
        viewModel.outputs.navigationTransition.sink { transition in
            self.navigationController?.pushViewController(
                transition(),
                animated: true
            )
        }.store(in: &subscriptions)
    }
}

#if DEBUG
struct VCPreview: PreviewProvider {
    
    static var previews: some View { VCContainerView() }
    
    struct VCContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> MainMenuViewController {
            MockAppDependencyContainer().makeMainMenuViewController()
        }
        
        func updateUIViewController(_ uiViewController: MainMenuViewController, context: Context) {}
        typealias UIViewControllerType = MainMenuViewController
    }
    
}
#endif
