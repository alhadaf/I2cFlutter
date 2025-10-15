//
//  MainViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/8.
//

import SwiftUI
import UIKit

class MainViewController: UIViewController {
    private var selectPickerCallback: ((URL) -> Void)?
    private var dataSource = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = MainView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        let item = UIBarButtonItem(
            title: NSLocalizedString("about_info", comment: ""),
            style: .plain,
            target: self,
            action: #selector(informationItemDidTap)
        )
        item.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = item
        FileUtils.clearTempDir()
    }

    @objc func informationItemDidTap() {
        let viewController = AboutViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MainViewController: MainViewDelegate {
    
    func printImageDidTap() {
        let viewController = PrintImageViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func printPdfDidTap() {
        let viewController = PrintPDFViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func templatePrintDidTap() {
        let viewController = PrintTemplateViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func transferFilesDidTap() {
        let viewController = TransferFilesViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func printerInfoDidTap() {
        let viewController = PrinterInfoViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func modelSpecDidTap() {
        let viewController = PrinterModelListViewController()
        viewController.dataSource.type = .spec
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func validateDidTap() {
        let viewController = PrinterModelListViewController()
        viewController.dataSource.type = .validate
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func fileAnalyzeDidTap() {
        let viewController = FileAnalyzeViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

