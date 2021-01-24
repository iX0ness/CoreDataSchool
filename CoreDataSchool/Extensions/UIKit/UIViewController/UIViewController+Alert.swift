//
//  UIViewController+Alert.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 24/01/2021.
//

import UIKit

extension UIViewController {
    func alert(text : String, message : String) {
        let alert = UIAlertController(title: text, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Got it", style: UIAlertAction.Style.default, handler: nil))
        //Add more actions as you see fit
        self.present(alert, animated: true, completion: nil)
    }
}


