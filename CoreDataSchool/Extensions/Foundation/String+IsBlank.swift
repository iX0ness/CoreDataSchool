//
//  String+IsBlank.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 16/01/2021.
//

import Foundation

extension String {
    var isBlank: Bool {
      return allSatisfy({ $0.isWhitespace })
    }
}
