//
//  PJModelPrintSettings.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/8.
//

import BRLMPrinterKit
import Foundation

class PJModelTemplatePrintSettings: ISimpleTemplatePrintSettings {
    var templateSettingItemData: [TemplateSettingItemData]?
    var printerModel: PrinterModel
    private var pjTemplateSettings: BRLMPJTemplatePrintSettings?
    init(printerModel: PrinterModel, templateSettingItemData: [TemplateSettingItemData] = []) {
        self.printerModel = printerModel
        if let settings = BRLMPJTemplatePrintSettings(defaultPrintSettingsWith: printerModel.printerModel) {
            self.pjTemplateSettings = settings
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
                pjTemplateSettings?.numCopies = numCopies
            }
        case .PRINTER_MODEL, .PEEL_LABEL: break
        }
    }
    
    func fetchPrintSettings() -> BRLMTemplatePrintSettingsProtocol? {
        return pjTemplateSettings
    }
}

class PJModelPrintSettings: ISimplePrintSettings {
    var settingsData: [SettingItemData]?
    var printerModel: PrinterModel
    private var pjSettings: BRLMPJPrintSettings?

    init(printerModel: PrinterModel, settingsData: [SettingItemData] = []) { // swiftlint:disable:this function_body_length
        self.printerModel = printerModel
        if let settings = BRLMPJPrintSettings(defaultPrintSettingsWith: printerModel.printerModel) {
            self.pjSettings = settings
            self.settingsData = []
            self.settingsData?.append(SettingItemData(key: .PRINTER_MODEL, value: printerModel.rawValue))
            self.settingsData?.append(
                SettingItemData(key: .PAPER_SIZE, value: settings.paperSize)
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
                SettingItemData(key: .PAPER_TYPE, value: settings.paperType.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .PAPER_INSERTION_POSITION, value: settings.paperInsertionPosition.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .FEED_MODE, value: settings.feedMode.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .EXTRA_FEED_DOTS, value: settings.extraFeedDots.description)
            )
            self.settingsData?.append(
                SettingItemData(key: .DENSITY, value: settings.density.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .ROLL_CASE, value: settings.rollCase.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .PRINT_SPEED, value: settings.printSpeed.name)
            )
            self.settingsData?.append(
                SettingItemData(key: .USING_CARBON_COPY_PAPER, value: settings.usingCarbonCopyPaper ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .PRINT_DASH_LINE, value: settings.printDashLine ? "ON" : "OFF")
            )
            self.settingsData?.append(
                SettingItemData(key: .FORCE_STRETCH_PRINTABLE_AREA, value: settings.forceStretchPrintableArea.description)
            )
        }
    }

    func fetchSettingItemList(key: PrintSettingItemType) -> [String] { // swiftlint:disable:this cyclomatic_complexity
        var itemList: [String] = []
        switch key {
        case .PAPER_SIZE:
            itemList = BRLMPJPrintSettingsPaperSizeStandard.allCases().map({ $0.name })
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
        case .PAPER_TYPE:
            itemList = BRLMPJPrintSettingsPaperType.allCases().map({ $0.name })
        case .PAPER_INSERTION_POSITION:
            itemList = BRLMPJPrintSettingsPaperInsertionPosition.allCases().map({ $0.name })
        case .FEED_MODE:
            itemList = BRLMPJPrintSettingsFeedMode.allCases().map({ $0.name })
        case .DENSITY:
            itemList = BRLMPJPrintSettingsDensity.allCases().map({ $0.name })
        case .ROLL_CASE:
            itemList = BRLMPJPrintSettingsRollCase.allCases().map({ $0.name })
        case .PRINT_SPEED:
            itemList = BRLMPJPrintSettingsPrintSpeed.allCases().map({ $0.name })
        case .USING_CARBON_COPY_PAPER:
            itemList = ["ON", "OFF"]
        case .PRINT_DASH_LINE:
            itemList = ["ON", "OFF"]
        default:
            itemList = []
        }
        return itemList
    }

