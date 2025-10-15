//
//  PrintResultViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/29.
//

import BRLMPrinterKit
import Foundation

class ResultViewModel: ObservableObject {
    @Published var resultMessage: String = ""
    @Published var templateList: [BRLMPtouchTemplateInfo] = []
}
