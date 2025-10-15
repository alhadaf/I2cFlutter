//
//  TransferFilesViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/29.
//

import Foundation
import SwiftUI
import UIKit
import UniformTypeIdentifiers
import BRLMPrinterKit

class TransferFilesViewController: UIViewController {
    private var dataSource = TransferFilesViewModel()
    private var selectPickerCallback: (([URL]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = TransferFilesView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        title = NSLocalizedString("transfer_files", comment: "")
    }

    func showTransferConfirmAlert(title: String, filePaths: [String], callback: @escaping () -> Void) {
        let alertController = UIAlertController(title: title,
                                                message: filePaths.joined(separator: "\n"), preferredStyle: .alert)

        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: NSLocalizedString("transfer", comment: ""), style: .default, handler: { _ in
            let alertController = UIAlertController(title: " ",
                                                    message: NSLocalizedString("preparing", comment: ""), preferredStyle: .alert)
            
            let rect = CGRect(x: 8.0, y: 24.0, width: 250.0, height: 20.0)
            let progressView = UIProgressView(frame: rect)
            progressView.progress = 0.0
            alertController.view.addSubview(progressView)
            
            self.dataSource.progressCallback = {(object:AnyObject, progressPercentage:Int) -> Void in
                DispatchQueue.main.async {
                    progressView.progress = Float(progressPercentage)/100.0
                    alertController.message = object.description()
                }
            }
            
            self.present(alertController, animated: true)
            
            DispatchQueue.global().async {
                callback()
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }

    private func showResult(result: String) {
        DispatchQueue.main.async {
            if let alert = self.presentedViewController as? UIAlertController {
                alert.dismiss(animated: false) {
                    let viewController = ResultViewController()
                    viewController.dataSource.resultMessage = result
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    private func showFilePicker() {
        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: true)
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        }
        picker?.delegate = self
        picker?.allowsMultipleSelection = true;
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }


    private func showConnectionAlertIfNeeded() -> Bool {
        if dataSource.printerInfo == nil {
            let alert = CommonAlertUtil.connectPrinterAlert()
            self.present(alert, animated: true)
            return false
        }
        return true
    }
}

extension TransferFilesViewController: TransferFilesViewDelegate {

    func selectPrinterButtonDidTap() {
        let viewController = PrinterInterfaceViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func transferFirmwareFilesDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            self.showTransferConfirmAlert(title: NSLocalizedString("transferFirmwareFiles", comment: ""), filePaths: urls.map{$0.path}, callback: {
                guard let info = self.dataSource.printerInfo else {return}
                guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
                    self.showResult(result: NSLocalizedString("create_channel_error", comment: ""));
                    return
                }
                let credential = PrinterConnectUtil().fetchCurrentChannelCredential(printerInfo: info)
                let generateResult = PrinterConnectUtil().generatePrinterDriver(channel: channel, channelCredential: credential)
                if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
                    self.showResult(result: OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code))
                    return
                }
                
                guard let driver = generateResult.driver else {return}
                let cashedURLs = FileUtils.copyFileToTemp(urls: urls)
                let convertedCallback: ((URL, Int32) -> Void)? = { (url, progress) in
                    self.dataSource.progressCallback?(url as AnyObject, Int(progress))
                }
                let result = driver.transferFirmwareFiles(cashedURLs, progress: convertedCallback)
                driver.closeChannel()
                return self.showResult(result: PrintErrorModel.fetchTransferResult(result: result))
            })
        }
        showFilePicker()
    }

    func transferTemplateFilesDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            self.showTransferConfirmAlert(title: NSLocalizedString("transferTemplateFiles", comment: ""), filePaths: urls.map{$0.path}, callback: {
                guard let info = self.dataSource.printerInfo else {return}
                guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
                    self.showResult(result: NSLocalizedString("create_channel_error", comment: ""));
                    return
                }
                let credential = PrinterConnectUtil().fetchCurrentChannelCredential(printerInfo: info)
                let generateResult = PrinterConnectUtil().generatePrinterDriver(channel: channel, channelCredential: credential)
                if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
                    self.showResult(result: OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code))
                    return
                }
                
