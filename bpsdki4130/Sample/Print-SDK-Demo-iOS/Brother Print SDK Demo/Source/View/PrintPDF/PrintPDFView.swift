//
//  PrintPDFView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/28.
//

import SwiftUI

protocol PrintPDFViewDelegate: AnyObject {
    func selectPrinterButtonDidTap()
    func printPDFWithURLDidTap()
    func printPDFWithURLsDidTap()
    func printPDFWithURLAndPagesDidTap(callback: @escaping() -> Void)
    func nextButtonDidTap()
}

struct PrintPDFView: View {
    weak var delegate: PrintPDFViewDelegate?
    @ObservedObject var dataSource: PrintPDFViewModel
    @State var isShowNumberPage = false
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
                    delegate?.printPDFWithURLDidTap()
                }, label: {
                    Text("print_PDF_with_URL")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.printPDFWithURLsDidTap()
                }, label: {
                    Text("print_PDF_with_URLs")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.printPDFWithURLAndPagesDidTap(callback: {
                        isShowNumberPage = true
                    })
                }, label: {
                    Text("print_PDF_with_URL_pages")
                }).foregroundColor(.black)
                    .sheet(isPresented: $isShowNumberPage, onDismiss: {
                        isShowNumberPage = false
                    }, content: {
                        NumberInputView(
                            delegate: delegate,
                            isShow: $isShowNumberPage,
                            number: $dataSource.pages
                        )
                    })
            }
        }
    }
}

struct PrintPDFView_Previews: PreviewProvider {
    static var previews: some View {
        PrintPDFView(dataSource: .init())
    }
}

struct NumberInputView: View {
    var delegate: PrintPDFViewDelegate?
    @Binding var isShow: Bool
    @Binding var number: String
    @State var isInputValid: Bool = true
    var body: some View {
        NavigationView(content: {
            VStack(alignment: .leading, content: {
                Text("input_numbers_with_seperated").font(.footnote)
                TextField("", text: $number)
                    .textFieldStyle(.roundedBorder)
                if !isInputValid {
                    Text("error_invalidate_input")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                Spacer()
            }).padding(.horizontal, 16).padding(.top, 8)
                .navigationBarTitle(Text("print_pdf"), displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        isShow = false
                    }, label: {
                        Text("cancel")
                    }),
                    trailing: Button(action: {
                        guard number.isNumberListString() else {
                            isInputValid = false
                            return
                        }
                        isInputValid = true
                        isShow = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            delegate?.nextButtonDidTap()
                        })
                    }, label: {
                        Text("next")
                    })
                )
        })
    }
}
