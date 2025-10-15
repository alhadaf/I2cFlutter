//
//  PrintSettingsViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/31.
//

import Foundation
import UIKit

class PrintSettingsViewModel: ObservableObject {
    @Published var printerInfo: DiscoveredPrinterInfo?
    @Published var printSettings: ISimplePrintSettings?
    @Published var customPaperFilePath: String = ""
    private let printImageFacade = PrintImageFacade()
    private let printPDFFacade = PrintPDFFacade()
    var image: UIImage?
    var imageURLs: [URL] = []
    var pdfURLs: [URL] = []
    var pdfPages: [Int] = []
    var printType: PrintType = .image
    var pdfType: PDFPrintType = .pdfURL
    var imageType: ImagePrnType = .imageFile
    var validateModel: PrinterModel?

    @Published var listData: [SettingItemData] = []
    func getList(model: PrinterModel) {
        if model.rawValue.hasPrefix("PJ") {
            printSettings = PJModelPrintSettings(printerModel: model)
        } else if model.rawValue.hasPrefix("MW") {
            printSettings = MWModelPrintSettings(printerModel: model)
        } else if model.rawValue.hasPrefix("RJ") {
            printSettings = RJModelPrintSettings(printerModel: model)
        } else if model.rawValue.hasPrefix("QL") {
            printSettings = QLModelPrintSettings(printerModel: model)
        } else if model.rawValue.hasPrefix("TD") {
            printSettings = TDModelPrintSettings(printerModel: model)
        } else if model.rawValue.hasPrefix("PT") {
            printSettings = PTModelPrintSettings(printerModel: model)
        }
        listData = printSettings?.settingsData ?? []
    }

    func setSettingsData(key: PrintSettingItemType, value: AnyHashable) {

        guard let index = printSettings?.settingsData?.firstIndex(where: { $0.key == key }) else { return }
        printSettings?.settingsData?.remove(at: index)
        printSettings?.settingsData?.insert(SettingItemData(key: key, value: value), at: index)
        listData = printSettings?.settingsData ?? []
    }

    func saveSettingsInfo() {
        printSettings?.settingsData?.forEach({
            printSettings?.setSettingInfo(key: $0.key, message: $0.value)
        })
    }

    func fetchSettingItemList(key: PrintSettingItemType) -> [String] {
        return printSettings?.fetchSettingItemList(key: key) ?? []
    }

    // start print
    func startPrint(callback: @escaping(String) -> Void) { // swiftlint:disable:this cyclomatic_complexity function_body_length
        guard let info = printerInfo else { return }
        DispatchQueue.global().async { [self] in
            var result = ""
            if self.printType == .image {
                switch self.imageType {
                case .imageFile:
                    if let image = self.image?.cgImage {
                        result = self.printImageFacade.printImageWithImage(
                            info: info,
                            image: image,
                            settings: self.printSettings?.fetchPrintSettings()
                        )
                    }
                case .imageURL:
                    if let url = self.imageURLs.first {
                        result = self.printImageFacade.printImageWithURL(
                            info: info,
                            url: url,
                            settings: self.printSettings?.fetchPrintSettings()
                        )
                    }
                case .imageURLs:
                    result = self.printImageFacade.printImageWithURLs(
                        info: info,
                        urls: self.imageURLs,
                        settings: self.printSettings?.fetchPrintSettings()
                    )
                case .imageClosures:
                    result = self.printImageFacade.printImageWithClosures(
                        info: info,
                        urls: self.imageURLs,
                        settings: self.printSettings?.fetchPrintSettings()
                    )
                }
            } else if self.printType == .pdf {
                switch pdfType {
                case .pdfURL:
                    if let url = self.pdfURLs.first {
                        result = self.printPDFFacade.printPDFWithURL(
                            info: info,
                            url: url,
                            settings: self.printSettings?.fetchPrintSettings()
                        )
                    }
                case .pdfURLs:
                    result = self.printPDFFacade.printPDFWithURLs(
                        info: info,
                        urls: pdfURLs,
                        settings: self.printSettings?.fetchPrintSettings()
                    )
                case .pdfPages:
                    if let url = self.pdfURLs.first {
                        result = self.printPDFFacade.printPDFWithPages(
                            info: info,
                            url: url,
                            pages: pdfPages,
                            settings: self.printSettings?.fetchPrintSettings()
                        )
                    }
                }
            }
            DispatchQueue.main.async {
                callback(result)
            }
        }
    }

    func cancelPrinting() {
        switch printType {
        case .image:
            printImageFacade.cancelPrinting()
        case .pdf:
            printPDFFacade.cancelPrinting()
        }
    }

    func validateSettingsInfo(callback: @escaping(String) -> Void) {
        saveSettingsInfo()
        printSettings?.validateSettings(callback: { report in
            callback(report.description())
        })
    }
}