                guard let driver = generateResult.driver else {return}
                let cashedURLs = FileUtils.copyFileToTemp(urls: urls)
                let convertedCallback: ((URL, Int32) -> Void)? = { (url, progress) in
                    self.dataSource.progressCallback?(url as AnyObject, Int(progress))
                }
                let result = driver.transferTemplateFiles(cashedURLs, progress: convertedCallback)
                driver.closeChannel()
                return self.showResult(result: PrintErrorModel.fetchTransferResult(result: result))
            })
        }
        showFilePicker()
    }

    func transferDatabaseFilesDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            self.showTransferConfirmAlert(title: NSLocalizedString("transferDatabaseFiles", comment: ""), filePaths: urls.map{$0.path}, callback: {
                guard let info = self.dataSource.printerInfo else {return}
                guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
                    self.showResult(result: NSLocalizedString("create_channel_error", comment: ""));
                    return
                }
                let credential = PrinterConnectUtil().fetchCurrentChannelCredential(printerInfo: info)
                let generateResult = PrinterConnectUtil().generatePrinterDriver(channel: channel, channelCredential: credential)
                if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
                    self.showResult(result: OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code))
                    return
                }
                
                guard let driver = generateResult.driver else {return}
                let cashedURLs = FileUtils.copyFileToTemp(urls: urls)
                let convertedCallback: ((URL, Int32) -> Void)? = { (url, progress) in
                    self.dataSource.progressCallback?(url as AnyObject, Int(progress))
                }
                let result = driver.transferDatabaseFiles(cashedURLs, progress: convertedCallback)
                driver.closeChannel()
                return self.showResult(result: PrintErrorModel.fetchTransferResult(result: result))
            })
        }
        showFilePicker()
    }

    func transferBinaryFilesDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            self.showTransferConfirmAlert(title: NSLocalizedString("transferBinaryFiles", comment: ""), filePaths: urls.map{$0.path}, callback: {
                guard let info = self.dataSource.printerInfo else {return}
                guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
                    self.showResult(result: NSLocalizedString("create_channel_error", comment: ""));
                    return
                }
                let credential = PrinterConnectUtil().fetchCurrentChannelCredential(printerInfo: info)
                let generateResult = PrinterConnectUtil().generatePrinterDriver(channel: channel, channelCredential: credential)
                if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
                    self.showResult(result: OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code))
                    return
                }
                
                guard let driver = generateResult.driver else {return}
                let cashedURLs = FileUtils.copyFileToTemp(urls: urls)
                let convertedCallback: ((URL, Int32) -> Void)? = { (url, progress) in
                    self.dataSource.progressCallback?(url as AnyObject, Int(progress))
                }
                let result = driver.transferBinaryFiles(cashedURLs, progress: convertedCallback)
                driver.closeChannel()
                return self.showResult(result: PrintErrorModel.fetchTransferResult(result: result))
            })
        }
        showFilePicker()
    }
    
    func transferBinaryDataDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            self.showTransferConfirmAlert(title: NSLocalizedString("transferBinaryData", comment: ""), filePaths: urls.map{$0.path}, callback: {
                guard let info = self.dataSource.printerInfo else {return}
                guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
                    self.showResult(result: NSLocalizedString("create_channel_error", comment: ""));
                    return
                }
                let credential = PrinterConnectUtil().fetchCurrentChannelCredential(printerInfo: info)
                let generateResult = PrinterConnectUtil().generatePrinterDriver(channel: channel, channelCredential: credential)
                if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
                    self.showResult(result: OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code))
                    return
                }
                
                guard let driver = generateResult.driver else {return}
                let readData = FileUtils.readLocalFiles(urls: urls)
                let convertedCallback: ((NSNumber, Int32) -> Void)? = { (number, progress) in
                    self.dataSource.progressCallback?(number as AnyObject, Int(progress))
                }
                let result = driver.transferBinaryData(readData, progress: convertedCallback)
                driver.closeChannel()
                return self.showResult(result: PrintErrorModel.fetchTransferResult(result: result))
            })
        }
        showFilePicker()
    }
    
    func transferPrinterConfigurationFilesDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            self.showTransferConfirmAlert(title: NSLocalizedString("transferPrinterConfigurationFiles", comment: ""), filePaths: urls.map{$0.path}, callback: {
                guard let info = self.dataSource.printerInfo else {return}
                guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
                    self.showResult(result: NSLocalizedString("create_channel_error", comment: ""));
                    return
                }
                let credential = PrinterConnectUtil().fetchCurrentChannelCredential(printerInfo: info)
                let generateResult = PrinterConnectUtil().generatePrinterDriver(channel: channel, channelCredential: credential)
                if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
                    self.showResult(result: OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code))
                    return
                }
                
                guard let driver = generateResult.driver else {return}
                let cashedURLs = FileUtils.copyFileToTemp(urls: urls)
                let convertedCallback: ((URL, Int32) -> Void)? = { (url, progress) in
                    self.dataSource.progressCallback?(url as AnyObject, Int(progress))
                }
                let result = driver.transferPrinterConfigurationFiles(cashedURLs, progress: convertedCallback)
                driver.closeChannel()
                return self.showResult(result: PrintErrorModel.fetchTransferResult(result: result))
            })
        }
        showFilePicker()
    }
}

extension TransferFilesViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        defer {
            selectPickerCallback = nil
        }
        selectPickerCallback?(urls)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        selectPickerCallback = nil
    }
}

extension TransferFilesViewController: PrinterInfoSaveDelegate {
    func savePrinterInfo(info: DiscoveredPrinterInfo?) {
        dataSource.printerInfo = info
    }
}
