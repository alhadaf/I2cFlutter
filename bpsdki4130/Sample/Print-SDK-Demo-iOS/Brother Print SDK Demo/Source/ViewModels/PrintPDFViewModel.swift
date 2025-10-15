//
//  PrintPDFViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/28.
//

import Foundation

class PrintPDFViewModel: ObservableObject {
    @Published var printerInfo: DiscoveredPrinterInfo?
    @Published var pages: String = ""
    var pdfUrl: [URL]?
}
