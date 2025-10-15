//
//  PrintImageView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/20.
//

import SwiftUI

protocol PrintImageViewDelegate: AnyObject {
    func selectPrinterButtonDidTap()
    func printImageWithImageDidTap()
    func printImageWithURLDidTap()
    func printImageWithURLsDidTap()
    func printImageWithClosuresDidTap()
}

struct PrintImageView: View {
    weak var delegate: PrintImageViewDelegate?
    @ObservedObject var dataSource: PrintImageViewModel
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
                    delegate?.printImageWithImageDidTap()
                }, label: {
                    Text("print_image_with_image")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.printImageWithURLDidTap()
                }, label: {
                    Text("print_image_with_URL")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.printImageWithURLsDidTap()
                }, label: {
                    Text("print_image_with_URLs")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.printImageWithClosuresDidTap()
                }, label: {
                    Text("print_image_with_Closures")
                }).foregroundColor(.black)
            }
        }
    }
}

struct PrintImageView_Previews: PreviewProvider {
    static var previews: some View {
        PrintImageView(dataSource: .init())
    }
}
