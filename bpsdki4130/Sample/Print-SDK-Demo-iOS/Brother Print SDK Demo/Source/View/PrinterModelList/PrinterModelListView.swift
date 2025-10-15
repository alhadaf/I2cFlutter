//
//  PrinterModelListView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/20.
//

import SwiftUI

protocol PrinterModelListViewDelegate: AnyObject {
    func printerModelDidSelect(modelName: String)
}

struct PrinterModelListView: View {
    weak var delegate: PrinterModelListViewDelegate?
    @ObservedObject var dataSource: PrinterModelListViewModel
    var body: some View {
        List(dataSource.printerModelList, id: \.self, rowContent: { value in
            Button(value, action: {
                delegate?.printerModelDidSelect(modelName: value)
            }).foregroundColor(.black)
        })
    }
}

struct PrinterModelListView_Previews: PreviewProvider {
    static var previews: some View {
        PrinterModelListView(dataSource: .init())
    }
}
