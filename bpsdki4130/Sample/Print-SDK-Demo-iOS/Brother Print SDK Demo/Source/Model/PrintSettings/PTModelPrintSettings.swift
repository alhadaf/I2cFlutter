//
//  PTModelPrintSettings.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/9.
//

import BRLMPrinterKit
import Foundation

class PTModelTemplatePrintSettings: ISimpleTemplatePrintSettings {
    var templateSettingItemData: [TemplateSettingItemData]?
    var printerModel: PrinterModel
    private var ptTemplateSettings: BRLMPTTemplatePrintSettings?
    init(printerModel: PrinterModel, templateSettingItemData: [TemplateSettingItemData] = []) {
        self.printerModel = printerModel
        if let settings = BRLMPTTemplatePrintSettings(defaultPrintSettingsWith: printerModel.printerModel) {
            self.ptTemplateSettings = settings
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
                ptTemplateSettings?.numCopies = numCopies
            }
        case .PRINTER_MODEL, .PEEL_LABEL: break
        }
    }
    
    func fetchPrintSettings() -> BRLMTemplatePrintSettingsProtocol? {
        return ptTemplateSettings
    }
}


class PTModelPrintSettings: ISimplePrintSettings {
    var settingsData: [SettingItemData]?
    var printerModel: PrinterModel
    private var ptSettings: BRLMPTPrintSettings?

    init(printerModel: PrinterModel, settingsData: [SettingItemData] = []) {
        self.printerModel = printerModel
        if let settings = BRLMPTPrintSettings(defaultPrintSettingsWith: printerModel.printerModel) {
            self.ptSettings = settings
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
                SettingItemData(key: .CUTMARK_PRINT, value: settings.cutmarkPrint ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .CUT_PAUSE, value: settings.cutPause ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .AUTO_CUT, value: settings.autoCut ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .HALF_CUT, value: settings.halfCut ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .CHAIN_PRINT, value: settings.chainPrint ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .SPECIAL_TAPE_PRINT, value: settings.specialTapePrint ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .RESOLUTION, value: settings.resolution.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .AUTO_CUT_FOR_EACH_PAGE_COUNT, value: settings.autoCutForEachPageCount.description)
            )
            self.settingsData?.append(
                SettingItemData(key: .FORCE_VANISHING_MARGIN, value: settings.forceVanishingMargin ? "ON" : "OFF")
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
            itemList = BRLMPTPrintSettingsLabelSize.allCases().map({ $0.name })
        case .CUTMARK_PRINT:
            itemList = ["ON", "OFF"]
        case .CUT_PAUSE:
            itemList = ["ON", "OFF"]
        case .AUTO_CUT:
            itemList = ["ON", "OFF"]
        case .HALF_CUT:
            itemList = ["ON", "OFF"]
        case .CHAIN_PRINT:
            itemList = ["ON", "OFF"]
        case .SPECIAL_TAPE_PRINT:
            itemList = ["ON", "OFF"]
        case .RESOLUTION:
            itemList = BRLMPrintSettingsResolution.allCases().map({ $0.name })
        case .FORCE_VANISHING_MARGIN:
            itemList = ["ON", "OFF"]
        default:
            itemList = []
        }
        return itemList
    }

    func setSettingInfo(key: PrintSettingItemType, message: Any) { // swiftlint:disable:this cyclomatic_complexity function_body_length
        switch key {
        case .SCALE_MODE:
            if let value = BRLMPrintSettingsScaleMode.allCases().first(where: { $0.name == message as? String }) {
                ptSettings?.scaleMode = value
            }
        case .SCALE_VALUE:
            if let value = message as? String, let scaleValue = Double(value) {
                ptSettings?.scaleValue = CGFloat(scaleValue)
            }
        case .ORIENTATION:
            if let value = BRLMPrintSettingsOrientation.allCases().first(where: { $0.name == message as? String }) {
                ptSettings?.printOrientation = value
            }
        case .ROTATION:
            if let value = BRLMPrintSettingsRotation.allCases().first(where: { $0.name == message as? String }) {
                ptSettings?.imageRotation = value
            }
        case .HALFTONE:
            if let value = BRLMPrintSettingsHalftone.allCases().first(where: { $0.name == message as? String }) {
                ptSettings?.halftone = value
            }
        case .HORIZONTAL_ALIGNMENT:
            if let value = BRLMPrintSettingsHorizontalAlignment.allCases().first(where: { $0.name == message as? String }) {
                ptSettings?.hAlignment = value
            }
        case .VERTICAL_ALIGNMENT:
            if let value = BRLMPrintSettingsVerticalAlignment.allCases().first(where: { $0.name == message as? String }) {
                ptSettings?.vAlignment = value
            }
        case .COMPRESS_MODE:
            if let value = BRLMPrintSettingsCompressMode.allCases().first(where: { $0.name == message as? String }) {
                ptSettings?.compress = value
            }
        case .HALFTONE_THRESHOLD:
            if let value = message as? String, let halftoneThreshold = UInt8(value) {
                ptSettings?.halftoneThreshold = halftoneThreshold
            }
        case .NUM_COPIES:
            if let value = message as? String, let numCopies = UInt(value) {
                ptSettings?.numCopies = numCopies
            }
        case .SKIP_STATUS_CHECK:
            ptSettings?.skipStatusCheck = (message as? String) == "ON"
        case .PRINT_QUALITY:
            if let value = BRLMPrintSettingsPrintQuality.allCases().first(where: { $0.name == message as? String }) {
                ptSettings?.printQuality = value
            }
        case .TRIM_TRAILING_BLANK_DATA:
            ptSettings?.trimTrailingBlankData = (message as? String) == "ON"
        case .LABEL_SIZE:
            if let value = BRLMPTPrintSettingsLabelSize.allCases().first(where: { $0.name == message as? String }) {
                ptSettings?.labelSize = value
            }
        case .CUTMARK_PRINT:
            ptSettings?.cutmarkPrint = (message as? String) == "ON"
        case .CUT_PAUSE:
            ptSettings?.cutPause = (message as? String) == "ON"
        case .AUTO_CUT:
            ptSettings?.autoCut = (message as? String) == "ON"
        case .HALF_CUT:
            ptSettings?.halfCut = (message as? String) == "ON"
        case .CHAIN_PRINT:
            ptSettings?.chainPrint = (message as? String) == "ON"
        case .SPECIAL_TAPE_PRINT:
            ptSettings?.specialTapePrint = (message as? String) == "ON"
        case .RESOLUTION:
            if let value = BRLMPrintSettingsResolution.allCases().first(where: { $0.name == message as? String }) {
                ptSettings?.resolution = value
            }
        case .AUTO_CUT_FOR_EACH_PAGE_COUNT:
            if let value = message as? String, let autoCutForEachPageCount = UInt8(value) {
                ptSettings?.autoCutForEachPageCount = autoCutForEachPageCount
            }
        case .FORCE_VANISHING_MARGIN:
            ptSettings?.forceVanishingMargin = (message as? String) == "ON"
        case .FEED_DIRECTION_MARGINS:
            if let value = message as? String, let feedDirectionMargins = UInt(value) {
                ptSettings?.feedDirectionMargins = feedDirectionMargins
            }
        default:
            break
        }
    }

    func fetchPrintSettings() -> BRLMPrintSettingsProtocol? {
        return ptSettings
    }

    func validateSettings(callback: @escaping (BRLMValidatePrintSettingsReport) -> Void) {
        if let settings = ptSettings {
            let report = BRLMValidatePrintSettings.validate(settings)
            callback(report)
        }
    }
}
