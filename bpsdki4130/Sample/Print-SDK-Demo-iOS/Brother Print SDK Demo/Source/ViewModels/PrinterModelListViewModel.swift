//
//  PrinterModelListViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/20.
//

import BRLMPrinterKit
import Foundation

class PrinterModelListViewModel: ObservableObject {
    var type: ModelListType = .spec
    @Published var printerModelList: [String] = PrinterModel.allCases.map({ $0.rawValue }).sorted()

    func fetchModelSpec(modelName: String) -> String {
        guard let printerModel = PrinterModel(modelName: modelName) else { return "" }
        let modelSpec = BRLMPrinterModelSpec(printerModel: printerModel.printerModel)
        
        
        let ptlabels: [BRLMPTPrintSettingsLabelSize] = modelSpec.supportedPTLabels.compactMap {
            BRLMPTPrintSettingsLabelSize(rawValue: $0.intValue)
        }
        let ptlabelsString = "[ \(ptlabels.map { EnumToString.ptLabelSize(size: $0) }.joined(separator: ", ")) ]"

        let qllabels: [BRLMQLPrintSettingsLabelSize] = modelSpec.supportedQLLabels.compactMap {
            BRLMQLPrintSettingsLabelSize(rawValue: $0.intValue)
        }
        let qllabelsString = "[ \(qllabels.map { EnumToString.qlLabelSize(size: $0) }.joined(separator: ", ")) ]"

        return NSLocalizedString("spec_xdpi", comment: "") + ": \(modelSpec.xdpi)" + "\n" +
        NSLocalizedString("spec_ydpi", comment: "") + ": \(modelSpec.ydpi)" + "\n" +
        NSLocalizedString("spec_series_code", comment: "") + ": 0x" + String(format: "%02x", modelSpec.seriesCode) + "\n" +
        NSLocalizedString("spec_model_code", comment: "") + ": 0x" + String(format: "%02x", modelSpec.modelCode) + "\n" +
        NSLocalizedString("supported_pt_labels", comment: "") + ": " + ptlabelsString + "\n" +
        NSLocalizedString("supported_ql_labels", comment: "") + ": " + qllabelsString

    }
}


