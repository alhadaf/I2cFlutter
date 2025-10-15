//
//  PrinterInfoViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/8.
//

import Foundation
import UIKit

class PrinterInfoViewModel: ObservableObject {
    @Published var printerInfo: DiscoveredPrinterInfo?
    private let printerInfoFacade = PrinterInfoFacade()

    func fetchMainFirmVersion() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchMainFirmVersion(printerInfo: info)
    }

    func fetchSerial() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchSerial(printerInfo: info)
    }

    func fetchStatus(callback: @escaping(String) -> Void) {
        guard let info = printerInfo else {
            callback(NSLocalizedString("no_select_printer", comment: ""))
            return
        }
        printerInfoFacade.fetchStatus(printerInfo: info, callback: callback)
    }

    func fetchSystemReport() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchSystemReport(printerInfo: info)
    }

    func fetchMediaVersion() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchMediaVersion(printerInfo: info)
    }

    func fetchBattery() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchBatteryInfo(printerInfo: info)
    }
    
    func fetchIsBootMode() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchIsBootMode(printerInfo: info)
    }

    func fetchPrinterInternalModelFlag() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchInternalModelFlag(printerInfo: info)
    }
    
    func fetchBluetoothFirmVersion() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchBluetoothFirmVersion(printerInfo: info)
    }

    func fetchTemplateInfoList() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchTemplateInfoList(printerInfo: info)
    }

    func fetchPtouchDeviceDependedDataHeaderList() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchPtouchDeviceDependedDataHeaderList(printerInfo: info)
    }

}
