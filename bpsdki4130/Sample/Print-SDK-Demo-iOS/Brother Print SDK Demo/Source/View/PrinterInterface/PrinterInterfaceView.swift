//
//  InterfaceView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/6.
//

import BRLMPrinterKit
import SwiftUI

protocol PrinterInterfaceViewDelegate: AnyObject {
    func interfaceButtonDidTap(type: InterfaceType)
}

struct PrinterInterfaceView: View {
    weak var delegate: PrinterInterfaceViewDelegate?
    @ObservedObject var dataSource: PrinterInterfaceViewModel
    var body: some View {
        Form {
            ForEach(dataSource.itemList, id: \.self, content: { value in

                Button(action: {
                    delegate?.interfaceButtonDidTap(type: value)
                }, label: {
                    HStack {
                        // iOS 16のSpacerは分割線が短くなるので、空のTextを追加
                        Text("")
                        Spacer()
                        Text(value.name).foregroundColor(.black)
                        Spacer()
                    }
                })
            })
        }
    }
}

struct PrinterInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        PrinterInterfaceView(dataSource: .init())
    }
}
