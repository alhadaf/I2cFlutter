//
//  PrintTemplateFacade.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/3/7.
//

import BRLMPrinterKit
import Foundation

class PrintTemplateFacade {
    
    private var cancelRoutine: (() -> Void)?

    func startPrint( // swiftlint:disable:this function_body_length
        printerInfo: DiscoveredPrinterInfo,
        key: String,
        printSettings: BRLMTemplatePrintSettingsProtocol?,
        replaceItem: [ReplaceData]) -> String {
            guard let key = UInt(key) else {
                return NSLocalizedString("no_print_data", comment: "")
            }
            guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: printerInfo) else {
                return NSLocalizedString("create_channel_error", comment: "")
            }
            guard let printSettings = printSettings else {
                return NSLocalizedString("no_print_data", comment: "")
            }
            var replacers: [BRLMTemplateObjectReplacer] = []
            for item in replaceItem {
                switch item.type {
                case .index:
                    replacers.append(BRLMTemplateObjectReplacer(objectIndex: UInt(item.key) ?? 0,
                                                                value: item.value,
                                                                encode: item.encode.brlmTemplateObjectEncode))
                case .objectName:
                    replacers.append(BRLMTemplateObjectReplacer(objectName: item.key,
                                                                value: item.value,
                                                                encode: item.encode.brlmTemplateObjectEncode))
                }
            }
            let credential = PrinterConnectUtil().fetchCurrentChannelCredential(printerInfo: printerInfo)
            let generateResult = PrinterConnectUtil().generatePrinterDriver(channel: channel, channelCredential: credential)
            if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
                return OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code)
            }
            self.cancelRoutine = {
                generateResult.driver?.cancelPrinting()
                generateResult.driver?.closeChannel()
            }
            let printError = generateResult.driver?.printTemplate(withKey: key, settings: printSettings, replacers: replacers)
            self.cancelRoutine = nil
            generateResult.driver?.closeChannel()
            return PrintErrorModel.fetchPrintErrorCode(error: printError?.code)
        }

    // cancel communication
    func cancelPrinting() {
        DispatchQueue.global().async {
            if let cancelRoutine = self.cancelRoutine {
                cancelRoutine()
            }
            self.cancelRoutine = nil
        }
    }
}
