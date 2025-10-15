//
//  FileAnalyzeViewController.swift
//  Brother Print SDK Demo
//
//  Created by shintaro on 2024/07/04.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

class FileAnalyzeViewController: UIViewController {
    private var selectPickerCallback: ((URL) -> Void)?
    private var dataSource = FileAnalyzeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = FileAnalyzeView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
    }
}

extension FileAnalyzeViewController: FileAnalyzeViewDelegate {
    func analyzePd3DidTap() {
        selectPickerCallback = { url in
            let viewController = ResultViewController()
            viewController.dataSource.resultMessage = self.dataSource.featchAnalyzePd3(url: url)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: true)
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        }
        picker?.delegate = self
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }

    }
}

extension FileAnalyzeViewController: UIDocumentPickerDelegate {
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

