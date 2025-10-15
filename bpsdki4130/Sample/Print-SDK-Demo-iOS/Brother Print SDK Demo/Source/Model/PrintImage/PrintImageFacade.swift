//
//  PrintImageFacade.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/3/8.
//

import BRLMPrinterKit
import Foundation

class PrintImageFacade {

    private var cancelRoutine: (() -> Void)?

    // print image with CGImage
    func printImageWithImage(info: DiscoveredPrinterInfo, image: CGImage?, settings: BRLMPrintSettingsProtocol?) -> String {
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
            return NSLocalizedString("create_channel_error", comment: "")
        }
        guard let printSettings = settings, let image = image else {
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
        let printError = driver?.printImage(with: image, settings: printSettings)
        driver?.closeChannel()
        cancelRoutine = nil
        return PrintErrorModel.fetchPrintErrorCode(error: printError?.code) + "\n\n" +
        (printError?.allLogs.map({ $0.errorDescription }).joined(separator: "\n") ?? "")
    }

    // print image with URL
    func printImageWithURL(info: DiscoveredPrinterInfo, url: URL?, settings: BRLMPrintSettingsProtocol?) -> String {
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
        let printError = driver?.printImage(with: url, settings: printSettings)
        driver?.closeChannel()
        cancelRoutine = nil
        return PrintErrorModel.fetchPrintErrorCode(error: printError?.code) + "\n\n" +
        (printError?.allLogs.map({ $0.errorDescription }).joined(separator: "\n") ?? "")
    }

    // print image with URLs
    func printImageWithURLs(info: DiscoveredPrinterInfo, urls: [URL]?, settings: BRLMPrintSettingsProtocol?) -> String {
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
        let printError = driver?.printImage(with: urls, settings: printSettings)
        driver?.closeChannel()
        cancelRoutine = nil
        return PrintErrorModel.fetchPrintErrorCode(error: printError?.code) + "\n\n" +
        (printError?.allLogs.map({ $0.errorDescription }).joined(separator: "\n") ?? "")
    }
    
    // print image with Closures
    func printImageWithClosures(info: DiscoveredPrinterInfo, urls: [URL]?, settings: BRLMPrintSettingsProtocol?) -> String {
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
        var closures = [BRLMPrinterDriver.PrintImageClosure]()
        for url in urls {
            let closure:BRLMPrinterDriver.PrintImageClosure = {
                do {
                    let data = try Data(contentsOf:url)
                    let uiimage = UIImage(data: data)
                    guard let cgimage = uiimage?.cgImage else {return nil}
                    return Unmanaged<CGImage>.passUnretained(cgimage)
                } catch {
                    return nil;
                }
            }
            closures.append(closure)
        }

        let printError = driver?.printImage(withClosures: closures, settings: printSettings)
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
