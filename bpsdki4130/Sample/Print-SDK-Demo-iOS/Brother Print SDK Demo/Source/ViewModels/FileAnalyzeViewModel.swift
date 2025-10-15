//
//  FileAnalyzeViewModel.swift
//  Brother Print SDK Demo
//
//  Created by shintaro on 2024/07/04.
//

import Foundation
import BRLMPrinterKit


class FileAnalyzeViewModel: ObservableObject {
    @Published var itemList: [String] = [
        NSLocalizedString("analyze_pd3", comment: ""),
    ]
    
    func featchAnalyzePd3(url:URL) -> String {
        var resultString = ""
        if let result = BRLMFileAnalyzer.analyzePD3(url) {
            resultString = "\(NSLocalizedString("result", comment: "")) : "
            + "\(FileAnalyzeErrorModel.fetchFileAnalyzeErrorCode(error: result.error.code))\n"
            if let report = result.report {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                resultString += "\(NSLocalizedString("param_dataKind_value", comment: "")) : " + "\(EnumToString.dataheaderKind(kind: report.dataKind))\n"
                + "\(NSLocalizedString("param_version_value", comment: "")) : " + "\(report.version)\n"
                + "\(NSLocalizedString("param_name_value", comment: "")) : " + "\(report.name)\n"
                + "\(NSLocalizedString("modifiedDate_value", comment: "")) : " + "\(df.string(from: report.modifiedDate))\n"
                + "\(NSLocalizedString("dataSize_value", comment: "")) : " + "\(report.dataSize)\n"
                + "\(NSLocalizedString("destinationCode_value", comment: "")) : " + "\(report.destinationCode)"
            }
        }
        return resultString
    }
    
}