    func setSettingInfo(key: PrintSettingItemType, message: Any) { // swiftlint:disable:this cyclomatic_complexity function_body_length
        switch key {
        case .PAPER_SIZE:
            if let value = message as? BRLMPJPrintSettingsPaperSize {
                pjSettings?.paperSize = value
            }
        case .SCALE_MODE:
            if let value = BRLMPrintSettingsScaleMode.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.scaleMode = value
            }
        case .SCALE_VALUE:
            if let value = message as? String, let scaleValue = Double(value) {
                pjSettings?.scaleValue = CGFloat(scaleValue)
            }
        case .ORIENTATION:
            if let value = BRLMPrintSettingsOrientation.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.printOrientation = value
            }
        case .ROTATION:
            if let value = BRLMPrintSettingsRotation.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.imageRotation = value
            }
        case .HALFTONE:
            if let value = BRLMPrintSettingsHalftone.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.halftone = value
            }
        case .HORIZONTAL_ALIGNMENT:
            if let value = BRLMPrintSettingsHorizontalAlignment.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.hAlignment = value
            }
        case .VERTICAL_ALIGNMENT:
            if let value = BRLMPrintSettingsVerticalAlignment.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.vAlignment = value
            }
        case .COMPRESS_MODE:
            if let value = BRLMPrintSettingsCompressMode.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.compress = value
            }
        case .HALFTONE_THRESHOLD:
            if let value = message as? String, let halftoneThreshold = UInt8(value) {
                pjSettings?.halftoneThreshold = halftoneThreshold
            }
        case .NUM_COPIES:
            if let value = message as? String, let numCopies = UInt(value) {
                pjSettings?.numCopies = numCopies
            }
        case .SKIP_STATUS_CHECK:
            pjSettings?.skipStatusCheck = (message as? String) == "ON"
        case .PRINT_QUALITY:
            if let value = BRLMPrintSettingsPrintQuality.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.printQuality = value
            }
        case .TRIM_TRAILING_BLANK_DATA:
            pjSettings?.trimTrailingBlankData = (message as? String) == "ON"
        case .PAPER_TYPE:
            if let value = BRLMPJPrintSettingsPaperType.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.paperType = value
            }
        case .PAPER_INSERTION_POSITION:
            if let value = BRLMPJPrintSettingsPaperInsertionPosition.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.paperInsertionPosition = value
            }
        case .FEED_MODE:
            if let value = BRLMPJPrintSettingsFeedMode.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.feedMode = value
            }
        case .EXTRA_FEED_DOTS:
            if let value = message as? String, let extraFeedDots = UInt(value) {
                pjSettings?.extraFeedDots = extraFeedDots
            }
        case .DENSITY:
            if let value = BRLMPJPrintSettingsDensity.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.density = value
            }
        case .ROLL_CASE:
            if let value = BRLMPJPrintSettingsRollCase.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.rollCase = value
            }
        case .PRINT_SPEED:
            if let value = BRLMPJPrintSettingsPrintSpeed.allCases().first(where: { $0.name == message as? String }) {
                pjSettings?.printSpeed = value
            }
        case .USING_CARBON_COPY_PAPER:
            pjSettings?.usingCarbonCopyPaper = (message as? String) == "ON"
        case .PRINT_DASH_LINE:
            pjSettings?.printDashLine = (message as? String) == "ON"
        case .FORCE_STRETCH_PRINTABLE_AREA:
            if let value = message as? String, let forceStretchPrintableArea = UInt(value) {
                pjSettings?.forceStretchPrintableArea = forceStretchPrintableArea
            }
        default:
            break
        }
    }

    func fetchPrintSettings() -> BRLMPrintSettingsProtocol? {
        return pjSettings
    }

    func validateSettings(callback: @escaping (BRLMValidatePrintSettingsReport) -> Void) {
        if let settings = pjSettings {
            let report = BRLMValidatePrintSettings.validate(settings)
            callback(report)
        }
    }
}
