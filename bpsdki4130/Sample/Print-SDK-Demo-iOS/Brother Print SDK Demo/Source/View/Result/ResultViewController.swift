//
//  PrintResultViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/29.
//

import SwiftUI
import UIKit

class ResultViewController: UIViewController {
    var dataSource = ResultViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = ResultView(dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        title = NSLocalizedString("result", comment: "")
    }
}
