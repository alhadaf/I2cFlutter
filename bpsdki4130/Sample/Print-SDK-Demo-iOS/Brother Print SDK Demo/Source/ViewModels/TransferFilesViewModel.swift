//
//  TransferFilesViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/30.
//

import Foundation

class TransferFilesViewModel: ObservableObject {
    @Published var printerInfo: DiscoveredPrinterInfo?
    @Published var isShowWaitingView: Bool = false
    @Published var isShowCancelingView: Bool = false
    @Published var progressCallback:((AnyObject, Int) -> Void)? = nil
}
