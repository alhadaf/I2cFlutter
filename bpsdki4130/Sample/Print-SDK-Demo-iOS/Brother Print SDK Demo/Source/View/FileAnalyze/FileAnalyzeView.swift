//
//  FileAnalyzeView.swift
//  Brother Print SDK Demo
//
//  Created by shintaro on 2024/07/04.
//

import SwiftUI

protocol FileAnalyzeViewDelegate: AnyObject {
    func analyzePd3DidTap()
}

struct FileAnalyzeView: View {
    weak var delegate: FileAnalyzeViewDelegate?
    @ObservedObject var dataSource: FileAnalyzeViewModel
    var body: some View {
        Form {
            ForEach(dataSource.itemList, id: \.self, content: { value in
                Section(content: {
                    HStack {
                        Spacer()
                        Button(value, action: {
                            switch value {
                            case NSLocalizedString("analyze_pd3", comment: ""): delegate?.analyzePd3DidTap()
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

struct FileAnalyzeView_Previews: PreviewProvider {
    static var previews: some View {
        FileAnalyzeView(dataSource: .init())
    }
}
