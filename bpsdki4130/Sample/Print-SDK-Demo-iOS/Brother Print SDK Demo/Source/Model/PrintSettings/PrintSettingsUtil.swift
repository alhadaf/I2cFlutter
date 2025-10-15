//
//  PrintSettingsUtil.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/7.
//

import BRLMPrinterKit
import Foundation

class PrintSettingsUtil {
    
}

extension BRLMPTPrintSettingsLabelSize {
    static func allCases() -> [BRLMPTPrintSettingsLabelSize] {
        return [
                    .width3_5mm,
                    .width6mm,
                    .width9mm,
                    .width12mm,
                    .width18mm,
                    .width24mm,
                    .width36mm,
                    .widthHS_5_8mm,
                    .widthHS_8_8mm,
                    .widthHS_11_7mm,
                    .widthHS_17_7mm,
                    .widthHS_23_6mm,
                    .widthFL_21x45mm,
                    .widthHS_5_2mm,
                    .widthHS_9_0mm,
                    .widthHS_11_2mm,
                    .widthHS_21_0mm,
                    .widthHS_31_0mm
               ]
    }
    var name: String {
        switch self {
        case .width3_5mm:
            return "width3_5mm"
        case .width6mm:
            return "width6mm"
        case .width9mm:
            return "width9mm"
        case .width12mm:
            return "width12mm"
        case .width18mm:
            return "width18mm"
        case .width24mm:
            return "width24mm"
        case .width36mm:
            return "width36mm"
        case .widthHS_5_8mm:
            return "widthHS_5_8mm"
        case .widthHS_8_8mm:
            return "widthHS_8_8mm"
        case .widthHS_11_7mm:
            return "widthHS_11_7mm"
        case .widthHS_17_7mm:
            return "widthHS_17_7mm"
        case .widthHS_23_6mm:
            return "widthHS_23_6mm"
        case .widthFL_21x45mm:
            return "widthFL_21x45mm"
        case .widthHS_5_2mm:
            return "widthHS_5_2mm"
        case .widthHS_9_0mm:
            return "widthHS_9_0mm"
        case .widthHS_11_2mm:
            return "widthHS_11_2mm"
        case .widthHS_21_0mm:
            return "widthHS_21_0mm"
        case .widthHS_31_0mm:
            return "widthHS_31_0mm"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMQLPrintSettingsLabelSize {
    static func allCases() -> [BRLMQLPrintSettingsLabelSize] {
        return [
                    .dieCutW17H54,
                    .dieCutW17H87,
                    .dieCutW23H23,
                    .dieCutW29H42,
                    .dieCutW29H90,
                    .dieCutW38H90,
                    .dieCutW39H48,
                    .dieCutW52H29,
                    .dieCutW62H29,
                    .dieCutW62H60,
                    .dieCutW62H75,
                    .dieCutW62H100,
                    .dieCutW60H86,
                    .dieCutW54H29,
                    .dieCutW102H51,
                    .dieCutW102H152,
                    .dieCutW103H164,
                    .rollW12,
                    .rollW29,
                    .rollW38,
                    .rollW50,
                    .rollW54,
                    .rollW62,
                    .rollW62RB,
                    .rollW102,
                    .rollW103,
                    .dtRollW90,
                    .dtRollW102,
                    .dtRollW102H51,
                    .dtRollW102H152,
                    .roundW12DIA,
                    .roundW24DIA,
                    .roundW58DIA
               ]
    }
    var name: String {
        switch self {
        case .dieCutW17H54:
            return "dieCutW17H54"
        case .dieCutW17H87:
            return "dieCutW17H87"
        case .dieCutW23H23:
            return "dieCutW23H23"
        case .dieCutW29H42:
            return "dieCutW29H42"
        case .dieCutW29H90:
            return "dieCutW29H90"
        case .dieCutW38H90:
            return "dieCutW38H90"
        case .dieCutW39H48:
            return "dieCutW39H48"
        case .dieCutW52H29:
            return "dieCutW52H29"
        case .dieCutW62H29:
            return "dieCutW62H29"
        case .dieCutW62H60:
            return "dieCutW62H60"
        case .dieCutW62H75:
            return "dieCutW62H75"
        case .dieCutW62H100:
            return "dieCutW62H100"
        case .dieCutW60H86:
            return "dieCutW60H86"
        case .dieCutW54H29:
            return "dieCutW54H29"
        case .dieCutW102H51:
            return "dieCutW102H51"
        case .dieCutW102H152:
            return "dieCutW102H152"
        case .dieCutW103H164:
            return "dieCutW103H164"
        case .rollW12:
            return "rollW12"
        case .rollW29:
            return "rollW29"
        case .rollW38:
            return "rollW38"
        case .rollW50:
            return "rollW50"
        case .rollW54:
            return "rollW54"
        case .rollW62:
            return "rollW62"
        case .rollW62RB:
            return "rollW62RB"
        case .rollW102:
            return "rollW102"
        case .rollW103:
            return "rollW103"
        case .dtRollW90:
            return "dtRollW90"
        case .dtRollW102:
            return "dtRollW102"
        case .dtRollW102H51:
            return "dtRollW102H51"
        case .dtRollW102H152:
            return "dtRollW102H152"
        case .roundW12DIA:
            return "roundW12DIA"
        case .roundW24DIA:
            return "roundW24DIA"
        case .roundW58DIA:
            return "roundW58DIA"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPrintSettingsScaleMode {
    static func allCases() -> [BRLMPrintSettingsScaleMode] {
        return [
                    .actualSize,
                    .fitPageAspect,
                    .fitPaperAspect,
                    .scaleValue
               ]
    }
    var name: String {
        switch self {
        case .actualSize:
            return "actualSize"
        case .fitPageAspect:
            return "fitPageAspect"
        case .fitPaperAspect:
            return "fitPaperAspect"
        case .scaleValue:
            return "scaleValue"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPrintSettingsOrientation {
    static func allCases() -> [BRLMPrintSettingsOrientation] {
        return [
                    .portrait,
                    .landscape
               ]
    }
    var name: String {
        switch self {
        case .portrait:
            return "portrait"
        case .landscape:
            return "landscape"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPrintSettingsRotation {
    static func allCases() -> [BRLMPrintSettingsRotation] {
        return [
                    .rotate0,
                    .rotate90,
                    .rotate180,
                    .rotate270
               ]
    }
    var name: String {
        switch self {
        case .rotate0:
            return "rotate0"
        case .rotate90:
            return "rotate90"
        case .rotate180:
            return "rotate180"
        case .rotate270:
            return "rotate270"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPrintSettingsHalftone {
    static func allCases() -> [BRLMPrintSettingsHalftone] {
        return [
                    .threshold,
                    .errorDiffusion,
                    .patternDither
               ]
    }
    var name: String {
        switch self {
        case .threshold:
            return "threshold"
        case .errorDiffusion:
            return "errorDiffusion"
        case .patternDither:
            return "patternDither"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPrintSettingsHorizontalAlignment {
    static func allCases() -> [BRLMPrintSettingsHorizontalAlignment] {
        return [
                    .left,
                    .center,
                    .right
               ]
    }
    var name: String {
        switch self {
        case .left:
            return "left"
        case .center:
            return "center"
        case .right:
            return "right"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPrintSettingsVerticalAlignment {
    static func allCases() -> [BRLMPrintSettingsVerticalAlignment] {
        return [
                    .top,
                    .center,
                    .bottom
               ]
    }
    var name: String {
        switch self {
        case .top:
            return "top"
        case .center:
            return "center"
        case .bottom:
            return "bottom"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPrintSettingsCompressMode {
    static func allCases() -> [BRLMPrintSettingsCompressMode] {
        return [
                    .none,
                    .tiff,
                    .mode9
               ]
    }
    var name: String {
        switch self {
        case .none:
            return "none"
        case .tiff:
            return "tiff"
        case .mode9:
            return "mode9"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPJPrintSettingsPaperType {
    static func allCases() -> [BRLMPJPrintSettingsPaperType] {
        return [
                    .roll,
                    .cutSheet,
                    .perforatedRoll
               ]
    }
    var name: String {
        switch self {
        case .roll:
            return "roll"
        case .cutSheet:
            return "cutSheet"
        case .perforatedRoll:
            return "perforatedRoll"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPJPrintSettingsPaperInsertionPosition {
    static func allCases() -> [BRLMPJPrintSettingsPaperInsertionPosition] {
        return [
                    .left,
                    .center,
                    .right
               ]
    }
    var name: String {
        switch self {
        case .left:
            return "left"
        case .center:
            return "center"
        case .right:
            return "right"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPJPrintSettingsFeedMode {
    static func allCases() -> [BRLMPJPrintSettingsFeedMode] {
        return [
                    .noFeed,
                    .fixedPage,
                    .endOfPage,
                    .endOfPageRetract
               ]
    }
    var name: String {
        switch self {
        case .noFeed:
            return "noFeed"
        case .fixedPage:
            return "fixedPage"
        case .endOfPage:
            return "endOfPage"
        case .endOfPageRetract:
            return "endOfPageRetract"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPJPrintSettingsDensity {
    static func allCases() -> [BRLMPJPrintSettingsDensity] {
        return [
                    .weakLevel5,
                    .weakLevel4,
                    .weakLevel3,
                    .weakLevel2,
                    .weakLevel1,
                    .neutral,
                    .strongLevel1,
                    .strongLevel2,
                    .strongLevel3,
                    .strongLevel4,
                    .strongLevel5,
                    .usePrinterSetting
               ]
    }
    var name: String {
        switch self {
        case .weakLevel5:
            return "weakLevel5"
        case .weakLevel4:
            return "weakLevel4"
        case .weakLevel3:
            return "weakLevel3"
        case .weakLevel2:
            return "weakLevel2"
        case .weakLevel1:
            return "weakLevel1"
        case .neutral:
            return "neutral"
        case .strongLevel1:
            return "strongLevel1"
        case .strongLevel2:
            return "strongLevel2"
        case .strongLevel3:
            return "strongLevel3"
        case .strongLevel4:
            return "strongLevel4"
        case .strongLevel5:
            return "strongLevel5"
        case .usePrinterSetting:
            return "usePrinterSetting"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPJPrintSettingsRollCase {
    static func allCases() -> [BRLMPJPrintSettingsRollCase] {
        return [
                    .none,
                    .parc001_NoAntiCurl,
                    .PARC001,
                    .parc001_ShortFeed,
                    .keepPrinterSetting
               ]
    }
    var name: String {
        switch self {
        case .none:
            return "none"
        case .parc001_NoAntiCurl:
            return "parc001_NoAntiCurl"
        case .PARC001:
            return "PARC001"
        case .parc001_ShortFeed:
            return "parc001_ShortFeed"
        case .keepPrinterSetting:
            return "keepPrinterSetting"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPJPrintSettingsPrintSpeed {
    static func allCases() -> [BRLMPJPrintSettingsPrintSpeed] {
        return [
                    .speedHighSpeed,
                    .speedMediumHighSpeed,
                    .speedMediumLowSpeed,
                    .speedLowSpeed,
                    .speedFast_DraftQuality,
                    .speedFast_LineConversion,
                    .speedUsePrinterSetting,
                    .speed2_5inchPerSec,
                    .speed1_9inchPerSec,
                    .speed1_6inchPerSec,
                    .speed1_1inchPerSec
               ]
    }
    var name: String {
        switch self {
        case .speedHighSpeed:
            return "speedHighSpeed"
        case .speedMediumHighSpeed:
            return "speedMediumHighSpeed"
        case .speedMediumLowSpeed:
            return "speedMediumLowSpeed"
        case .speedLowSpeed:
            return "speedLowSpeed"
        case .speedFast_DraftQuality:
            return "speedFast_DraftQuality"
        case .speedFast_LineConversion:
            return "speedFast_LineConversion"
        case .speedUsePrinterSetting:
            return "speedUsePrinterSetting"
        case .speed2_5inchPerSec:
            return "speed2_5inchPerSec"
        case .speed1_9inchPerSec:
            return "speed1_9inchPerSec"
        case .speed1_6inchPerSec:
            return "speed1_6inchPerSec"
        case .speed1_1inchPerSec:
            return "speed1_1inchPerSec"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMRJPrintSettingsDensity {
    static func allCases() -> [BRLMRJPrintSettingsDensity] {
        return [
                    .weakLevel5,
                    .weakLevel4,
                    .weakLevel3,
                    .weakLevel2,
                    .weakLevel1,
                    .neutral,
                    .strongLevel1,
                    .strongLevel2,
                    .strongLevel3,
                    .strongLevel4,
                    .strongLevel5,
                    .usePrinterSetting
               ]
    }
    var name: String {
        switch self {
        case .weakLevel5:
            return "weakLevel5"
        case .weakLevel4:
            return "weakLevel4"
        case .weakLevel3:
            return "weakLevel3"
        case .weakLevel2:
            return "weakLevel2"
        case .weakLevel1:
            return "weakLevel1"
        case .neutral:
            return "neutral"
        case .strongLevel1:
            return "strongLevel1"
        case .strongLevel2:
            return "strongLevel2"
        case .strongLevel3:
            return "strongLevel3"
        case .strongLevel4:
            return "strongLevel4"
        case .strongLevel5:
            return "strongLevel5"
        case .usePrinterSetting:
            return "usePrinterSetting"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMTDPrintSettingsDensity {
    static func allCases() -> [BRLMTDPrintSettingsDensity] {
        return [
                    .weakLevel5,
                    .weakLevel4,
                    .weakLevel3,
                    .weakLevel2,
                    .weakLevel1,
                    .neutral,
                    .strongLevel1,
                    .strongLevel2,
                    .strongLevel3,
                    .strongLevel4,
                    .strongLevel5,
                    .usePrinterSetting
               ]
    }
    var name: String {
        switch self {
        case .weakLevel5:
            return "weakLevel5"
        case .weakLevel4:
            return "weakLevel4"
        case .weakLevel3:
            return "weakLevel3"
        case .weakLevel2:
            return "weakLevel2"
        case .weakLevel1:
            return "weakLevel1"
        case .neutral:
            return "neutral"
        case .strongLevel1:
            return "strongLevel1"
        case .strongLevel2:
            return "strongLevel2"
        case .strongLevel3:
            return "strongLevel3"
        case .strongLevel4:
            return "strongLevel4"
        case .strongLevel5:
            return "strongLevel5"
        case .usePrinterSetting:
            return "usePrinterSetting"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMMWPrintSettingsPaperSize {
    static func allCases() -> [BRLMMWPrintSettingsPaperSize] {
        return [
                    .A6,
                    .A7
               ]
    }
    var name: String {
        switch self {
        case .A6:
            return "A6"
        case .A7:
            return "A7"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPrintSettingsPrintQuality {
    static func allCases() -> [BRLMPrintSettingsPrintQuality] {
        return [
                    .best,
                    .fast
               ]
    }
    var name: String {
        switch self {
        case .best:
            return "best"
        case .fast:
            return "fast"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPrintSettingsResolution {
    static func allCases() -> [BRLMPrintSettingsResolution] {
        return [
                    .low,
                    .normal,
                    .high
               ]
    }
    var name: String {
        switch self {
        case .low:
            return "low"
        case .normal:
            return "normal"
        case .high:
            return "high"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMPJPrintSettingsPaperSizeStandard {
    static func allCases() -> [BRLMPJPrintSettingsPaperSizeStandard] {
        return [.A4, .legal, .letter, .A5, .a5_Landscape, .custom]
    }
    var name: String {
        switch self {
        case .A4:
            return "A4"
        case .legal:
            return "legal"
        case .letter:
            return "letter"
        case .A5:
            return "A5"
        case .a5_Landscape:
            return "A5_Landscape"
        case .custom:
            return "custom"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMCustomPaperSizeLengthUnit {
    static func allCases() -> [BRLMCustomPaperSizeLengthUnit] {
        return [.inch, .mm]
    }
    var name: String {
        switch self {
        case .inch:
            return "inch"
        case .mm:
            return "mm"
        @unknown default:
            return "unknown"
        }
    }
}
extension BRLMCustomPaperSizePaperKind {
    static func allCases() -> [BRLMCustomPaperSizePaperKind] {
        return [.roll, .dieCut, .markRoll, .byFile]
    }
    var name: String {
        switch self {
        case .roll:
            return "roll"
        case .dieCut:
            return "dieCut"
        case .markRoll:
            return "markRoll"
        case .byFile:
            return "byFile"
        @unknown default:
            return "unknown"
        }
    }
    var editList: [CustomPaperType] {
        switch self {
        case .roll:
            return [.TAPEWIDTH, .MARGINS, .UNIT, .ENERGYRANK]
        case .dieCut:
            return [.TAPEWIDTH, .TAPELENGTH, .MARGINS, .GAPLENGTH, .UNIT, .ENERGYRANK]
        case .markRoll:
            return [.TAPEWIDTH, .TAPELENGTH, .MARGINS, .MARKVERTICALOFFSET, .MARKLENGHT, .UNIT, .ENERGYRANK]
        case .byFile:
            return [.FILEPATH]
        @unknown default:
            return []
        }
    }
}
// swiftlint:disable:this file_length
