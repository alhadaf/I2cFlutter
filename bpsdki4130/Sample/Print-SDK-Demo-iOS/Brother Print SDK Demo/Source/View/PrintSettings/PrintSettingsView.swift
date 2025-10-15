//
//  PrintSettingsView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/31.
//

import BRLMPrinterKit
import SwiftUI

protocol PrintSettingsViewDelegate: AnyObject {
    func validateButtonDidTap()
    func settingitemDidTap(item: SettingItemData, needCharacterFilter: Bool, keyboardType: UIKeyboardType)
    func selectFilePathButtonDidTap()
}

enum PresentViewType: Identifiable {
    case pjPaperSize
    case itemSelect

    var id: Int {
        hashValue
    }
}

struct PrintSettingsView: View {
    weak var delegate: PrintSettingsViewDelegate?
    @ObservedObject var dataSource: PrintSettingsViewModel
    var body: some View {
        VStack {
            List {
                Section(content: {
                    ForEach($dataSource.listData, id: \.self, content: { value in
                        SettingInfoItemView(settingItem: value, dataSource: dataSource, delegate: delegate)
                    })
                })
            }.listStyle(.plain)
            HStack {
                Button(action: {
                    delegate?.validateButtonDidTap()
                }, label: {
                    HStack {
                        Spacer()
                        Text("validate").font(.system(size: 17, design: .default))
                        Spacer()
                    }
                    .padding(8)
                })
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 1, x: 0, y: 2)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
            }
            .padding(16)
        }

    }
}

struct PrintSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PrintSettingsView(dataSource: .init())
    }
}

struct SettingInfoItemView: View {
    @Binding var settingItem: SettingItemData
    @State var presentViewType: PresentViewType?
    @State var dataSource: PrintSettingsViewModel
    var delegate: PrintSettingsViewDelegate?
    var body: some View {
        ZStack(alignment: .leading) {
            if settingItem.key == .CUSTOM_PAPER_SIZE {
                NavigationLink(
                    destination: RJAndTDCustomPaperView(
                        delegate: delegate,
                        dataSource: $dataSource,
                        item: settingItem.key,
                        itemList: dataSource.fetchSettingItemList(key: settingItem.key),
                        paperSizeItem: settingItem.value as? BRLMCustomPaperSize,
                        checkedItem: (settingItem.value as? BRLMCustomPaperSize)?.paperKind.name,
                        filePath: $dataSource.customPaperFilePath
                    ),
                    label: {
                        EmptyView()
                    }).opacity(0)
            }
            Button(action: {
                switch settingItem.key {
                case .SCALE_VALUE, .HALFTONE_THRESHOLD, .NUM_COPIES, .EXTRA_FEED_DOTS, .FORCE_STRETCH_PRINTABLE_AREA, .FEED_DIRECTION_MARGINS,
                        .AUTO_CUT_FOR_EACH_PAGE_COUNT, .BI_COLOR_RED_ENHANCEMENT, .BI_COLOR_GREEN_ENHANCEMENT, .BI_COLOR_BLUE_ENHANCEMENT:
                    delegate?.settingitemDidTap(
                        item: settingItem,
                        needCharacterFilter: false,
                        keyboardType: .decimalPad
                    )
                case .CUSTOM_RECORD:
                    delegate?.settingitemDidTap(item: settingItem, needCharacterFilter: true, keyboardType: .default)

                case .SCALE_MODE, .ORIENTATION, .HALFTONE, .HORIZONTAL_ALIGNMENT, .VERTICAL_ALIGNMENT, .COMPRESS_MODE,
                        .SKIP_STATUS_CHECK, .PRINT_QUALITY, .PAPER_TYPE, .PAPER_INSERTION_POSITION, .FEED_MODE, .DENSITY,
                        .ROLL_CASE, .PRINT_SPEED, .USING_CARBON_COPY_PAPER, .PRINT_DASH_LINE, .PEEL_LABEL,
                        .ROTATE180DEGREES, .LABEL_SIZE, .CUTMARK_PRINT, .CUT_PAUSE, .AUTO_CUT, .HALF_CUT, .CHAIN_PRINT,
                        .SPECIAL_TAPE_PRINT, .RESOLUTION, .FORCE_VANISHING_MARGIN, .CUT_AT_END, .ROTATION, .MIRROR_PRINT, .TRIM_TRAILING_BLANK_DATA:
                    presentViewType = PresentViewType.itemSelect

                case .PAPER_SIZE:
                    if dataSource.printSettings is PJModelPrintSettings {
                        presentViewType = PresentViewType.pjPaperSize
                    }
                case .PRINTER_MODEL, .CUSTOM_PAPER_SIZE, .CHANNEL_TYPE:
                    break
                }
            }, label: {
                VStack(alignment: .leading, content: {
                    Text(settingItem.key.title).font(.system(size: 17, design: .default))
                    if dataSource.printSettings is PJModelPrintSettings && settingItem.key == .PAPER_SIZE {
                        Text((settingItem.value as? BRLMPJPrintSettingsPaperSize)?.paperSizeStandard.name ?? "")
                            .font(.footnote).foregroundColor(.gray)
                    } else if settingItem.key == .CUSTOM_PAPER_SIZE {
                        Text((settingItem.value as? BRLMCustomPaperSize)?.paperKind.name ?? "")
                            .font(.footnote).foregroundColor(.gray)
                    } else {
                        Text(settingItem.value as? String ?? "").font(.footnote).foregroundColor(.gray)
                    }

                }).padding(5)
            }).sheet(item: $presentViewType, onDismiss: {
                presentViewType = nil
            }, content: { item in
                if item == PresentViewType.itemSelect {
                    SettingItemListView(
                        item: settingItem.key,
                        itemList: dataSource.fetchSettingItemList(key: settingItem.key),
                        dataSource: $dataSource,
                        type: $presentViewType
                    )
                } else if item == PresentViewType.pjPaperSize {
                    PJPaperSizeSettingView(
                        dataSource: $dataSource,
                        item: settingItem.key,
                        itemList: dataSource.fetchSettingItemList(key: settingItem.key),
                        paperSizeItem: settingItem.value as? BRLMPJPrintSettingsPaperSize,
                        checkedItem: (settingItem.value as? BRLMPJPrintSettingsPaperSize)?.paperSizeStandard.name,
                        type: $presentViewType
                    )
                }
            })
        }
    }
}

