//
//  DiscoveredPrinterInfo.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/20.
//

import BRLMPrinterKit
import Foundation


struct PrinterItemData: Hashable {
    var channelType: BRLMChannelType
    var modelName: String
    var channelInfo: String
    var extraInfo: Dictionary<String,String>
    var determinedModel: PrinterModel?
}


class DiscoveredPrinterInfo{
    var code = UUID()
    var printerItemData: PrinterItemData = PrinterItemData(channelType: BRLMChannelType.wiFi,
                                                           modelName: "",
                                                           channelInfo: "",
                                                           extraInfo: [:])
    var password: String?
    
    func fetchPrinterModel() -> PrinterModel? {
        return printerItemData.determinedModel ?? guessPrinterModels(modelName: printerItemData.modelName).first
    }
    
    func getListOfWhatPrinterModel() -> [PrinterModel] {
        return guessPrinterModels(modelName: printerItemData.modelName)
    }
    
    func guessPrinterModels(modelName: String) -> [PrinterModel] {
        var model: PrinterModel?
        let seriesModelAndResolution: Int = 2
        let separator: String = "_"
        PrinterModel.allCases.forEach {
            if $0.rawValue.components(separatedBy: separator).count == seriesModelAndResolution { // TD-2350D_203など
                return
            }
            if modelName.lowercased().contains($0.rawValue.lowercased()) {
                if $0.rawValue.count >= (model?.rawValue.count ?? 0) {
                    model = $0
                }
            }
        }
        if let model = model {
            return [model]
        }
        
        var models: [PrinterModel] = Array()
        PrinterModel.allCases.forEach {
            var contains = $0.rawValue.components(separatedBy: separator)
            if contains.count == seriesModelAndResolution { // TD-2350D_203など
                _ = contains.popLast()
                if modelName.lowercased().contains(contains.joined(separator: separator).lowercased()) {
                    models.append($0)
                }
            }
        }
        
        return models
    }
}
