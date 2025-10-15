//
//  InterfaceViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/6.
//

import BRLMPrinterKit
import Foundation

class PrinterInterfaceViewModel: ObservableObject {
    @Published var itemList: [InterfaceType] = InterfaceType.allCases
}

enum InterfaceType: CaseIterable {
    case network
    case bluetooth
    case ble

    var name: String {
        switch self {
        case .network:
            return NSLocalizedString("network", comment: "")
        case .bluetooth:
            return NSLocalizedString("classic_bluetooth", comment: "")
        case .ble:
            return NSLocalizedString("bluetooth_low_energy", comment: "")
        }
    }
}
