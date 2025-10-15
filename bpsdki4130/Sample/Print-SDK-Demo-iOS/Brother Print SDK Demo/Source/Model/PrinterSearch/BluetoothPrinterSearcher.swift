//
//  BluetoothPrinterSearcher.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/3/13.
//

import BRLMPrinterKit
import Foundation

class BluetoothPrinterSearcher: IPrinterSearcher {
    func start(callback: @escaping (String?, [DiscoveredPrinterInfo]?) -> Void) {
        DispatchQueue.global().async {
            let searcher = BRLMPrinterSearcher.startBluetoothSearch()
            let list = searcher.channels.map({
                let info = DiscoveredPrinterInfo()
                info.printerItemData.channelType = BRLMChannelType.bluetoothMFi
                info.printerItemData.modelName = $0.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyModelName) as? String ?? ""
                info.printerItemData.channelInfo = $0.channelInfo
                info.printerItemData.extraInfo = $0.extraInfo as! Dictionary<String, String>
                return info
            })
            DispatchQueue.main.async {
                callback(searcher.error.code.name, list)
            }
        }
    }

    func cancel() {
        // ignore
    }
}
