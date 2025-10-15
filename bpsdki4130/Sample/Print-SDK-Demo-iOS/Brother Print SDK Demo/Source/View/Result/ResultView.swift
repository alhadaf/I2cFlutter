//
//  PrintResultView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/29.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var dataSource: ResultViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, content: {
                HStack {
                    Text(dataSource.resultMessage)
                    Spacer()
                }
                if !dataSource.templateList.isEmpty {
                    Divider()
                    ForEach(dataSource.templateList, id: \.self, content: { value in
                        Section {
                            VStack(alignment: .leading) {
                                Text("\(value.key)").font(.system(size: 20, design: .default))
                                Text("fileName: " + value.fileName + " fileSize: \(value.fileSize)").font(.footnote)
                            }.padding(8)
                        }
                        Divider()
                    })

                }
                Spacer()
            })
        }
    }
}

struct PrintResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(dataSource: .init())
    }
}
