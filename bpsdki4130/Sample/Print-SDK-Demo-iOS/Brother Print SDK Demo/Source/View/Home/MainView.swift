//
//  MainView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/16.
//

import SwiftUI

protocol MainViewDelegate: AnyObject {
    func printImageDidTap()
    func printPdfDidTap()
    func templatePrintDidTap()
    func transferFilesDidTap()
    func printerInfoDidTap()
    func modelSpecDidTap()
    func validateDidTap()
    func fileAnalyzeDidTap()
}

struct MainView: View {
    weak var delegate: MainViewDelegate?
    @ObservedObject var dataSource: MainViewModel
    var body: some View {
        Form {
            ForEach(dataSource.itemList, id: \.self, content: { value in
                Section(content: {
                    HStack {
                        Spacer()
                        Button(value, action: {
                            switch value {
                            case NSLocalizedString("print_image", comment: ""): delegate?.printImageDidTap()
                            case NSLocalizedString("print_pdf", comment: ""): delegate?.printPdfDidTap()
                            case NSLocalizedString("template_print", comment: ""): delegate?.templatePrintDidTap()
                            case NSLocalizedString("transfer_files", comment: ""):
                                delegate?.transferFilesDidTap()
                            case NSLocalizedString("printer_info", comment: ""): delegate?.printerInfoDidTap()
                            case NSLocalizedString("model_spec", comment: ""): delegate?.modelSpecDidTap()
                            case NSLocalizedString("validate", comment: ""): delegate?.validateDidTap()
                            case NSLocalizedString("file_analyze", comment: ""): delegate?.fileAnalyzeDidTap()
                            default: break
                            }
                        }).foregroundColor(.black)
                        Spacer()
                    }
                })
            })
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(dataSource: .init())
    }
}
