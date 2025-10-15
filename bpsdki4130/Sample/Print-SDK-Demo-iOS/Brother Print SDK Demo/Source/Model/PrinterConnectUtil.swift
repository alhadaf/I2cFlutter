//
//  PrinterConnectUtil.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/22.
//

import BRLMPrinterKit
import Foundation

class PrinterConnectUtil {

    func fetchCurrentChannel(printerInfo: DiscoveredPrinterInfo) -> BRLMChannel? {
        switch printerInfo.printerItemData.channelType {
        case .bluetoothMFi:
            return BRLMChannel(bluetoothSerialNumber: printerInfo.printerItemData.channelInfo)
        case .wiFi:
            return BRLMChannel(wifiIPAddress: printerInfo.printerItemData.channelInfo)
        case .bluetoothLowEnergy:
            return BRLMChannel(bleLocalName: printerInfo.printerItemData.channelInfo)
        @unknown default:
            return nil
        }
    }
    
    func fetchCurrentChannelCredential(printerInfo: DiscoveredPrinterInfo) -> BRLMChannelCredential? {
        guard let password = printerInfo.password else {return nil}
        return BRLMChannelCredential.init(printerAdminPassword: password)
    }

    func generatePrinterDriver(channel: BRLMChannel, channelCredential: BRLMChannelCredential?) -> BRLMPrinterDriverGenerateResult {
        if let credential = channelCredential {
            return BRLMPrinterDriverGenerator.open(channel, with: credential)
        } else {
            return BRLMPrinterDriverGenerator.open(channel)
        }
    }
}
