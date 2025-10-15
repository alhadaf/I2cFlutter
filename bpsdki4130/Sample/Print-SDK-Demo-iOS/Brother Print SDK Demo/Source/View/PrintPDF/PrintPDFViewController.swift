//
//  PrintPDFViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/28.
//

import BRLMPrinterKit
import SwiftUI
import UIKit
import UniformTypeIdentifiers

class PrintPDFViewController: UIViewController, UINavigationControllerDelegate {
    private var dataSource = PrintPDFViewModel()
    private var selectPickerCallback: (([URL]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = PrintPDFView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        title = NSLocalizedString("print_pdf", comment: "")
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

extension PrintPDFViewController: PrintPDFViewDelegate {

    func selectPrinterButtonDidTap() {
        let viewController = PrinterInterfaceViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func printPDFWithURLDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            let viewController = PrintSettingsViewController()
            viewController.dataSource.printerInfo = self.dataSource.printerInfo
            viewController.dataSource.pdfURLs = FileUtils.copyFileToTemp(urls: urls)
            viewController.dataSource.pdfType = .pdfURL
            viewController.dataSource.printType = .pdf
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            if let type = UTType("com.adobe.pdf") {
                picker = UIDocumentPickerViewController(forOpeningContentTypes: [type], asCopy: true)
            }
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        }
        picker?.allowsMultipleSelection = true
        picker?.delegate = self
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }

    func printPDFWithURLsDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            let viewController = PrintSettingsViewController()
            viewController.dataSource.printerInfo = self.dataSource.printerInfo
            viewController.dataSource.pdfURLs = FileUtils.copyFileToTemp(urls: urls)
            viewController.dataSource.pdfType = .pdfURLs
            viewController.dataSource.printType = .pdf
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            if let type = UTType("com.adobe.pdf") {
                picker = UIDocumentPickerViewController(forOpeningContentTypes: [type], asCopy: true)
            }
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        }
        picker?.allowsMultipleSelection = true
        picker?.delegate = self
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }

    func printPDFWithURLAndPagesDidTap(callback: @escaping() -> Void) {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            self.dataSource.pdfUrl = FileUtils.copyFileToTemp(urls: urls)
            callback()
        }
        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            if let type = UTType("com.adobe.pdf") {
                picker = UIDocumentPickerViewController(forOpeningContentTypes: [type], asCopy: true)
            }
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        }
        picker?.allowsMultipleSelection = true
        picker?.delegate = self
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }

    func nextButtonDidTap() {
        let viewController = PrintSettingsViewController()
        viewController.dataSource.pdfPages = self.dataSource.pages.components(separatedBy: ";").map({ Int($0) ?? 0 })
        viewController.dataSource.printerInfo = self.dataSource.printerInfo
        viewController.dataSource.pdfURLs = self.dataSource.pdfUrl ?? []
        viewController.dataSource.pdfType = .pdfPages
        viewController.dataSource.printType = .pdf
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PrintPDFViewController: UIDocumentPickerDelegate {
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

extension PrintPDFViewController: PrinterInfoSaveDelegate {
    func savePrinterInfo(info: DiscoveredPrinterInfo?) {
        dataSource.printerInfo = info
    }
}
