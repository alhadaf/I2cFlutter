//
//  QLModelPrintSettings.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/9.
//

import BRLMPrinterKit
import Foundation

class QLModelTemplatePrintSettings: ISimpleTemplatePrintSettings {
    var templateSettingItemData: [TemplateSettingItemData]?
    var printerModel: PrinterModel
    private var qlTemplateSettings: BRLMQLTemplatePrintSettings?
    init(printerModel: PrinterModel, templateSettingItemData: [TemplateSettingItemData] = []) {
        self.printerModel = printerModel
        if let settings = BRLMQLTemplatePrintSettings(defaultPrintSettingsWith: printerModel.printerModel) {
            self.qlTemplateSettings = settings
            self.templateSettingItemData = []
            self.templateSettingItemData?.append(TemplateSettingItemData(key: .PRINTER_MODEL, value: printerModel.rawValue))
            self.templateSettingItemData?.append(TemplateSettingItemData(key: .NUM_COPIES, value: settings.numCopies.description))
        }
    }

    func fetchSettingItemList(key: TemplatePrintSettingItemType) -> [String] {
        let itemList: [String] = []
        switch key {
        case .PRINTER_MODEL, .NUM_COPIES, .PEEL_LABEL:
            return itemList
        }
    }
    
    func setSettingInfo(key: TemplatePrintSettingItemType, message: Any) {
        switch key {
        case .NUM_COPIES:
            if let value = message as? String, let numCopies = UInt(value) {
                qlTemplateSettings?.numCopies = numCopies
            }
        case .PRINTER_MODEL, .PEEL_LABEL: break
        }
    }
    
    func fetchPrintSettings() -> BRLMTemplatePrintSettingsProtocol? {
        return qlTemplateSettings
    }
}

class QLModelPrintSettings: ISimplePrintSettings {
    var settingsData: [SettingItemData]?
    var printerModel: PrinterModel
    private var qlSettings: BRLMQLPrintSettings?

