//
//  IPrinterSearcher.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/3/13.
//

import BRLMPrinterKit
import Foundation

protocol IPrinterSearcher {
    func start(callback: @escaping(String?, [DiscoveredPrinterInfo]?) -> Void)
    func cancel()
}
