//
//  Constant.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/3/7.
//

import Foundation

enum Constant {
    enum Identifier {
        // ネストが深くなるのを防ぐため中身はExtensionで書く
    }
}

extension Constant.Identifier {
    static let templateIndexKey = "Index"
    static let templateObjectKey = "ObjectName"
    static let templateTextKey = "Text"
    static let templateEndKey = "End"
    static let templateStartKey = "Start template key"
}
