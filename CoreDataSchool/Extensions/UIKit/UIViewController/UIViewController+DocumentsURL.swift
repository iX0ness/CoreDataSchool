//
//  UIViewController+DocumentsURL.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 05/02/2021.
//

import UIKit

extension UIViewController {
    var documentsURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
