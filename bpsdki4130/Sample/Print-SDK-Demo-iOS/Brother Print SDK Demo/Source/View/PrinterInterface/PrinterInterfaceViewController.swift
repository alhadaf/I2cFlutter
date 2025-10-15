//
//  InterfaceViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/6.
//

import SwiftUI
import UIKit

class PrinterInterfaceViewController: UIViewController {
    private var dataSource = PrinterInterfaceViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = PrinterInterfaceView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        title = NSLocalizedString("select_printer_interface", comment: "")
    }
}

extension PrinterInterfaceViewController: PrinterInterfaceViewDelegate {
    func interfaceButtonDidTap(type: InterfaceType) {
        let viewController = PrinterListViewController()
        viewController.dataSource.setChannelType(type: type)
        viewController.title = type.name
        if let stack = self.navigationController?.viewControllers {
            if stack.count > 1 {
                let previousController = stack[(stack.count) - 2]
                viewController.dataSource.delegate = previousController as? any PrinterInfoSaveDelegate
            }
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
