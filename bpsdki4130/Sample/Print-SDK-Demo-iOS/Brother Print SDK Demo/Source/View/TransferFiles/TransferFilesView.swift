//
//  TransferFilesView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/29.
//

import SwiftUI

protocol TransferFilesViewDelegate: AnyObject {
    func selectPrinterButtonDidTap()
    func transferFirmwareFilesDidTap()
    func transferTemplateFilesDidTap()
    func transferDatabaseFilesDidTap()
    func transferBinaryFilesDidTap()
    func transferBinaryDataDidTap()
    func transferPrinterConfigurationFilesDidTap()
}

struct TransferFilesView: View {
    weak var delegate: TransferFilesViewDelegate?
    @ObservedObject var dataSource: TransferFilesViewModel
    var body: some View {
        Form {
            PrinterSelectionView(
                printerInfo: $dataSource.printerInfo,
                selectPrinterAction: {
                    delegate?.selectPrinterButtonDidTap()
                }
            )
            Section {
                Button(action: {
                    delegate?.transferFirmwareFilesDidTap()
                }, label: {
                    Text("transferFirmwareFiles")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.transferTemplateFilesDidTap()
                }, label: {
                    Text("transferTemplateFiles")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.transferDatabaseFilesDidTap()
                }, label: {
                    Text("transferDatabaseFiles")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.transferBinaryFilesDidTap()
                }, label: {
                    Text("transferBinaryFiles")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.transferBinaryDataDidTap()
                }, label: {
                    Text("transferBinaryData")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.transferPrinterConfigurationFilesDidTap()
                }, label: {
                    Text("transferPrinterConfigurationFiles")
                }).foregroundColor(.black)
            }
        }
    }
}

struct TransferFilesView_Previews: PreviewProvider {
    static var previews: some View {
        TransferFilesView(dataSource: .init())
    }
}
