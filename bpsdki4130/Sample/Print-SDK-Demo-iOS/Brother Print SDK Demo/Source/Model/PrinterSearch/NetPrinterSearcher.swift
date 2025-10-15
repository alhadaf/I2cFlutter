//
//  NetPrinterSearcher.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/3/13.
//

import BRLMPrinterKit
import Foundation

class NetPrinterSearcher: IPrinterSearcher {
    private var cancelRoutine: (() -> Void)?
    func start(callback: @escaping(String?, [DiscoveredPrinterInfo]?) -> Void) {
        DispatchQueue.global().async {
            self.cancelRoutine = {
                BRLMPrinterSearcher.cancelNetworkSearch()
            }
            let option = BRLMNetworkSearchOption()
            option.printerList = PrinterModel.allCases.map { $0.searchModelName }
            option.searchDuration = 15
            let searcher = BRLMPrinterSearcher.startNetworkSearch(option) { channel in
                let info = DiscoveredPrinterInfo()
                info.printerItemData.channelType = BRLMChannelType.wiFi
                info.printerItemData.modelName = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyModelName) as? String ?? ""
                info.printerItemData.channelInfo = channel.channelInfo
                info.printerItemData.extraInfo = channel.extraInfo as! Dictionary<String, String>
                DispatchQueue.main.async {
                    callback(nil, [info])
                }
            }
            self.cancelRoutine = nil
            DispatchQueue.main.async {
                callback(searcher.error.code.name, nil)
            }
        }
    }

    func cancel() {
        DispatchQueue.global().async {
            self.cancelRoutine?()
            self.cancelRoutine = nil
        }
    }


}
