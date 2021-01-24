//
//  NSRegularExpression+Match.swift
//  CoreDataSchool
//
//  Created by Mykhaylo Levchuk on 18/01/2021.
//

import Foundation

extension NSRegularExpression {
    convenience init(_ regex: String) {
        try! self.init(pattern: regex, options: [.caseInsensitive])
    }
    
    func isMatching(_ string: String) -> Bool {
        firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) != nil
    }
}
