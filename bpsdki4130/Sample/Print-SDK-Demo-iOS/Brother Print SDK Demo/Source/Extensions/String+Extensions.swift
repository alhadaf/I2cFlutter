//
//  String+Extensions.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/3/30.
//

import Foundation

extension String {
    func isNumberListString() -> Bool {
        var result = true
        for key in self.components(separatedBy: ";") {
            guard Int(key) != nil else {
                result = false
                break
            }
        }
        return result
    }
    
    func getNumberListString() -> [Int] {
    var keyList: [Int] = []
        self.components(separatedBy: ";").forEach({ key in
            if let key = Int(key) {
                keyList.append(key)
            }
        })
        return keyList
    }
}
