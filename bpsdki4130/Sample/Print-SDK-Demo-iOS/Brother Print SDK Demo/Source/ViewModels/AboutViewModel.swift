//
//  AboutViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/20.
//

import BRLMPrinterKit
import Foundation

class AboutViewModel: ObservableObject {
    @Published var appVer = ""
    @Published var sdkVer = ""

    func fetchVersionInfo() {
        let appBuildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        appVer = appVersion + "(" + appBuildVersion + ")"
        let sdkBuildVersion = Bundle(for: BRPtouchPrinter.self).infoDictionary?["CFBundleVersion"] as? String ?? ""
        let sdkVersion = Bundle(for: BRPtouchPrinter.self).infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        sdkVer = sdkVersion + "(" + sdkBuildVersion + ")"
    }
}
