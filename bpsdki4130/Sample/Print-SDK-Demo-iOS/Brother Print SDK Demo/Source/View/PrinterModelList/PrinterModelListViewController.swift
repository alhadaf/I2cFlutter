//
//  PrinterModelListViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/20.
//

import SwiftUI
import UIKit

class PrinterModelListViewController: UIViewController {
    var dataSource = PrinterModelListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = PrinterModelListView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        title = NSLocalizedString("printer", comment: "")
    }
}

extension PrinterModelListViewController: PrinterModelListViewDelegate {
    func printerModelDidSelect(modelName: String) {
        if dataSource.type == .spec {
            let viewController = ResultViewController()
            viewController.dataSource.resultMessage = dataSource.fetchModelSpec(modelName: modelName)
            self.navigationController?.pushViewController(viewController, animated: true)
        } else if dataSource.type == .validate {
            let viewController = PrintSettingsViewController()
            viewController.dataSource.validateModel = PrinterModel(modelName: modelName)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
