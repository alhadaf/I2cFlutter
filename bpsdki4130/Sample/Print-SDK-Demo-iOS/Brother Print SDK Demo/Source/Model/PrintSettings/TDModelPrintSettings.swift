//
//  TDModelPrintSettings.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/9.
//

import BRLMPrinterKit
import Foundation

class TDModelTemplatePrintSettings: ISimpleTemplatePrintSettings {
    var templateSettingItemData: [TemplateSettingItemData]?
    var printerModel: PrinterModel
    private var tdTemplateSettings: BRLMTDTemplatePrintSettings?
    init(printerModel: PrinterModel, templateSettingItemData: [TemplateSettingItemData] = []) {
        self.printerModel = printerModel
        if let settings = BRLMTDTemplatePrintSettings(defaultPrintSettingsWith: printerModel.printerModel) {
            self.tdTemplateSettings = settings
            self.templateSettingItemData = []
            self.templateSettingItemData?.append(TemplateSettingItemData(key: .PRINTER_MODEL, value: printerModel.rawValue))
            self.templateSettingItemData?.append(TemplateSettingItemData(key: .PEEL_LABEL, value: settings.peelLabel ? "ON" : "OFF"))
            self.templateSettingItemData?.append(TemplateSettingItemData(key: .NUM_COPIES, value: settings.numCopies.description))
        }
    }

    func fetchSettingItemList(key: TemplatePrintSettingItemType) -> [String] {
        var itemList: [String] = []
        switch key {
        case .PEEL_LABEL:
            itemList = ["ON", "OFF"]
        case .PRINTER_MODEL, .NUM_COPIES:
            return []
        }
        return itemList
    }
    
    func setSettingInfo(key: TemplatePrintSettingItemType, message: Any) {
        switch key {
        case .PEEL_LABEL:
            tdTemplateSettings?.peelLabel = (message as? String) == "ON"
        case .NUM_COPIES:
            if let value = message as? String, let numCopies = UInt(value) {
                tdTemplateSettings?.numCopies = numCopies
            }
        case .PRINTER_MODEL: break
        }
    }
    
    func fetchPrintSettings() -> BRLMTemplatePrintSettingsProtocol? {
        return tdTemplateSettings
    }
}


class TDModelPrintSettings: ISimplePrintSettings {
    var settingsData: [SettingItemData]?
    var printerModel: PrinterModel
    private var tdSettings: BRLMTDPrintSettings?

    init(printerModel: PrinterModel, settingsData: [SettingItemData] = []) {
        self.printerModel = printerModel
        if let settings = BRLMTDPrintSettings(defaultPrintSettingsWith: printerModel.printerModel) {
            self.tdSettings = settings
            self.settingsData = []
            self.settingsData?.append(SettingItemData(key: .PRINTER_MODEL, value: printerModel.rawValue))
            self.settingsData?.append(
                SettingItemData(key: .CUSTOM_PAPER_SIZE, value: settings.customPaperSize)
            )
            self.settingsData?.append(
                SettingItemData(key: .SCALE_MODE, value: settings.scaleMode.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .SCALE_VALUE, value: settings.scaleValue.description)
            )
            self.settingsData?.append(
                SettingItemData(key: .ORIENTATION, value: settings.printOrientation.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .ROTATION, value: settings.imageRotation.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .HALFTONE, value: settings.halftone.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .HORIZONTAL_ALIGNMENT, value: settings.hAlignment.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .VERTICAL_ALIGNMENT, value: settings.vAlignment.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .COMPRESS_MODE, value: settings.compress.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .HALFTONE_THRESHOLD, value: settings.halftoneThreshold.description)
            )
            self.settingsData?.append(
                SettingItemData(key: .NUM_COPIES, value: settings.numCopies.description)
            )
            self.settingsData?.append(
                SettingItemData(key: .SKIP_STATUS_CHECK, value: settings.skipStatusCheck ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .PRINT_QUALITY, value: settings.printQuality.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .TRIM_TRAILING_BLANK_DATA, value: settings.trimTrailingBlankData ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .DENSITY, value: settings.density.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .PEEL_LABEL, value: settings.peelLabel ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .AUTO_CUT, value: settings.autoCut ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .CUT_AT_END, value: settings.cutAtEnd ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .AUTO_CUT_FOR_EACH_PAGE_COUNT, value: settings.autoCutForEachPageCount.description)
            )
            self.settingsData?.append(
                SettingItemData(key: .FEED_DIRECTION_MARGINS, value: settings.feedDirectionMargins.description)
            )
            self.settingsData?.append(
                SettingItemData(key: .CUSTOM_RECORD, value: settings.customRecord.description)
            )
        }
    }

