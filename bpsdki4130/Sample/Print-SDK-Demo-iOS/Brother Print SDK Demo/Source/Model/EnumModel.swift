//
//  EnumModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/14.
//

import BRLMPrinterKit
import CoreFoundation.CFStringEncodingExt
import Foundation

enum TemplateEncoding: String, CaseIterable {
    case ENG
    case JPN
    case CHN
    
    var brlmTemplateObjectEncode: BRLMTemplateObjectEncode {
        switch self {
        case .ENG:
            return .UTF_8
        case .JPN:
            return .SHIFT_JIS
        case .CHN:
            return .GB_18030_2000
        }
    }
    
}

enum ImagePrnType {
    case imageFile
    case imageURL
    case imageURLs
    case imageClosures
}

enum PDFPrintType {
    case pdfURL
    case pdfURLs
    case pdfPages
}

enum PrintType {
    case image
    case pdf
}

enum ModelListType {
    case spec
    case validate
}
