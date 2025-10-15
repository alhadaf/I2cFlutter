//
//  PrinterListViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/10.
//

import BRLMPrinterKit
import SwiftUI
import UIKit

class PrinterListViewController: UIViewController {
    var dataSource = PrinterListViewModel()
    var searchingAlert: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = PrinterListView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        searchingAlert = CommonAlertUtil.showSearchingAlert(callback: {
            self.dataSource.stopSearch()
        })
        self.refreshList()
        if dataSource.channelType == .bluetoothMFi {
            let searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchForBluetoothDevice))
            let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshList))
            self.navigationItem.rightBarButtonItems = [refreshItem, searchItem]
        } else {
            let item = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshList))
            self.navigationItem.rightBarButtonItem = item
        }
    }

    @objc func refreshList() {
        if !dataSource.isSearching {
            if let alert = searchingAlert {
                self.present(alert, animated: true)
            }
            // Because the display of Alert is slow, it is delayed for one second to let the Alert display normally
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.dataSource.startSearch(callback: { error in
                    self.searchIsEnd(error: error)
                })
            })
        }
    }

    @objc func searchForBluetoothDevice() {
        BRLMPrinterSearcher.startBluetoothAccessorySearch({_ in
            self.refreshList()
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataSource.stopSearch()
    }

    private func searchIsEnd(error: String) {
        self.searchingAlert?.dismiss(animated: true)
        if error != BRLMPrinterSearchErrorCode.noError.name {
            let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
}

extension PrinterListViewController: PrinterListViewDelegate {
    func connectPrinter(code: UUID) {
        let info = dataSource.infoForPrinterItemData(item: code)
        let models = info?.getListOfWhatPrinterModel()
        if (models?.count ?? 0) >= 2 {
            let alert = UIAlertController(title: NSLocalizedString("determine_model", comment: ""),
                                          message: "", preferredStyle: UIAlertController.Style.alert)
            models?.forEach {
                let model = $0
                alert.addAction(UIAlertAction(title: model.rawValue, style: UIAlertAction.Style.default, handler: { [self]_ in
                    info?.printerItemData.determinedModel = model
                    dataSource.savePrinterInfo(info: info)
                    self.navigationController?.popViewController(animated: true)
                }))
            }
            self.present(alert, animated: true, completion: {})
        } else {
            info?.printerItemData.determinedModel = models?.first
            dataSource.savePrinterInfo(info: info)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
