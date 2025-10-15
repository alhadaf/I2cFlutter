//
//  ISimplePrintSettings.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/31.
//

import BRLMPrinterKit
import Foundation

protocol ISimplePrintSettings: AnyObject {
    var printerModel: PrinterModel { get }
    var settingsData: [SettingItemData]? { get set }

    func fetchSettingItemList(key: PrintSettingItemType) -> [String]
    func setSettingInfo(key: PrintSettingItemType, message: Any)
    func fetchPrintSettings() -> BRLMPrintSettingsProtocol?
    func validateSettings(callback: @escaping (BRLMValidatePrintSettingsReport) -> Void)
}

protocol ISimpleTemplatePrintSettings: AnyObject {
    var printerModel: PrinterModel { get }
    var templateSettingItemData: [TemplateSettingItemData]? { get set }

    func fetchSettingItemList(key: TemplatePrintSettingItemType) -> [String]
    func setSettingInfo(key: TemplatePrintSettingItemType, message: Any)
    func fetchPrintSettings() -> BRLMTemplatePrintSettingsProtocol?
}

enum PrintSettingItemType: CaseIterable, Hashable {
    case AUTO_CUT // swiftlint:disable:this identifier_name
    case AUTO_CUT_FOR_EACH_PAGE_COUNT // swiftlint:disable:this identifier_name
    case BI_COLOR_BLUE_ENHANCEMENT // swiftlint:disable:this identifier_name
    case BI_COLOR_GREEN_ENHANCEMENT // swiftlint:disable:this identifier_name
    case BI_COLOR_RED_ENHANCEMENT // swiftlint:disable:this identifier_name
    case CHAIN_PRINT // swiftlint:disable:this identifier_name
    case CHANNEL_TYPE // swiftlint:disable:this identifier_name
    case COMPRESS_MODE // swiftlint:disable:this identifier_name
    case CUSTOM_PAPER_SIZE // swiftlint:disable:this identifier_name
    case CUSTOM_RECORD // swiftlint:disable:this identifier_name
    case CUTMARK_PRINT // swiftlint:disable:this identifier_name
    case CUT_AT_END // swiftlint:disable:this identifier_name
    case CUT_PAUSE // swiftlint:disable:this identifier_name
    case DENSITY
    case EXTRA_FEED_DOTS // swiftlint:disable:this identifier_name
    case FEED_DIRECTION_MARGINS // swiftlint:disable:this identifier_name
    case FEED_MODE // swiftlint:disable:this identifier_name
    case FORCE_STRETCH_PRINTABLE_AREA // swiftlint:disable:this identifier_name
    case FORCE_VANISHING_MARGIN // swiftlint:disable:this identifier_name
    case HALFTONE
    case HALFTONE_THRESHOLD // swiftlint:disable:this identifier_name
    case HALF_CUT // swiftlint:disable:this identifier_name
    case HORIZONTAL_ALIGNMENT // swiftlint:disable:this identifier_name
    case LABEL_SIZE // swiftlint:disable:this identifier_name
    case MIRROR_PRINT // swiftlint:disable:this identifier_name
    case NUM_COPIES // swiftlint:disable:this identifier_name
    case ORIENTATION
    case PAPER_INSERTION_POSITION // swiftlint:disable:this identifier_name
    case PAPER_SIZE // swiftlint:disable:this identifier_name
    case PAPER_TYPE // swiftlint:disable:this identifier_name
    case PEEL_LABEL // swiftlint:disable:this identifier_name
    case PRINTER_MODEL // swiftlint:disable:this identifier_name
    case PRINT_DASH_LINE // swiftlint:disable:this identifier_name
    case PRINT_QUALITY // swiftlint:disable:this identifier_name
    case PRINT_SPEED // swiftlint:disable:this identifier_name
    case RESOLUTION
    case ROLL_CASE // swiftlint:disable:this identifier_name
    case ROTATE180DEGREES
    case ROTATION
    case SCALE_MODE // swiftlint:disable:this identifier_name
    case SCALE_VALUE // swiftlint:disable:this identifier_name
    case SKIP_STATUS_CHECK // swiftlint:disable:this identifier_name
    case SPECIAL_TAPE_PRINT // swiftlint:disable:this identifier_name
    case TRIM_TRAILING_BLANK_DATA // swiftlint:disable:this identifier_name
    case USING_CARBON_COPY_PAPER // swiftlint:disable:this identifier_name
    case VERTICAL_ALIGNMENT // swiftlint:disable:this identifier_name

