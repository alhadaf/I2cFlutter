//
//  MWModelPrintSettings.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/1.
//

import BRLMPrinterKit
import Foundation

class MWModelTemplatePrintSettings: ISimpleTemplatePrintSettings {
    var templateSettingItemData: [TemplateSettingItemData]?
    var printerModel: PrinterModel
    private var mwTemplateSettings: BRLMMWTemplatePrintSettings?
    init(printerModel: PrinterModel, templateSettingItemData: [TemplateSettingItemData] = []) {
        self.printerModel = printerModel
        if let settings = BRLMMWTemplatePrintSettings(defaultPrintSettingsWith: printerModel.printerModel) {
            self.mwTemplateSettings = settings
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
                mwTemplateSettings?.numCopies = numCopies
            }
        case .PRINTER_MODEL, .PEEL_LABEL: break
        }
    }
    
    func fetchPrintSettings() -> BRLMTemplatePrintSettingsProtocol? {
        return mwTemplateSettings
    }
}

class MWModelPrintSettings: ISimplePrintSettings {
    var settingsData: [SettingItemData]?
    var printerModel: PrinterModel
    private var mwSettings: BRLMMWPrintSettings?

    init(printerModel: PrinterModel, settingsData: [SettingItemData] = []) {
        self.printerModel = printerModel
        if let settings = BRLMMWPrintSettings(defaultPrintSettingsWith: printerModel.printerModel) {
            self.mwSettings = settings
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
                SettingItemData(key: .PAPER_SIZE, value: settings.paperSize.name)
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
        case .PAPER_SIZE:
            itemList = BRLMMWPrintSettingsPaperSize.allCases().map({ $0.name })
        default:
            itemList = []
        }
        return itemList
    }

    func setSettingInfo(key: PrintSettingItemType, message: Any) { // swiftlint:disable:this cyclomatic_complexity function_body_length
        switch key {
        case .SCALE_MODE:
            if let value = BRLMPrintSettingsScaleMode.allCases().first(where: { $0.name == message as? String }) {
                mwSettings?.scaleMode = value
            }
        case .SCALE_VALUE:
            if let value = message as? String, let scaleValue = Double(value) {
                mwSettings?.scaleValue = CGFloat(scaleValue)
            }
        case .ORIENTATION:
            if let value = BRLMPrintSettingsOrientation.allCases().first(where: { $0.name == message as? String }) {
                mwSettings?.printOrientation = value
            }
        case .ROTATION:
            if let value = BRLMPrintSettingsRotation.allCases().first(where: { $0.name == message as? String }) {
                mwSettings?.imageRotation = value
            }
        case .HALFTONE:
            if let value = BRLMPrintSettingsHalftone.allCases().first(where: { $0.name == message as? String }) {
                mwSettings?.halftone = value
            }
        case .HORIZONTAL_ALIGNMENT:
            if let value = BRLMPrintSettingsHorizontalAlignment.allCases().first(where: { $0.name == message as? String }) {
                mwSettings?.hAlignment = value
            }
        case .VERTICAL_ALIGNMENT:
            if let value = BRLMPrintSettingsVerticalAlignment.allCases().first(where: { $0.name == message as? String }) {
                mwSettings?.vAlignment = value
            }
        case .COMPRESS_MODE:
            if let value = BRLMPrintSettingsCompressMode.allCases().first(where: { $0.name == message as? String }) {
                mwSettings?.compress = value
            }
        case .HALFTONE_THRESHOLD:
            if let value = message as? String, let halftoneThreshold = UInt8(value) {
                mwSettings?.halftoneThreshold = halftoneThreshold
            }
        case .NUM_COPIES:
            if let value = message as? String, let numCopies = UInt(value) {
                mwSettings?.numCopies = numCopies
            }
        case .SKIP_STATUS_CHECK:
            mwSettings?.skipStatusCheck = (message as? String) == "ON"
        case .PRINT_QUALITY:
            if let value = BRLMPrintSettingsPrintQuality.allCases().first(where: { $0.name == message as? String }) {
                mwSettings?.printQuality = value
            }
        case .TRIM_TRAILING_BLANK_DATA:
            mwSettings?.trimTrailingBlankData = (message as? String) == "ON"
        default:
            break
        }
    }

    func fetchPrintSettings() -> BRLMPrintSettingsProtocol? {
        return mwSettings
    }

    func validateSettings(callback: @escaping (BRLMValidatePrintSettingsReport) -> Void) {
        if let settings = mwSettings {
            let report = BRLMValidatePrintSettings.validate(settings)
            callback(report)
        }
    }
}
