//
//  PrinterListView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/10.
//

import BRLMPrinterKit
import SwiftUI

protocol PrinterListViewDelegate: AnyObject {
    func connectPrinter(code: UUID)
}

struct PrinterListView: View {
    weak var delegate: PrinterListViewDelegate?
    @ObservedObject var dataSource: PrinterListViewModel
    var body: some View {
        VStack {
            if dataSource.printerInfoList.isEmpty {
                // emptyView message
                Text("not_find_data")
            } else {
                Form {
                    Section(content: {
                        ForEach(dataSource.printerInfoList, id: \.code, content: { value in
                            PrinterItemView(
                                code: value.code,
                                value: value.printerItemData,
                                delegate: delegate
                            )
                        })
                    }, header: {
                        Text(dataSource.typeName)
                    })
                }
            }
        }
    }
}

struct PrinterListView_Previews: PreviewProvider {
    static var previews: some View {
        PrinterListView(dataSource: .init())
    }
}

struct PrinterItemView: View {
    var code: UUID
    var value: PrinterItemData
    var delegate: PrinterListViewDelegate?
    var body: some View {
        Button(action: {
            delegate?.connectPrinter(code: code)
        }, label: {
            VStack(alignment: .leading, content: {
                Text(value.modelName).font(.system(size: 20, design: .default)).foregroundColor(.black)
                Text("channelInfo : \(value.channelInfo)").font(.footnote).foregroundColor(.gray)
                ForEach(Array(value.extraInfo), id: \.key) { elem in
                    Text("\(elem.key) : \(elem.value)").font(.footnote).foregroundColor(.gray)
                }
            })
        })
    }
}
