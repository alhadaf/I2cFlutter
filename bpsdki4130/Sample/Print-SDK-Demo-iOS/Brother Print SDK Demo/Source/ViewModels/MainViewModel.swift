//
//  MainViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/20.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var itemList: [String] = [
        NSLocalizedString("print_image", comment: ""),
        NSLocalizedString("print_pdf", comment: ""),
        NSLocalizedString("template_print", comment: ""),
        NSLocalizedString("transfer_files", comment: ""),
        NSLocalizedString("printer_info", comment: ""),
        NSLocalizedString("model_spec", comment: ""),
        NSLocalizedString("validate", comment: ""),
        NSLocalizedString("file_analyze", comment: ""),
    ]
}

