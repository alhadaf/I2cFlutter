//
//  TemplatePrintSettingsView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/05/30.
//

import SwiftUI

struct TemplatePrintSettingsView: View {
    weak var delegate: PrintTemplateViewDelegate?
    @ObservedObject var dataSource: PrintTemplateViewModel
    @State var isShowingEditView = false
    var body: some View {
        VStack {
            List {
                Section(content: {
                    ForEach($dataSource.listData, id: \.self, content: { value in
                        TemplateSettingInfoItemView(settingItem: value, dataSource: dataSource, delegate: delegate)
                    })
                })
            }.listStyle(.plain)
            NavigationLink(
                "", destination: TemplateEditView(delegate: delegate, dataSource: dataSource),
                isActive: $isShowingEditView
            ).opacity(0)
        }.padding(.horizontal, 16).padding(.top, 8)
            .navigationBarTitle(Text("template_print"), displayMode: .inline)
            .navigationBarItems(
                trailing: VStack {
                    Button(action: {
                        isShowingEditView = true
                    }, label: {
                        Text(NSLocalizedString("next", comment: "")).foregroundColor(.accentColor)
                            .frame(height: 96, alignment: .trailing)
                    })
                }
            )
    }
}

struct TemplateSettingInfoItemView: View {
    @Binding var settingItem: TemplateSettingItemData
    @State var isShowItemSelectView: Bool = false
    @State var dataSource: PrintTemplateViewModel
    weak var delegate: PrintTemplateViewDelegate?
    var body: some View {
        ZStack(alignment: .leading) {
            Button(action: {
                switch settingItem.key {
                case .NUM_COPIES:
                    delegate?.settingitemDidTap(item: settingItem)
                case .PEEL_LABEL:
                    isShowItemSelectView = true
                case .PRINTER_MODEL:
                    break
                }
            }, label: {
                VStack(alignment: .leading, content: {
                    Text(settingItem.key.title).font(.system(size: 17, design: .default))
                    Text(settingItem.value as? String ?? "").font(.footnote).foregroundColor(.gray)
                }).padding(5)
            }).sheet(isPresented: $isShowItemSelectView, onDismiss: {
                isShowItemSelectView = false
            }, content: {
                TemplateSettingItemListView(
                    item: settingItem.key,
                    itemList: dataSource.fetchSettingItemList(key: settingItem.key),
                    dataSource: $dataSource,
                    isShow: $isShowItemSelectView
                )
            })
        }
    }
}

struct TemplateSettingItemListView: View {
    var item: TemplatePrintSettingItemType
    var itemList: [String]
    @Binding var dataSource: PrintTemplateViewModel
    @Binding var isShow: Bool

    var body: some View {
        NavigationView(content: {
            List(content: {
                Section(content: {
                    ForEach(itemList, id: \.self, content: { value in
                        Button(value, action: {
                            dataSource.setSettingsData(key: item, value: value)
                            isShow = false
                        }).foregroundColor(.black)
                    })
                })
            })
            .navigationBarTitle(Text(item.title), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    isShow = false
                }, label: {
                    Text("cancel")
                })
            )
        })
    }
}

struct TemplatePrintSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TemplatePrintSettingsView(dataSource: .init())
    }
}

struct TemplateSettingInfoItemView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateSettingInfoItemView(settingItem: .constant(TemplateSettingItemData(key: .PEEL_LABEL, value: false)), dataSource: .init())
    }
}

struct TemplateSettingItemListView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateSettingItemListView(item: .PEEL_LABEL,
                                    itemList: ["ON", "OFF"],
                                    dataSource: .constant(.init()),
                                    isShow: .constant(true))
    }
}
