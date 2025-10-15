//
//  PrinterInfoViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/8.
//

import SwiftUI
import UIKit

class PrinterInfoViewController: UIViewController {
    private var dataSource = PrinterInfoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = PrinterInfoView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        title = NSLocalizedString("printer_info", comment: "")
    }

    func showResultView(result: String) {
        if let alert = self.presentedViewController as? UIAlertController {
            alert.dismiss(animated: false) {
                let viewController = ResultViewController()
                viewController.dataSource.resultMessage = result
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    private func showWaitingAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("waiting", comment: ""), message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true)
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

extension PrinterInfoViewController: PrinterInfoViewDelegate {
    func requestPtouchDeviceDependedDataHeaderListDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        self.showWaitingAlert()
        DispatchQueue.global().async {
            let result = self.dataSource.fetchPtouchDeviceDependedDataHeaderList()
            DispatchQueue.main.async {
                self.showResultView(result: result)
            }
        }

    }
    
    func requestBluetoothFirmVersionDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        self.showWaitingAlert()
        DispatchQueue.global().async {
            let result = self.dataSource.fetchMainFirmVersion()
            DispatchQueue.main.async {
                self.showResultView(result: result)
            }
        }

    }
    
    func requestPrinterInternalModelFlagTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        self.showWaitingAlert()
        DispatchQueue.global().async {
            let result = self.dataSource.fetchPrinterInternalModelFlag()
            DispatchQueue.main.async {
                self.showResultView(result: result)
            }
        }
    }
    
    func requestIsBootModeTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        self.showWaitingAlert()
        DispatchQueue.global().async {
            let result = self.dataSource.fetchIsBootMode()
            DispatchQueue.main.async {
                self.showResultView(result: result)
            }
        }
    }
    
    func selectPrinterButtonDidTap() {
        let viewController = PrinterInterfaceViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func requestMainFirmVersionDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        self.showWaitingAlert()
        DispatchQueue.global().async {
            let result = self.dataSource.fetchMainFirmVersion()
            DispatchQueue.main.async {
                self.showResultView(result: result)
            }
        }
    }

    func requestSerialNumberDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        self.showWaitingAlert()
        DispatchQueue.global().async {
            let result = self.dataSource.fetchSerial()
            DispatchQueue.main.async {
                self.showResultView(result: result)
            }
        }
    }

    func getStatusDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        self.showWaitingAlert()
        dataSource.fetchStatus(callback: { result in
            self.showResultView(result: result)
        })
    }

    func requestSystemReportDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        self.showWaitingAlert()
        DispatchQueue.global().async {
            let result = self.dataSource.fetchSystemReport()
            DispatchQueue.main.async {
                self.showResultView(result: result)
            }
        }
    }

    func requestMediaVersionDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        self.showWaitingAlert()
        DispatchQueue.global().async {
            let result = self.dataSource.fetchMediaVersion()
            DispatchQueue.main.async {
                self.showResultView(result: result)
            }
        }
    }

    func requestBatteryDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        self.showWaitingAlert()
        DispatchQueue.global().async {
            let result = self.dataSource.fetchBattery()
            DispatchQueue.main.async {
                self.showResultView(result: result)
            }
        }
    }
    
    func requestTemplateInfoListDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        self.showWaitingAlert()
        DispatchQueue.global().async {
            let result = self.dataSource.fetchTemplateInfoList()
            DispatchQueue.main.async {
                self.showResultView(result: result)
            }
        }
    }
}

extension PrinterInfoViewController: PrinterInfoSaveDelegate {
    func savePrinterInfo(info: DiscoveredPrinterInfo?) {
        dataSource.printerInfo = info
    }
}