    init(printerModel: PrinterModel, settingsData: [SettingItemData] = []) {
        self.printerModel = printerModel
        if let settings = BRLMQLPrintSettings(defaultPrintSettingsWith: printerModel.printerModel) {
            self.qlSettings = settings
            self.settingsData = []
            self.settingsData?.append(SettingItemData(key: .PRINTER_MODEL, value: printerModel.rawValue))
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
                SettingItemData(key: .LABEL_SIZE, value: settings.labelSize.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .AUTO_CUT_FOR_EACH_PAGE_COUNT, value: settings.autoCutForEachPageCount.description)
            )
            self.settingsData?.append(
                SettingItemData(key: .AUTO_CUT, value: settings.autoCut ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .CUT_AT_END, value: settings.cutAtEnd ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .RESOLUTION, value: settings.resolution.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .BI_COLOR_RED_ENHANCEMENT, value: settings.biColorRedEnhancement.description)
            )
            self.settingsData?.append(
                SettingItemData(key: .BI_COLOR_GREEN_ENHANCEMENT, value: settings.biColorGreenEnhancement.description)
            )
            self.settingsData?.append(
                SettingItemData(key: .BI_COLOR_BLUE_ENHANCEMENT, value: settings.biColorBlueEnhancement.description)
            )
            self.settingsData?.append(
                SettingItemData(key: .FEED_DIRECTION_MARGINS, value: settings.feedDirectionMargins.description)
            )
        }
    }

    func fetchSettingItemList(key: PrintSettingItemType) -> [String] {
        var itemList: [String] = []
        switch key {
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
        case .LABEL_SIZE:
            itemList = BRLMQLPrintSettingsLabelSize.allCases().map({ $0.name })
        case .AUTO_CUT:
            itemList = ["ON", "OFF"]
        case .CUT_AT_END:
            itemList = ["ON", "OFF"]
        case .RESOLUTION:
            itemList = BRLMPrintSettingsResolution.allCases().map({ $0.name })
        default:
            itemList = []
        }
        return itemList
    }

    func setSettingInfo(key: PrintSettingItemType, message: Any) { // swiftlint:disable:this cyclomatic_complexity function_body_length
        switch key {
        case .SCALE_MODE:
            if let value = BRLMPrintSettingsScaleMode.allCases().first(where: { $0.name == message as? String }) {
                qlSettings?.scaleMode = value
            }
        case .SCALE_VALUE:
            if let value = message as? String, let scaleValue = Double(value) {
                qlSettings?.scaleValue = CGFloat(scaleValue)
            }
        case .ORIENTATION:
            if let value = BRLMPrintSettingsOrientation.allCases().first(where: { $0.name == message as? String }) {
                qlSettings?.printOrientation = value
            }
        case .ROTATION:
            if let value = BRLMPrintSettingsRotation.allCases().first(where: { $0.name == message as? String }) {
                qlSettings?.imageRotation = value
            }
        case .HALFTONE:
            if let value = BRLMPrintSettingsHalftone.allCases().first(where: { $0.name == message as? String }) {
                qlSettings?.halftone = value
            }
        case .HORIZONTAL_ALIGNMENT:
            if let value = BRLMPrintSettingsHorizontalAlignment.allCases().first(where: { $0.name == message as? String }) {
                qlSettings?.hAlignment = value
            }
        case .VERTICAL_ALIGNMENT:
            if let value = BRLMPrintSettingsVerticalAlignment.allCases().first(where: { $0.name == message as? String }) {
                qlSettings?.vAlignment = value
            }
        case .COMPRESS_MODE:
            if let value = BRLMPrintSettingsCompressMode.allCases().first(where: { $0.name == message as? String }) {
                qlSettings?.compress = value
            }
        case .HALFTONE_THRESHOLD:
            if let value = message as? String, let halftoneThreshold = UInt8(value) {
                qlSettings?.halftoneThreshold = halftoneThreshold
            }
        case .NUM_COPIES:
            if let value = message as? String, let numCopies = UInt(value) {
                qlSettings?.numCopies = numCopies
            }
        case .SKIP_STATUS_CHECK:
            qlSettings?.skipStatusCheck = (message as? String) == "ON"
        case .PRINT_QUALITY:
            if let value = BRLMPrintSettingsPrintQuality.allCases().first(where: { $0.name == message as? String }) {
                qlSettings?.printQuality = value
            }
        case .TRIM_TRAILING_BLANK_DATA:
            qlSettings?.trimTrailingBlankData = (message as? String) == "ON"
        case .LABEL_SIZE:
            if let value = BRLMQLPrintSettingsLabelSize.allCases().first(where: { $0.name == message as? String }) {
                qlSettings?.labelSize = value
            }
        case .AUTO_CUT_FOR_EACH_PAGE_COUNT:
            if let value = message as? String, let autoCutForEachPageCount = UInt8(value) {
                qlSettings?.autoCutForEachPageCount = autoCutForEachPageCount
            }
        case .AUTO_CUT:
            qlSettings?.autoCut = (message as? String) == "ON"
        case .CUT_AT_END:
            qlSettings?.cutAtEnd = (message as? String) == "ON"
        case .RESOLUTION:
            if let value = BRLMPrintSettingsResolution.allCases().first(where: { $0.name == message as? String }) {
                qlSettings?.resolution = value
            }
        case .BI_COLOR_RED_ENHANCEMENT:
            if let value = message as? String, let biColorRedEnhancement = UInt(value) {
                qlSettings?.biColorRedEnhancement = biColorRedEnhancement
            }
        case .BI_COLOR_GREEN_ENHANCEMENT:
            if let value = message as? String, let biColorGreenEnhancement = UInt(value) {
                qlSettings?.biColorGreenEnhancement = biColorGreenEnhancement
            }
        case .BI_COLOR_BLUE_ENHANCEMENT:
            if let value = message as? String, let biColorBlueEnhancement = UInt(value) {
                qlSettings?.biColorBlueEnhancement = biColorBlueEnhancement
            }
        case .FEED_DIRECTION_MARGINS:
            if let value = message as? String, let feedDirectionMargins = UInt(value) {
                qlSettings?.feedDirectionMargins = feedDirectionMargins
            }
        default:
            break
        }
    }

    func fetchPrintSettings() -> BRLMPrintSettingsProtocol? {
        return qlSettings
    }

    func validateSettings(callback: @escaping (BRLMValidatePrintSettingsReport) -> Void) {
        if let settings = qlSettings {
            let report = BRLMValidatePrintSettings.validate(settings)
            callback(report)
        }
    }
}
