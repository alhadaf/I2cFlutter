//
//  TemplateKeyViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/8.
//

import BRLMPrinterKit
import Foundation

class TemplateKeyViewModel: ObservableObject {
    @Published var printerInfo: DiscoveredPrinterInfo?
    @Published var keyList: [Int] = []
    
    func setKeyList(number: String) -> Bool {
        keyList = []
        var result = true
        number.components(separatedBy: ";").forEach({ key in
            if let key = Int(key) {
                keyList.append(key)
            } else {
                result = false
            }
        })
        return result
    }
}