    func fetchSettingItemList(key: PrintSettingItemType) -> [String] {
        var itemList: [String] = []
        switch key {
        case .CUSTOM_PAPER_SIZE:
            itemList = BRLMCustomPaperSizePaperKind.allCases().map({ $0.name })
        case .SCALE_MODE:
            itemList = BRLMPrintSettingsScaleMode.allCases().map({ $0.name })
        case .ORIENTATION:
            itemList = BRLMPrintSettingsOrientation.allCases().map({ $0.name })
        case .ROTATION:
            itemList = BRLMPrintSettingsRotation.allCases().map({ $0.name })
        case .HALFTONE:
            itemList = BRLMPrintSettingsHalftone.allCases().map({ $0.name })
        case .HORIZONTAL_ALIGNMENT:
            itemList = BRLMPrintSettingsHorizontalAlignment.allCases().map({ $0.name })
        case .VERTICAL_ALIGNMENT:
            itemList = BRLMPrintSettingsVerticalAlignment.allCases().map({ $0.name })
        case .COMPRESS_MODE:
            itemList = BRLMPrintSettingsCompressMode.allCases().map({ $0.name })
        case .SKIP_STATUS_CHECK:
            itemList = ["ON", "OFF"]
        case .PRINT_QUALITY:
            itemList = BRLMPrintSettingsPrintQuality.allCases().map({ $0.name })
        case .TRIM_TRAILING_BLANK_DATA:
            itemList = ["ON", "OFF"]
        case .DENSITY:
            itemList = BRLMTDPrintSettingsDensity.allCases().map({ $0.name })
        case .PEEL_LABEL:
            itemList = ["ON", "OFF"]
        case .AUTO_CUT:
            itemList = ["ON", "OFF"]
        case .CUT_AT_END:
            itemList = ["ON", "OFF"]
        default:
            itemList = []
        }
        return itemList
    }

    func setSettingInfo(key: PrintSettingItemType, message: Any) { // swiftlint:disable:this cyclomatic_complexity function_body_length
        switch key {
        case .CUSTOM_PAPER_SIZE:
            if let paperSize = message as? BRLMCustomPaperSize {
                tdSettings?.customPaperSize = paperSize
            }
        case .SCALE_MODE:
            if let value = BRLMPrintSettingsScaleMode.allCases().first(where: { $0.name == message as? String }) {
                tdSettings?.scaleMode = value
            }
        case .SCALE_VALUE:
            if let value = message as? String, let scaleValue = Double(value) {
                tdSettings?.scaleValue = CGFloat(scaleValue)
            }
        case .ORIENTATION:
            if let value = BRLMPrintSettingsOrientation.allCases().first(where: { $0.name == message as? String }) {
                tdSettings?.printOrientation = value
            }
        case .ROTATION:
            if let value = BRLMPrintSettingsRotation.allCases().first(where: { $0.name == message as? String }) {
                tdSettings?.imageRotation = value
            }
        case .HALFTONE:
            if let value = BRLMPrintSettingsHalftone.allCases().first(where: { $0.name == message as? String }) {
                tdSettings?.halftone = value
            }
        case .HORIZONTAL_ALIGNMENT:
            if let value = BRLMPrintSettingsHorizontalAlignment.allCases().first(where: { $0.name == message as? String }) {
                tdSettings?.hAlignment = value
            }
        case .VERTICAL_ALIGNMENT:
            if let value = BRLMPrintSettingsVerticalAlignment.allCases().first(where: { $0.name == message as? String }) {
                tdSettings?.vAlignment = value
            }
        case .COMPRESS_MODE:
            if let value = BRLMPrintSettingsCompressMode.allCases().first(where: { $0.name == message as? String }) {
                tdSettings?.compress = value
            }
        case .HALFTONE_THRESHOLD:
            if let value = message as? String, let halftoneThreshold = UInt8(value) {
                tdSettings?.halftoneThreshold = halftoneThreshold
            }
        case .NUM_COPIES:
            if let value = message as? String, let numCopies = UInt(value) {
                tdSettings?.numCopies = numCopies
            }
        case .SKIP_STATUS_CHECK:
            tdSettings?.skipStatusCheck = (message as? String) == "ON"
        case .PRINT_QUALITY:
            if let value = BRLMPrintSettingsPrintQuality.allCases().first(where: { $0.name == message as? String }) {
                tdSettings?.printQuality = value
            }
        case .TRIM_TRAILING_BLANK_DATA:
            tdSettings?.trimTrailingBlankData = (message as? String) == "ON"
        case .DENSITY:
            if let value = BRLMTDPrintSettingsDensity.allCases().first(where: { $0.name == message as? String }) {
                tdSettings?.density = value
            }
        case .PEEL_LABEL:
            tdSettings?.peelLabel = (message as? String) == "ON"
        case .AUTO_CUT:
            tdSettings?.autoCut = (message as? String) == "ON"
        case .CUT_AT_END:
            tdSettings?.cutAtEnd = (message as? String) == "ON"
        case .AUTO_CUT_FOR_EACH_PAGE_COUNT:
            if let value = message as? String, let autoCutForEachPageCount = UInt8(value) {
                tdSettings?.autoCutForEachPageCount = autoCutForEachPageCount
            }
        case .FEED_DIRECTION_MARGINS:
            if let value = message as? String, let feedDirectionMargins = UInt(value) {
                tdSettings?.feedDirectionMargins = feedDirectionMargins
            }
        case .CUSTOM_RECORD:
            tdSettings?.customRecord = (message as? String) ?? ""
        default:
            break
        }
    }

    func fetchPrintSettings() -> BRLMPrintSettingsProtocol? {
        return tdSettings
    }

    func validateSettings(callback: @escaping (BRLMValidatePrintSettingsReport) -> Void) {
        if let settings = tdSettings {
            let report = BRLMValidatePrintSettings.validate(settings)
            callback(report)
        }
    }
}