struct SettingItemListView: View {
    var item: PrintSettingItemType
    var itemList: [String]
    @Binding var dataSource: PrintSettingsViewModel
    @Binding var type: PresentViewType?

    var body: some View {
        NavigationView(content: {
            List(content: {
                Section(content: {
                    ForEach(itemList, id: \.self, content: { value in
                        Button(value, action: {
                            dataSource.setSettingsData(key: item, value: value)
                            type = nil
                        }).foregroundColor(.black)
                    })
                })
            })
            .navigationBarTitle(Text(item.title), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                type = nil
            }, label: {
                Text("cancel")
            }))
        })
    }
}

struct PJPaperSizeSettingView: View {
    @Binding var dataSource: PrintSettingsViewModel
    var item: PrintSettingItemType
    var itemList: [String]
    @State var paperSizeItem: BRLMPJPrintSettingsPaperSize?
    @State var checkedItem: String?
    @Binding var type: PresentViewType?
    @State var isShowCustomView: Bool = false
    @State var widthDots = ""
    @State var lengthDots = ""
    var body: some View {
        NavigationView(content: {
            List(content: {
                Section(content: {
                    ForEach(itemList, id: \.self, content: { value in
                        Button(action: {
                            checkedItem = value
                            isShowCustomView = value == BRLMPJPrintSettingsPaperSizeStandard.custom.name
                        }, label: {
                            HStack {
                                Text(value)
                                Spacer()
                                if value == checkedItem {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }).foregroundColor(.black)
                    })
                })
                if isShowCustomView {
                    Section(content: {
                        VStack {
                            HStack {
                                Text("width_dots").frame(width: 100)
                                TextField("", text: $widthDots)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numberPad)
                            }
                            HStack {
                                Text("length_dots").frame(width: 100)
                                TextField("", text: $lengthDots)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numberPad)
                            }
                        }
                    }, header: {
                        Text("custom_paper_size")
                    })
                }
            })
            .navigationBarTitle(Text(item.title), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    type = nil
                }, label: {
                    Text("cancel")
                }),
                trailing: Button(action: {
                    if checkedItem == BRLMPJPrintSettingsPaperSizeStandard.custom.name {
                        dataSource.setSettingsData(
                            key: item,
                            value: BRLMPJPrintSettingsPaperSize(
                                customPaper: BRLMPJPrintSettingsCustomPaperSize(
                                    widthDots: UInt(widthDots) ?? 0,
                                    lengthDots: UInt(lengthDots) ?? 0
                                )
                            )
                        )
                    } else {
                        dataSource.setSettingsData(
                            key: item,
                            value: BRLMPJPrintSettingsPaperSize(
                                paperSizeStandard: BRLMPJPrintSettingsPaperSizeStandard.allCases().first(where: {
                                    $0.name == checkedItem
                                }) ?? .A4
                            )
                        )
                    }
                    type = nil
                }, label: {
                    Text("ok")
                })
            ).onAppear(perform: {
                    isShowCustomView = checkedItem == BRLMPJPrintSettingsPaperSizeStandard.custom.name
                    widthDots = String(paperSizeItem?.customPaper?.widthDots ?? 0)
                    lengthDots = String(paperSizeItem?.customPaper?.lengthDots ?? 0)
                })
        })
    }
}

