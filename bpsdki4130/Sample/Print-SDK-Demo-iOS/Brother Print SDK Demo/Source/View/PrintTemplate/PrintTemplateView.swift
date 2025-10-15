//
//  PrintTemplateView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/10.
//

import SwiftUI

protocol PrintTemplateViewDelegate: AnyObject {
    func selectPrinterButtonDidTap()
    func showConnectPrinterAlert()
    func addButtonDidTap(index: String, objectName: String, text: String, templateObjectType: TemplateObjectType, encode: TemplateEncoding)
    func deleteButtonDidTap()
    func printButtonDidTap()
    func settingitemDidTap(item: TemplateSettingItemData)
    func removeTemplateButtonDidTap()
}

enum TemplateObjectType: String, CaseIterable {
    case index = "edit_index"
    case objectName = "edit_object"
}

struct PrintTemplateView: View {
    weak var delegate: PrintTemplateViewDelegate?
    @ObservedObject var dataSource: PrintTemplateViewModel
    var body: some View {
        Form {
            PrinterSelectionView(
                printerInfo: $dataSource.printerInfo,
                selectPrinterAction: {
                    delegate?.selectPrinterButtonDidTap()
                }
            )
            Section {
                ZStack {
                    if dataSource.printerInfo == nil {
                        Button(action: {
                            delegate?.showConnectPrinterAlert()
                        }, label: {
                            HStack {
                                Text("print_template_with_key")
                                Spacer()
                            }
                        }).foregroundColor(.black)
                    } else {
                        NavigationLink(
                            destination: TemplateKeyInputView(delegate: delegate, dataSource: dataSource),
                            label: {
                            EmptyView()
                        }).opacity(0)
                        HStack {
                            Text("print_template_with_key")
                            Spacer()
                        }
                    }
                }
                Button(action: {errorOrAction {
                    delegate?.removeTemplateButtonDidTap()
                }}, label: {
                    Text("remove_template")
                }).foregroundColor(.black)
            }
        }
    }
    
    func errorOrAction(action: () -> Void) {
        if dataSource.printerInfo == nil {
            delegate?.showConnectPrinterAlert()
        } else {
            action()
        }
    }
}


struct TemplateKeyInputView: View {
    var delegate: PrintTemplateViewDelegate?
    @ObservedObject var dataSource: PrintTemplateViewModel
    @State var isInputValid: Bool = true
    @State var isShowingEditView = false
    var body: some View {
        VStack(alignment: .leading, content: {
            Text("template_key").font(.footnote)
            TextField("", text: $dataSource.key)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
            if !isInputValid {
                Text("error_invalidate_input")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            NavigationLink(
                "",
                destination: TemplatePrintSettingsView(delegate: delegate, dataSource: dataSource),
                isActive: $isShowingEditView
            ).opacity(0)
            Spacer()
        }).padding(.horizontal, 16).padding(.top, 8)
            .navigationBarTitle("template_print", displayMode: .inline)
            .navigationBarItems(
                trailing: VStack {
                    if $dataSource.key.wrappedValue.isEmpty {
                        Button(action: {
                            isInputValid = false
                        }, label: {
                            Text(NSLocalizedString("next", comment: ""))
                        })
                    } else {
                        Button(action: {
                            isShowingEditView = true
                        }, label: {
                            Text(NSLocalizedString("next", comment: "")).foregroundColor(.accentColor)
                        })
                    }
                }
            )
    }
}

struct TemplateEditView: View {
    var delegate: PrintTemplateViewDelegate?
    @ObservedObject var dataSource: PrintTemplateViewModel
    @State var type: TemplateObjectType = TemplateObjectType.index
    @State var itemList = TemplateObjectType.allCases
    @State var textValue = ""
    @State var indexValue = ""
    @State var objectNameValue = ""
    @State var encodingValue: TemplateEncoding = TemplateEncoding.ENG

    var body: some View {
        VStack(content: {
            HStack(alignment: .center, spacing: 8) {
                Picker(selection: $type, content: {
                    ForEach(itemList, id: \.self, content: { value in
                        Text(NSLocalizedString(value.rawValue, comment: ""))
                    })
                }, label: { Text("") }).pickerStyle(SegmentedPickerStyle())
            }
            if type == .index {
                HStack(spacing: 8, content: {
                    Text(NSLocalizedString(type.rawValue, comment: "")).frame(width: 100)
                    TextField(type.rawValue, text: $indexValue)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                })
            } else if type == .objectName {
                HStack(spacing: 8, content: {
                    Text(NSLocalizedString(type.rawValue, comment: "")).frame(width: 100)
                    TextField(NSLocalizedString(type.rawValue, comment: ""), text: $objectNameValue)
                        .textFieldStyle(.roundedBorder)
                })
            }
            HStack(spacing: 8, content: {
                Text(NSLocalizedString("edit_text", comment: "")).frame(width: 100)
                TextField(NSLocalizedString("edit_text", comment: ""), text: $textValue)
                    .textFieldStyle(.roundedBorder)
            })
            
            HStack(alignment: .center, spacing: 8) {
                Text("encoding")
                Picker(selection: $encodingValue, content: {
                    ForEach(dataSource.encodingItemList, id: \.self, content: { value in
                        Text(value.rawValue).foregroundColor(.black)
                    })
                }, label: {
                    EmptyView()
                }).frame(width: 150)
                Spacer()
            }
            
            HStack(spacing: 8) {
                // Add Button
                Button(action: {
                    delegate?.addButtonDidTap(
                        index: indexValue,
                        objectName: objectNameValue,
                        text: textValue,
                        templateObjectType: type,
                        encode: encodingValue
                    )
                }, label: {
                    HStack {
                        Spacer()
                        Text("add_object")
                        Spacer()
                    }.frame(height: 80)
                })
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 1, x: 0, y: 2)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                // Delete Button
                Button(action: {
                    delegate?.deleteButtonDidTap()
                }, label: {
                    HStack {
                        Spacer()
                        Text("delete_object")
                        Spacer()
                    }.frame(height: 80)
                })
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 1, x: 0, y: 2)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
            }.padding(8)
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Text($dataSource.replacersValue.wrappedValue).foregroundColor(.gray)
                        Spacer()
                    }
                    Spacer()
                }
            }
            Spacer()
        }).padding(8)
            .navigationBarTitle("template_print", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                delegate?.printButtonDidTap()
            }, label: {
                Text(NSLocalizedString("print", comment: ""))
                    .foregroundColor(.accentColor)
            }))
    }
}


struct PrintTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        PrintTemplateView(dataSource: .init())
    }
}

struct TemplateKeyInputView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateKeyInputView(dataSource: .init())
    }
}

struct TemplateEditView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateEditView(dataSource: .init())
    }
}
