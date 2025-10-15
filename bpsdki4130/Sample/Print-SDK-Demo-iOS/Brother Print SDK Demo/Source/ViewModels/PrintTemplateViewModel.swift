//
//  PrintTemplateViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/10.
//

import Foundation

class PrintTemplateViewModel: ObservableObject {
    @Published var printerInfo: DiscoveredPrinterInfo?
    @Published var encodingItemList = TemplateEncoding.allCases
    @Published var replaceItemList: [ReplaceData] = []
    @Published var replacersValue: String = ""
    @Published var encodingType: TemplateEncoding = .ENG
    @Published var key: String = ""
    @Published var printSettings: ISimpleTemplatePrintSettings?
    @Published var listData: [TemplateSettingItemData] = []
    private let printTemplateFacade = PrintTemplateFacade()
    var validateModel: PrinterModel?
    
    func getList() {
        guard let model = printerInfo?.fetchPrinterModel() else {
            return
        }
        if model.rawValue.hasPrefix("PJ") {
            printSettings = PJModelTemplatePrintSettings(printerModel: model)
        } else if model.rawValue.hasPrefix("MW") {
            printSettings = MWModelTemplatePrintSettings(printerModel: model)
        } else if model.rawValue.hasPrefix("RJ") {
            printSettings = RJModelTemplatePrintSettings(printerModel: model)
        } else if model.rawValue.hasPrefix("QL") {
            printSettings = QLModelTemplatePrintSettings(printerModel: model)
        } else if model.rawValue.hasPrefix("TD") {
            printSettings = TDModelTemplatePrintSettings(printerModel: model)
        } else if model.rawValue.hasPrefix("PT") {
            printSettings = PTModelTemplatePrintSettings(printerModel: model)
        }
        listData = printSettings?.templateSettingItemData ?? []
    }
    
    func setSettingsData(key: TemplatePrintSettingItemType, value: AnyHashable) {
        
        guard let index = printSettings?.templateSettingItemData?.firstIndex(where: { $0.key == key }) else { return }
        printSettings?.templateSettingItemData?.remove(at: index)
        printSettings?.templateSettingItemData?.insert(TemplateSettingItemData(key: key, value: value), at: index)
        listData = printSettings?.templateSettingItemData ?? []
    }
    
    func saveSettingsInfo() {
        printSettings?.templateSettingItemData?.forEach({
            printSettings?.setSettingInfo(key: $0.key, message: $0.value)
        })
    }
    
    func fetchSettingItemList(key: TemplatePrintSettingItemType) -> [String] {
        return printSettings?.fetchSettingItemList(key: key) ?? []
    }
    
    func startPrint(callback: @escaping(String) -> Void) {
        guard let info = printerInfo else {
            callback(NSLocalizedString("no_select_printer", comment: ""))
            return
        }
        saveSettingsInfo()
        DispatchQueue.global().async { [self] in
            let result = printTemplateFacade.startPrint(printerInfo: info,
                                           key: key,
                                           printSettings: printSettings?.fetchPrintSettings(),
                                           replaceItem: replaceItemList
                                           )
            DispatchQueue.main.async {
                callback(result)
            }
        }
    }

    func addInputData(key: String, value: String, type: TemplateObjectType, encode: TemplateEncoding) {
        replaceItemList.append(ReplaceData(type: type, key: key, value: value, encode: encode))
        updatePrintData()
    }

    func deleteInputData() {
        guard !replaceItemList.isEmpty else { return }
        replaceItemList.removeLast()
        updatePrintData()
    }


    private func updatePrintData() {
        var data = ""
        replaceItemList.forEach({ value in
            data += NSLocalizedString(value.type.rawValue, comment: "") + ":" + value.key + " "
            + NSLocalizedString("edit_text", comment: "") + ":" + value.value + " "
            + NSLocalizedString("encoding", comment: "") + value.encode.rawValue
            data += "\n"
        })
        replacersValue = NSLocalizedString("data_input", comment: "") + "\n" + data
    }

    func cancelPrinting() {
        printTemplateFacade.cancelPrinting()
    }
}

struct ReplaceData {
    var type: TemplateObjectType
    var key: String
    var value: String
    var encode: TemplateEncoding
}
