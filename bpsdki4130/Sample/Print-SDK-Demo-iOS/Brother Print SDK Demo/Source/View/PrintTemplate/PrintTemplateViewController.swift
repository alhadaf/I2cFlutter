//
//  PrintTemplateViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/10.
//

import BRLMPrinterKit
import SwiftUI
import UIKit

class PrintTemplateViewController: UIViewController {
    private var dataSource = PrintTemplateViewModel()
    let cancelAlert = CommonAlertUtil.cancelingAlert()
    var waitAlert: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = PrintTemplateView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        title = NSLocalizedString("template_print", comment: "")
        waitAlert = CommonAlertUtil.waitingAlert {
            self.dataSource.cancelPrinting()
            self.present(self.cancelAlert, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.getList()
    }

    private func showWrongInputAlert() {
        let alertController = UIAlertController(
            title: NSLocalizedString("msg_title_warning", comment: ""),
            message: NSLocalizedString("error_input", comment: ""),
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}

extension PrintTemplateViewController: PrintTemplateViewDelegate {
    func addButtonDidTap(index: String, objectName: String,
                         text: String, templateObjectType: TemplateObjectType, encode: TemplateEncoding) {
        if (templateObjectType == .objectName && objectName.isEmpty) || (templateObjectType == .index && index.isEmpty) {
            self.showWrongInputAlert()
            return
        }
        switch templateObjectType {
        case .index:
            dataSource.addInputData(key: index,
                                    value: text,
                                    type: templateObjectType,
                                    encode: encode)
        case .objectName:
            dataSource.addInputData(key: objectName,
                                    value: text,
                                    type: templateObjectType,
                                    encode: encode)
        }
    }

    func deleteButtonDidTap() {
        dataSource.deleteInputData()
    }

    func printButtonDidTap() {
        if let alert = self.waitAlert {
            self.present(alert, animated: true)
        }
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

    func showConnectPrinterAlert() {
        let alert = CommonAlertUtil.connectPrinterAlert()
        self.present(alert, animated: true)
    }

    func selectPrinterButtonDidTap() {
        let viewController = PrinterInterfaceViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func settingitemDidTap(item: TemplateSettingItemData) {
        let alert = CommonAlertUtil.editAlert(
            title: item.key.title,
            message: item.value as? String ?? "",
            keyboardType: .numberPad,
            delegate: nil,
            callback: { value in
            self.dataSource.setSettingsData(key: item.key, value: value)
        })
        self.present(alert, animated: true)
    }
    
    func removeTemplateButtonDidTap() {
        TransitionUtils.launchInputIntListView(viewController: self, title: NSLocalizedString("remove_template_select", comment: ""), decisionCaption: NSLocalizedString("remove", comment: "")) { keyList in
            TransitionUtils.showWaitingAlert(viewController: self)
            defer { TransitionUtils.dismissWaitingAlert()}
            
            guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: self.dataSource.printerInfo!) else {
                TransitionUtils.showResult(viewController: self, string:NSLocalizedString("create_channel_error", comment: ""))
                return
            }
            
            let credential = PrinterConnectUtil().fetchCurrentChannelCredential(printerInfo: self.dataSource.printerInfo!)
            let generateResult = PrinterConnectUtil().generatePrinterDriver(channel: channel, channelCredential: credential)
            if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
                TransitionUtils.showResult(viewController: self, string: OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code))
                return
            }
            
            let driver = generateResult.driver
            defer {driver?.closeChannel()}
            let result = driver?.removeTemplate(withKeys: keyList as [NSNumber])
            let errorString = PrintErrorModel.fetchRemoveTemplateResult(result: result) + "\n" + (result?.allLogs.map({ $0.errorDescription }).joined(separator: "\n") ?? "")
            TransitionUtils.showResult(viewController: self, string: errorString)
        }
    }
}

extension PrintTemplateViewController: PrinterInfoSaveDelegate {
    func savePrinterInfo(info: DiscoveredPrinterInfo?) {
        dataSource.printerInfo = info
    }
}
