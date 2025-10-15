//
//  AboutViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/20.
//

import SwiftUI
import UIKit

class AboutViewController: UIViewController {
    private var dataSource = AboutViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = AboutView(dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        dataSource.fetchVersionInfo()
    }
}