struct RJAndTDCustomPaperView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var delegate: PrintSettingsViewDelegate?
    @Binding var dataSource: PrintSettingsViewModel
    var item: PrintSettingItemType
    var itemList: [String]
    @State var paperSizeItem: BRLMCustomPaperSize?
    @State var checkedItem: String?
    @State var editFieldList: [CustomPaperType] = []
    @State var tapeWidth = ""
    @State var tapeLength = ""
    @State var marginTop = ""
    @State var marginLeft = ""
    @State var marginBottom = ""
    @State var marginRight = ""
    @State var markVerticalOffset = ""
    @State var markLength = ""
    @State var gapLength = ""
    @State var energyRankUnspecified = true
    @State var energyRank = ""
    @State var unit: BRLMCustomPaperSizeLengthUnit = .inch
    @Binding var filePath: String
    var body: some View {
        List(content: {
            Section(content: {
                ForEach(itemList, id: \.self, content: { value in
                    Button(action: {
                        checkedItem = value
                        editFieldList = BRLMCustomPaperSizePaperKind.allCases().first(where: { $0.name == value })?.editList ?? []
                    }, label: {
                        HStack {
                            Text(value)
                            Spacer()
                            if value == checkedItem {
                                Image(systemName: "checkmark")
                            }
                        }
                    }).foregroundColor(.black)
                })
            })
            if editFieldList.contains(.TAPEWIDTH) {
                Section(content: {
                    TextField("", text: $tapeWidth)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                }, header: {
                    Text(CustomPaperType.TAPEWIDTH.rawValue)
                })
            }
            if editFieldList.contains(.TAPELENGTH) {
                Section(content: {
                    TextField("", text: $tapeLength)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                }, header: {
                    Text(CustomPaperType.TAPELENGTH.rawValue)
                })
            }
            if editFieldList.contains(.MARGINS) {
                Section(content: {
                    VStack {
                        HStack {
                            Text("top").frame(width: 100)
                            TextField("", text: $marginTop)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                        }
                        HStack {
                            Text("left").frame(width: 100)
                            TextField("", text: $marginLeft)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                        }
                        HStack {
                            Text("bottom").frame(width: 100)
                            TextField("", text: $marginBottom)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                        }
                        HStack {
                            Text("right").frame(width: 100)
                            TextField("", text: $marginRight)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                        }
                    }
                }, header: {
                    Text(CustomPaperType.MARGINS.rawValue)
                })
            }
            if editFieldList.contains(.MARKLENGHT) {
                Section(content: {
                    TextField("", text: $markLength)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                }, header: {
                    Text(CustomPaperType.MARKLENGHT.rawValue)
                })
            }
            if editFieldList.contains(.MARKVERTICALOFFSET) {
                Section(content: {
                    TextField("", text: $markVerticalOffset)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                }, header: {
                    Text(CustomPaperType.MARKVERTICALOFFSET.rawValue)
                })
            }
            if editFieldList.contains(.GAPLENGTH) {
                Section(content: {
                    TextField("", text: $gapLength)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                }, header: {
                    Text(CustomPaperType.GAPLENGTH.rawValue)
                })
            }
            if editFieldList.contains(.FILEPATH) {
                Section(content: {
                    Button(action: {
                        delegate?.selectFilePathButtonDidTap()
                    }, label: {
                        Text(filePath.isEmpty ? "selectFile" : filePath).foregroundColor(.black)
                    })
                }, header: {
                    Text(CustomPaperType.FILEPATH.rawValue)
                })
            }
            if editFieldList.contains(.UNIT) {
                Section(content: {
                    Picker(selection: $unit, content: {
                        ForEach(BRLMCustomPaperSizeLengthUnit.allCases(), id: \.self, content: { value in
                            Button(action: {
                                unit = value
                            }, label: {
                                HStack {
                                    Text(value.name)
                                }
                            })
                        })
                    }, label: {
                        EmptyView()
                    }).pickerStyle(SegmentedPickerStyle())
                }, header: {
                    Text(CustomPaperType.UNIT.rawValue)
                })
            }
            if editFieldList.contains(.ENERGYRANK) {
                Section(content: {
                    VStack {
                        Toggle("Unspecified", isOn: $energyRankUnspecified)
                        if !energyRankUnspecified {
                            TextField("", text: $energyRank)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                        }
                    }
                }, header: {
                    Text(CustomPaperType.ENERGYRANK.rawValue)
                })
            }
        })
        .navigationBarTitle(Text(item.title), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            if checkedItem == BRLMCustomPaperSizePaperKind.roll.name {
                if energyRankUnspecified {
                    dataSource.setSettingsData(
                        key: item,
                        value: BRLMCustomPaperSize(
                            rollWithTapeWidth: CGFloat(Double(tapeWidth) ?? 0),
                            margins: BRLMCustomPaperSizeMargins(
                                top: CGFloat(Double(marginTop) ?? 0),
                                left: CGFloat(Double(marginLeft) ?? 0),
                                bottom: CGFloat(Double(marginBottom) ?? 0),
                                right: CGFloat(Double(marginRight) ?? 0)
                            ),
                            unitOfLength: unit
                        )
                    )
                } else {
                    dataSource.setSettingsData(
                        key: item,
                        value: BRLMCustomPaperSize(
                            rollWithTapeWidth: CGFloat(Double(tapeWidth) ?? 0),
                            margins: BRLMCustomPaperSizeMargins(
                                top: CGFloat(Double(marginTop) ?? 0),
                                left: CGFloat(Double(marginLeft) ?? 0),
                                bottom: CGFloat(Double(marginBottom) ?? 0),
                                right: CGFloat(Double(marginRight) ?? 0)
                            ),
                            unitOfLength: unit,
                            energyRank: UInt32(energyRank) ?? 0
                        )
                    )
                }
            } else if checkedItem == BRLMCustomPaperSizePaperKind.dieCut.name {
                if energyRankUnspecified {
                    dataSource.setSettingsData(
                        key: item,
                        value: BRLMCustomPaperSize(
                            dieCutWithTapeWidth: CGFloat(Double(tapeWidth) ?? 0),
                            tapeLength: CGFloat(Double(tapeLength) ?? 0),
                            margins: BRLMCustomPaperSizeMargins(
                                top: CGFloat(Double(marginTop) ?? 0),
                                left: CGFloat(Double(marginLeft) ?? 0),
                                bottom: CGFloat(Double(marginBottom) ?? 0),
                                right: CGFloat(Double(marginRight) ?? 0)
                            ),
                            gapLength: CGFloat(Double(gapLength) ?? 0),
                            unitOfLength: unit
                        )
                    )
                } else {
                    dataSource.setSettingsData(
                        key: item,
                        value: BRLMCustomPaperSize(
                            dieCutWithTapeWidth: CGFloat(Double(tapeWidth) ?? 0),
                            tapeLength: CGFloat(Double(tapeLength) ?? 0),
                            margins: BRLMCustomPaperSizeMargins(
                                top: CGFloat(Double(marginTop) ?? 0),
                                left: CGFloat(Double(marginLeft) ?? 0),
                                bottom: CGFloat(Double(marginBottom) ?? 0),
                                right: CGFloat(Double(marginRight) ?? 0)
                            ),
                            gapLength: CGFloat(Double(gapLength) ?? 0),
                            unitOfLength: unit,
                            energyRank: UInt32(energyRank) ?? 0
                        )
                    )
                }
            } else if checkedItem == BRLMCustomPaperSizePaperKind.markRoll.name {
                if energyRankUnspecified {
                    dataSource.setSettingsData(
                        key: item,
                        value: BRLMCustomPaperSize(
                            markRollWithTapeWidth: CGFloat(Double(tapeWidth) ?? 0),
                            tapeLength: CGFloat(Double(tapeLength) ?? 0),
                            margins: BRLMCustomPaperSizeMargins(
                                top: CGFloat(Double(marginTop) ?? 0),
                                left: CGFloat(Double(marginLeft) ?? 0),
                                bottom: CGFloat(Double(marginBottom) ?? 0),
                                right: CGFloat(Double(marginRight) ?? 0)
                            ),
                            markPosition: CGFloat(Double(markVerticalOffset) ?? 0),
                            markHeight: CGFloat(Double(markLength) ?? 0),
                            unitOfLength: unit
                        )
                    )
                } else {
                    dataSource.setSettingsData(
                        key: item,
                        value: BRLMCustomPaperSize(
                            markRollWithTapeWidth: CGFloat(Double(tapeWidth) ?? 0),
                            tapeLength: CGFloat(Double(tapeLength) ?? 0),
                            margins: BRLMCustomPaperSizeMargins(
                                top: CGFloat(Double(marginTop) ?? 0),
                                left: CGFloat(Double(marginLeft) ?? 0),
                                bottom: CGFloat(Double(marginBottom) ?? 0),
                                right: CGFloat(Double(marginRight) ?? 0)
                            ),
                            markPosition: CGFloat(Double(markVerticalOffset) ?? 0),
                            markHeight: CGFloat(Double(markLength) ?? 0),
                            unitOfLength: unit,
                            energyRank: UInt32(energyRank) ?? 0
                        )
                    )
                }
            } else if checkedItem == BRLMCustomPaperSizePaperKind.byFile.name {
                dataSource.setSettingsData(
                    key: item,
                    value: BRLMCustomPaperSize(file: URL(fileURLWithPath: filePath))
                )
            }
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("ok")
        })).onAppear(perform: {
            DispatchQueue.main.async {
                editFieldList = paperSizeItem?.paperKind.editList ?? []
                tapeWidth = "\(String(describing: paperSizeItem?.tapeWidth ?? 0))"
                tapeLength = "\(String(describing: paperSizeItem?.tapeLength ?? 0))"
                marginTop = "\(String(describing: paperSizeItem?.margins.top ?? 0))"
                marginLeft = "\(String(describing: paperSizeItem?.margins.left ?? 0))"
                marginBottom = "\(String(describing: paperSizeItem?.margins.bottom ?? 0))"
                marginRight = "\(String(describing: paperSizeItem?.margins.right ?? 0))"
                unit = paperSizeItem?.unit ?? .inch
                gapLength = "\(String(describing: paperSizeItem?.gapLength ?? 0))"
                markLength = "\(String(describing: paperSizeItem?.markLength ?? 0))"
                markVerticalOffset = "\(String(describing: paperSizeItem?.markVerticalOffset ?? 0))"
                filePath = paperSizeItem?.paperBinFilePath?.path ?? ""
                energyRankUnspecified = (paperSizeItem?.energyRank == nil)
                energyRank = paperSizeItem?.energyRank?.stringValue ?? ""
            }
        })
    }
}

enum CustomPaperType: String {
    case TAPEWIDTH = "TapeWidth"
    case TAPELENGTH = "TapeLength"
    case MARGINS = "Margins"
    case UNIT = "Unit"
    case GAPLENGTH = "GapLenght"
    case MARKLENGHT = "MarkLength"
    case MARKVERTICALOFFSET = "MarkVerticalOffset"
    case FILEPATH = "FilePath"
    case ENERGYRANK = "EnergyRank"
} // swiftlint:disable:this file_length
