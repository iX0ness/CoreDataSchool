//
//  UITextField+ContentPadding.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 18/01/2021.
//

import UIKit

extension UITextField {
    func setLeftPadding(_ value: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
