//
//  PrintImageViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/20.
//

import Foundation

class PrintImageViewModel: ObservableObject {
    @Published var printerInfo: DiscoveredPrinterInfo?
    private let printImageFacade = PrintImageFacade()

    // start print
    func startPrint(
        urls: [URL],
        imageType: ImagePrnType,
        callback: @escaping(String) -> Void
    ) {
        guard let info = printerInfo else {
            return
        }
        DispatchQueue.global().async { [] in
            var result = ""
            switch imageType {
            case .imageFile, .imageURL, .imageURLs, .imageClosures: break
            }
            DispatchQueue.main.async {
                callback(result)
            }
        }
    }

    func cancelPrinting() {
        printImageFacade.cancelPrinting()
    }
}
