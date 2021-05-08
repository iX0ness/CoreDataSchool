//
//  UIView+ReusableView.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 30/12/2020.
//

import UIKit

public protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}


