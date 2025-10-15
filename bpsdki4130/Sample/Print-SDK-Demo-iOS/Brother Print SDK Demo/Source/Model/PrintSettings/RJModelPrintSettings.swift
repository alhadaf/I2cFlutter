//
//  RJModelPrintSettings.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/9.
//

import BRLMPrinterKit
import Foundation


class RJModelTemplatePrintSettings: ISimpleTemplatePrintSettings {
    var templateSettingItemData: [TemplateSettingItemData]?
    var printerModel: PrinterModel
    private var rjTemplateSettings: BRLMRJTemplatePrintSettings?
    init(printerModel: PrinterModel, templateSettingItemData: [TemplateSettingItemData] = []) {
        self.printerModel = printerModel
        if let settings = BRLMRJTemplatePrintSettings(defaultPrintSettingsWith: printerModel.printerModel) {
            self.rjTemplateSettings = settings
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
            rjTemplateSettings?.peelLabel = (message as? String) == "ON"
        case .NUM_COPIES:
            if let value = message as? String, let numCopies = UInt(value) {
                rjTemplateSettings?.numCopies = numCopies
            }
        case .PRINTER_MODEL: break
        }
    }
    
    func fetchPrintSettings() -> BRLMTemplatePrintSettingsProtocol? {
        return rjTemplateSettings
    }
}


class RJModelPrintSettings: ISimplePrintSettings {
    var settingsData: [SettingItemData]?
    var printerModel: PrinterModel
    private var rjSettings: BRLMRJPrintSettings?

    init(printerModel: PrinterModel, settingsData: [SettingItemData] = []) {
        self.printerModel = printerModel
        if let settings = BRLMRJPrintSettings(defaultPrintSettingsWith: printerModel.printerModel) {
            self.rjSettings = settings
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
                SettingItemData(key: .ROTATE180DEGREES, value: settings.rotate180degrees ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .PEEL_LABEL, value: settings.peelLabel ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .FEED_DIRECTION_MARGINS, value: settings.feedDirectionMargins.description)
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
            itemList = BRLMRJPrintSettingsDensity.allCases().map({ $0.name })
        case .ROTATE180DEGREES:
            itemList = ["ON", "OFF"]
        case .PEEL_LABEL:
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
                rjSettings?.customPaperSize = paperSize
            }
        case .SCALE_MODE:
            if let value = BRLMPrintSettingsScaleMode.allCases().first(where: { $0.name == message as? String }) {
                rjSettings?.scaleMode = value
            }
        case .SCALE_VALUE:
            if let value = message as? String, let scaleValue = Double(value) {
                rjSettings?.scaleValue = CGFloat(scaleValue)
            }
        case .ORIENTATION:
            if let value = BRLMPrintSettingsOrientation.allCases().first(where: { $0.name == message as? String }) {
                rjSettings?.printOrientation = value
            }
        case .ROTATION:
            if let value = BRLMPrintSettingsRotation.allCases().first(where: { $0.name == message as? String }) {
                rjSettings?.imageRotation = value
            }
        case .HALFTONE:
            if let value = BRLMPrintSettingsHalftone.allCases().first(where: { $0.name == message as? String }) {
                rjSettings?.halftone = value
            }
        case .HORIZONTAL_ALIGNMENT:
            if let value = BRLMPrintSettingsHorizontalAlignment.allCases().first(where: { $0.name == message as? String }) {
                rjSettings?.hAlignment = value
            }
        case .VERTICAL_ALIGNMENT:
            if let value = BRLMPrintSettingsVerticalAlignment.allCases().first(where: { $0.name == message as? String }) {
                rjSettings?.vAlignment = value
            }
        case .COMPRESS_MODE:
            if let value = BRLMPrintSettingsCompressMode.allCases().first(where: { $0.name == message as? String }) {
                rjSettings?.compress = value
            }
        case .HALFTONE_THRESHOLD:
            if let value = message as? String, let halftoneThreshold = UInt8(value) {
                rjSettings?.halftoneThreshold = halftoneThreshold
            }
        case .NUM_COPIES:
            if let value = message as? String, let numCopies = UInt(value) {
                rjSettings?.numCopies = numCopies
            }
        case .SKIP_STATUS_CHECK:
            rjSettings?.skipStatusCheck = (message as? String) == "ON"
        case .PRINT_QUALITY:
            if let value = BRLMPrintSettingsPrintQuality.allCases().first(where: { $0.name == message as? String }) {
                rjSettings?.printQuality = value
            }
        case .TRIM_TRAILING_BLANK_DATA:
            rjSettings?.trimTrailingBlankData = (message as? String) == "ON"
        case .DENSITY:
            if let value = BRLMRJPrintSettingsDensity.allCases().first(where: { $0.name == message as? String }) {
                rjSettings?.density = value
            }
        case .ROTATE180DEGREES:
            rjSettings?.rotate180degrees = (message as? String) == "ON"
        case .PEEL_LABEL:
            rjSettings?.peelLabel = (message as? String) == "ON"
        case .FEED_DIRECTION_MARGINS:
            if let value = message as? String, let feedDirectionMargins = UInt(value) {
                rjSettings?.feedDirectionMargins = feedDirectionMargins
            }
        default:
            break
        }
    }

    func fetchPrintSettings() -> BRLMPrintSettingsProtocol? {
        return rjSettings
    }

    func validateSettings(callback: @escaping (BRLMValidatePrintSettingsReport) -> Void) {
        if let settings = rjSettings {
            let report = BRLMValidatePrintSettings.validate(settings)
            callback(report)
        }
    }
}
