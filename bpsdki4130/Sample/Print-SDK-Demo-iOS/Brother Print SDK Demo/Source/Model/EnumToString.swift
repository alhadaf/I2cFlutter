//
//  EnumToString.swift
//  Brother Print SDK Demo
//
//  Created by shintaro on 2024/07/05.
//

import Foundation
import BRLMPrinterKit

class EnumToString
{
    static func mediaTypeName(mediaType: BRLMMediaInfoMediaType?) -> String {
        switch mediaType {
        case .ptLaminate:
            return "ptLaminate"
        case .ptNonLaminate:
            return "ptNonLaminate"
        case .ptFabric:
            return "ptFabric"
        case .qlInfiniteLable:
            return "qlInfiniteLable"
        case .qlDieCutLable:
            return "qlDieCutLable"
        case .ptHeatShrink:
            return "ptHeatShrink"
        case .ptHeatShrink3_1:
            return "ptHeatShrink3_1"
        case .ptfLe:
            return "ptfLe"
        case .ptFlexibleID:
            return "ptFlexibleID"
        case .ptSatin:
            return "ptSatin"
        case .ptSelfLaminate:
            return "ptSelfLaminate"
        case .incompatible:
            return "incompatible"
        case .unknown:
            return "unknown"
        case .none:
            return "none"
        @unknown default:
            return "undefined"
        }
    }

    static func printerBatteryStatusTernary(ternary: BRLMPrinterBatteryStatusTernary?) -> String {
        switch ternary {
        case .yes:
            return "YES"
        case .no:
            return "NO"
        case .unknown, .none:
            return "unknown"
        @unknown default:
            return "undefined"
        }
    }

    static func mediaBackgroundColor( // swiftlint:disable:this cyclomatic_complexity function_body_length
        color: BRLMMediaInfoBackgroundColor?
    ) -> String {
        switch color {
        case .standard:
            return "standard"
        case .white:
            return "white"
        case .others:
            return "others"
        case .clear:
            return "clear"
        case .red:
            return "red"
        case .blue:
            return "blue"
        case .yellow:
            return "yellow"
        case .green:
            return "green"
        case .black:
            return "black"
        case .clearWithWhiteInk:
            return "clearWithWhiteInk"
        case .premiumGold:
            return "premiumGold"
        case .premiumSilver:
            return "premiumSilver"
        case .premiumOthers:
            return "premiumOthers"
        case .maskingOthers:
            return "maskingOthers"
        case .matteWhite:
            return "matteWhite"
        case .matteClear:
            return "matteClear"
        case .matteSilver:
            return "matteSilver"
        case .satinGold:
            return "satinGold"
        case .satinSilver:
            return "satinSilver"
        case .pastelPurple:
            return "pastelPurple"
        case .blueWithWhiteInk:
            return "blueWithWhiteInk"
        case .redWithWhiteInk:
            return "redWithWhiteInk"
        case .fluorescentOrange:
            return "fluorescentOrange"
        case .fluorescentYellow:
            return "fluorescentYellow"
        case .berryPink:
            return "berryPink"
        case .lightGray:
            return "lightGray"
        case .limeGreen:
            return "limeGreen"
        case .satinNavyBlue:
            return "satinNavyBlue"
        case .satinWineRed:
            return "satinWineRed"
        case .fabricYellow:
            return "fabricYellow"
        case .fabricPink:
            return "fabricPink"
        case .fabricBlue:
            return "fabricBlue"
        case .tubeWhite:
            return "tubeWhite"
        case .tubeInterminate:
            return "tubeInterminate"
        case .selfLaminatedWhite:
            return "selfLaminatedWhite"
        case .flexibleWhite:
            return "flexibleWhite"
        case .flexibleYellow:
            return "flexibleYellow"
        case .cleaningWhite:
            return "cleaningWhite"
        case .stencilWhite:
            return "stencilWhite"
        case .lightBlue_Satin:
            return "lightBlue_Satin"
        case .mint_Satin:
            return "mint_Satin"
        case .silver_Satin:
            return "silver_Satin"
        case .incompatible:
            return "incompatible"
        case .unknown:
            return "unknown"
        case .none:
            return "none"
        @unknown default:
            return "undefined"
        }
    }

    static func mediaInkColor(color: BRLMMediaInfoInkColor?) -> String {
        switch color {
        case .standard:
            return "standard"
        case .white:
            return "white"
        case .others:
            return "others"
        case .red:
            return "red"
        case .blue:
            return "blue"
        case .black:
            return "black"
        case .gold:
            return "gold"
        case .redAndBlack:
            return "redAndBlack"
        case .fabricBlue:
            return "fabricBlue"
        case .cleaningBlack:
            return "cleaningBlack"
        case .stencilBlack:
            return "stencilBlack"
        case .incompatible:
            return "incompatible"
        case .unknown:
            return "unknown"
        case .none:
            return "none"
        @unknown default:
            return "undefined"
        }
    }

    static func qlLabelSize( // swiftlint:disable:this cyclomatic_complexity function_body_length
        size: BRLMQLPrintSettingsLabelSize?
    ) -> String {
        switch size {
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
        case .none:
            return "none"
        @unknown default:
            return "undefined"
        }
    }

    static func ptLabelSize( // swiftlint:disable:this cyclomatic_complexity function_body_length
        size: BRLMPTPrintSettingsLabelSize?
    ) -> String {
        switch size {
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
        case .none:
            return "none"
        @unknown default:
            return "undefined"
        }
    }
    
    static func dataheaderKind(kind:BRLMPtouchDeviceDependedDataHeaderDataKind) -> String {
        switch kind {
        case .template:
            return "template"
        case .database:
            return "database"
        case .media:
            return "media"
        case .font:
            return "font"
        case .mainFirm:
            return "main_firm"
        case .bootFirm:
            return "boot_firm"
        case .bluetoothFirm:
            return "bluetooth_firm"
        case .anyFirm:
            return "any_firm"
        case .userData:
            return "user_data"
        case .other:
            return "other"
        @unknown default:
            return "undefined"
        }
    }

}
