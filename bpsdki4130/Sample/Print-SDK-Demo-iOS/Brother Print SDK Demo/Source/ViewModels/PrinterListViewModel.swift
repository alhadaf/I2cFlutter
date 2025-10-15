//
//  PrinterListViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/29.
//

import BRLMPrinterKit
import Foundation

class PrinterListViewModel: NSObject, ObservableObject {
    @Published var channelType: BRLMChannelType?
    @Published var isSearching: Bool = false
    @Published var printerInfoList: [DiscoveredPrinterInfo] = []
    var typeName = ""
    var delegate: PrinterInfoSaveDelegate?
    var printerSearcher: IPrinterSearcher?

    func setChannelType(type: InterfaceType) {
        self.typeName = type.name
        switch type {
        case .network:
            channelType = BRLMChannelType.wiFi
        case .bluetooth:
            channelType = BRLMChannelType.bluetoothMFi
        case .ble:
            channelType = BRLMChannelType.bluetoothLowEnergy
        }
    }

    // Start searching for printers
    func startSearch(callback: @escaping(String) -> Void) {
        self.printerInfoList = []
        isSearching = true
        let searcher = fetchPrinterSearcher()
        searcher?.start(callback: { error, list in
            if let list = list {
                self.printerInfoList.append(contentsOf: list)
            }
            if let error = error {
                self.isSearching = false
                callback(error)
            }
        })
    }

    // Stop searching for printers
    func stopSearch() {
        isSearching = false
        printerSearcher?.cancel()
    }

    private func fetchPrinterSearcher() -> IPrinterSearcher? {
        guard printerSearcher == nil else { return printerSearcher }
        var target: IPrinterSearcher?
        if let channelType = channelType {
            switch channelType {
            case .bluetoothMFi: target = BluetoothPrinterSearcher()
            case .wiFi: target = NetPrinterSearcher()
            case .bluetoothLowEnergy: target = BLEPrinterSearcher()
            @unknown default:
                break
            }
            printerSearcher = target
        }
        return target
    }

    
    func infoForPrinterItemData(item: UUID) -> DiscoveredPrinterInfo? {
        return printerInfoList.first(where: {
            return $0.code == item
        })
    }

    func savePrinterInfo(info: DiscoveredPrinterInfo?) {
        delegate?.savePrinterInfo(info: info)
    }
}

protocol PrinterInfoSaveDelegate {
    func savePrinterInfo(info: DiscoveredPrinterInfo?)
}

extension BRLMPrinterSearchErrorCode {
    var name: String {
        switch self {
        case .noError:
            return "noError"
        case .canceled:
            return "canceled"
        case .alreadySearching:
            return "alreadySearching"
        case .unsupported:
            return "unsupported"
        case .unknownError:
            return "unknownError"
        @unknown default:
            return "unknownError"
        }
    }
}