    var title: String {
        switch self {
        case .AUTO_CUT:
            return NSLocalizedString("auto_cut", comment: "")
        case .AUTO_CUT_FOR_EACH_PAGE_COUNT:
            return NSLocalizedString("auto_cut_for_each_page_count", comment: "")
        case .BI_COLOR_BLUE_ENHANCEMENT:
            return NSLocalizedString("bi_color_blue_enhancement", comment: "")
        case .BI_COLOR_GREEN_ENHANCEMENT:
            return NSLocalizedString("bi_color_green_enhancement", comment: "")
        case .BI_COLOR_RED_ENHANCEMENT:
            return NSLocalizedString("bi_color_red_enhancement", comment: "")
        case .CHAIN_PRINT:
            return NSLocalizedString("chain_print", comment: "")
        case .CHANNEL_TYPE:
            return NSLocalizedString("channel_type", comment: "")
        case .COMPRESS_MODE:
            return NSLocalizedString("compress_mode", comment: "")
        case .CUSTOM_PAPER_SIZE:
            return NSLocalizedString("custom_paper_size", comment: "")
        case .CUSTOM_RECORD:
            return NSLocalizedString("custom_record", comment: "")
        case .CUTMARK_PRINT:
            return NSLocalizedString("cutmark_print", comment: "")
        case .CUT_AT_END:
            return NSLocalizedString("cut_at_end", comment: "")
        case .CUT_PAUSE:
            return NSLocalizedString("cut_pause", comment: "")
        case .DENSITY:
            return NSLocalizedString("density", comment: "")
        case .EXTRA_FEED_DOTS:
            return NSLocalizedString("extra_feed_dots", comment: "")
        case .FEED_DIRECTION_MARGINS:
            return NSLocalizedString("feed_direction_margins", comment: "")
        case .FEED_MODE:
            return NSLocalizedString("feed_mode", comment: "")
        case .FORCE_STRETCH_PRINTABLE_AREA:
            return NSLocalizedString("force_stretch_printable_area", comment: "")
        case .FORCE_VANISHING_MARGIN:
            return NSLocalizedString("force_vanishing_margin", comment: "")
        case .HALFTONE:
            return NSLocalizedString("halftone", comment: "")
        case .HALFTONE_THRESHOLD:
            return NSLocalizedString("halftone_threshold", comment: "")
        case .HALF_CUT:
            return NSLocalizedString("half_cut", comment: "")
        case .HORIZONTAL_ALIGNMENT:
            return NSLocalizedString("horizontal_alignment", comment: "")
        case .LABEL_SIZE:
            return NSLocalizedString("label_size", comment: "")
        case .MIRROR_PRINT:
            return NSLocalizedString("mirror_print", comment: "")
        case .NUM_COPIES:
            return NSLocalizedString("num_copies", comment: "")
        case .ORIENTATION:
            return NSLocalizedString("orientation", comment: "")
        case .PAPER_INSERTION_POSITION:
            return NSLocalizedString("paper_insertion_position", comment: "")
        case .PAPER_SIZE:
            return NSLocalizedString("paper_size", comment: "")
        case .PAPER_TYPE:
            return NSLocalizedString("paper_type", comment: "")
        case .PEEL_LABEL:
            return NSLocalizedString("peel_label", comment: "")
        case .PRINTER_MODEL:
            return NSLocalizedString("printer_model", comment: "")
        case .PRINT_DASH_LINE:
            return NSLocalizedString("print_dash_line", comment: "")
        case .PRINT_QUALITY:
            return NSLocalizedString("print_quality", comment: "")
        case .PRINT_SPEED:
            return NSLocalizedString("print_speed", comment: "")
        case .RESOLUTION:
            return NSLocalizedString("resolution", comment: "")
        case .ROLL_CASE:
            return NSLocalizedString("roll_case", comment: "")
        case .ROTATE180DEGREES:
            return NSLocalizedString("rotate180degrees", comment: "")
        case .ROTATION:
            return NSLocalizedString("rotation", comment: "")
        case .SCALE_MODE:
            return NSLocalizedString("scale_mode", comment: "")
        case .SCALE_VALUE:
            return NSLocalizedString("scale_value", comment: "")
        case .SKIP_STATUS_CHECK:
            return NSLocalizedString("skip_status_check", comment: "")
        case .SPECIAL_TAPE_PRINT:
            return NSLocalizedString("special_tape_print", comment: "")
        case .TRIM_TRAILING_BLANK_DATA:
            return NSLocalizedString("trim_trailing_blank_data", comment: "")
        case .USING_CARBON_COPY_PAPER:
            return NSLocalizedString("using_carbon_copy_paper", comment: "")
        case .VERTICAL_ALIGNMENT:
            return NSLocalizedString("vertical_alignment", comment: "")
        }
    }
}

enum TemplatePrintSettingItemType: CaseIterable, Hashable {
    case PRINTER_MODEL // swiftlint:disable:this identifier_name
    case NUM_COPIES // swiftlint:disable:this identifier_name
    case PEEL_LABEL // swiftlint:disable:this identifier_name

    var title: String {
        switch self {
        case .PRINTER_MODEL:
            return NSLocalizedString("printer_model", comment: "")
        case .NUM_COPIES:
            return NSLocalizedString("num_copies", comment: "")
        case .PEEL_LABEL:
            return NSLocalizedString("peel_label", comment: "")
        }
    }
}

class SettingItemData: Hashable {
    static func == (lhs: SettingItemData, rhs: SettingItemData) -> Bool {
        return lhs.key.title.uppercased() == rhs.key.title.uppercased() && lhs.value == rhs.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(value)
    }

    init(key: PrintSettingItemType, value: AnyHashable) {
        self.key = key
        self.value = value
    }

    var key: PrintSettingItemType
    var value: AnyHashable
}

class TemplateSettingItemData: Hashable {
    static func == (lhs: TemplateSettingItemData, rhs: TemplateSettingItemData) -> Bool {
        return lhs.key.title.uppercased() == rhs.key.title.uppercased() && lhs.value == rhs.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(value)
    }

    init(key: TemplatePrintSettingItemType, value: AnyHashable) {
        self.key = key
        self.value = value
    }

    var key: TemplatePrintSettingItemType
    var value: AnyHashable
}
