//
//  PrintSettingsViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/31.
//

import BRLMPrinterKit
import SwiftUI
import UIKit
import UniformTypeIdentifiers

class PrintSettingsViewController: UIViewController, UINavigationControllerDelegate {
    var dataSource = PrintSettingsViewModel()
    private var selectPickerCallback: ((URL) -> Void)?
    let cancelAlert = CommonAlertUtil.cancelingAlert()
    var waitAlert: UIAlertController?
    let charLimitCount = 64

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = PrintSettingsView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        title = NSLocalizedString("print_setting", comment: "")
        if let model = dataSource.validateModel {
            dataSource.getList(model: model)
            return
        }
        let item = UIBarButtonItem(
            title: NSLocalizedString("print", comment: ""),
            style: .plain,
            target: self,
            action: #selector(printItemDidTap)
        )
        self.navigationItem.rightBarButtonItem = item
        guard let info = dataSource.printerInfo else {
            return
        }
        dataSource.getList(model: info.fetchPrinterModel() ?? PrinterModel.defaultPrinter)
        waitAlert = CommonAlertUtil.waitingAlert {
            self.dataSource.cancelPrinting()
            self.present(self.cancelAlert, animated: true)
        }
    }

    @objc func printItemDidTap() {
        if let alert = self.waitAlert {
            self.present(alert, animated: true)
        }
        dataSource.saveSettingsInfo()
        dataSource.startPrint(callback: { result in
            if let alert = self.presentedViewController as? UIAlertController {
                alert.dismiss(animated: false) {
                    let viewController = ResultViewController()
                    viewController.dataSource.resultMessage = result
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        })
    }
}

extension PrintSettingsViewController: PrintSettingsViewDelegate {
    func selectFilePathButtonDidTap() {
        selectPickerCallback = { url in
            self.dataSource.customPaperFilePath = FileUtils.copyFileToTemp(urls: [url]).first?.path ?? url.path
        }

        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            if let typeBIN = UTType(filenameExtension: "bin") {
                picker = UIDocumentPickerViewController(forOpeningContentTypes: [typeBIN], asCopy: true)
            }
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.archive"], in: .import)
        }
        picker?.delegate = self
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }

    func settingitemDidTap(item: SettingItemData, needCharacterFilter: Bool, keyboardType: UIKeyboardType) {
        let alert = CommonAlertUtil.editAlert(
            title: item.key.title,
            message: item.value as? String ?? "",
            keyboardType: keyboardType,
            delegate: needCharacterFilter ? self : nil,
            callback: { value in
                self.dataSource.setSettingsData(key: item.key, value: value)
            }
        )
        self.present(alert, animated: true)
    }

    func validateButtonDidTap() {
        self.dataSource.validateSettingsInfo(callback: { report in
            let viewController = ResultViewController()
            viewController.dataSource.resultMessage = report
            self.navigationController?.pushViewController(viewController, animated: true)
        })
    }
}

extension PrintSettingsViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        defer {
            selectPickerCallback = nil
        }
        guard let url = urls.first else { return }
        selectPickerCallback?(url)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        selectPickerCallback = nil
    }
}

extension PrintSettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count ?? 0 >= charLimitCount && range.length == 0 {
            return false
        }
        return true
    }
}
