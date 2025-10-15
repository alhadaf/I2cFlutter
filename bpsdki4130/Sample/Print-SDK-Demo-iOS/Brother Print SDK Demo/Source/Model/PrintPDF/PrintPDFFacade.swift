//
//  PrintPDFFacade.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/3/8.
//

import BRLMPrinterKit
import Foundation

class PrintPDFFacade {

    private var cancelRoutine: (() -> Void)?

    // print PDF with URL
    func printPDFWithURL(info: DiscoveredPrinterInfo, url: URL?, settings: BRLMPrintSettingsProtocol?) -> String {
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
            return NSLocalizedString("create_channel_error", comment: "")
        }
        guard let printSettings = settings, let url = url else {
            return NSLocalizedString("no_print_data", comment: "")
        }
        let credential = PrinterConnectUtil().fetchCurrentChannelCredential(printerInfo: info)
        let generateResult = PrinterConnectUtil().generatePrinterDriver(channel: channel, channelCredential: credential)
        if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
            return OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code)
        }
        let driver = generateResult.driver
        cancelRoutine = {
            driver?.cancelPrinting()
        }
        let printError = driver?.printPDF(with: url, settings: printSettings)
        driver?.closeChannel()
        cancelRoutine = nil
        return PrintErrorModel.fetchPrintErrorCode(error: printError?.code) + "\n\n" +
        (printError?.allLogs.map({ $0.errorDescription }).joined(separator: "\n") ?? "")
    }

    // print PDF with URLs
    func printPDFWithURLs(info: DiscoveredPrinterInfo, urls: [URL]?, settings: BRLMPrintSettingsProtocol?) -> String {
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
            return NSLocalizedString("create_channel_error", comment: "")
        }
        guard let printSettings = settings, let urls = urls else {
            return NSLocalizedString("no_print_data", comment: "")
        }
        let credential = PrinterConnectUtil().fetchCurrentChannelCredential(printerInfo: info)
        let generateResult = PrinterConnectUtil().generatePrinterDriver(channel: channel, channelCredential: credential)
        if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
            return OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code)
        }
        let driver = generateResult.driver
        cancelRoutine = {
            driver?.cancelPrinting()
        }
        let printError = driver?.printPDF(with: urls, settings: printSettings)
        driver?.closeChannel()
        cancelRoutine = nil
        return PrintErrorModel.fetchPrintErrorCode(error: printError?.code) + "\n\n" +
        (printError?.allLogs.map({ $0.errorDescription }).joined(separator: "\n") ?? "")
    }

    // print PRN with Pages
    func printPDFWithPages(
        info: DiscoveredPrinterInfo,
        url: URL?,
        pages: [Int]?,
        settings: BRLMPrintSettingsProtocol?
    ) -> String {
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
            return NSLocalizedString("create_channel_error", comment: "")
        }
        guard let url = url, let pages = pages as? [NSNumber], let printSettings = settings else {
            return NSLocalizedString("no_print_data", comment: "")
        }
        let credential = PrinterConnectUtil().fetchCurrentChannelCredential(printerInfo: info)
        let generateResult = PrinterConnectUtil().generatePrinterDriver(channel: channel, channelCredential: credential)
        if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
            return OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code)
        }
        let driver = generateResult.driver
        cancelRoutine = {
            driver?.cancelPrinting()
        }
        let printError = driver?.printPDF(with: url, pages: pages, settings: printSettings)
        driver?.closeChannel()
        cancelRoutine = nil
        return PrintErrorModel.fetchPrintErrorCode(error: printError?.code) + "\n\n" +
        (printError?.allLogs.map({ $0.errorDescription }).joined(separator: "\n") ?? "")
    }

    // cancel Communication
    func cancelPrinting() {
        DispatchQueue.global().async {
            if let cancelRoutine = self.cancelRoutine {
                cancelRoutine()
            }
            self.cancelRoutine = nil
        }
    }
}
