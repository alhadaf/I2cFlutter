//
//  PrintErrorModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/23.
//

import BRLMPrinterKit
import Foundation

class FileAnalyzeErrorModel {
    static func fetchFileAnalyzeErrorCode(error: BRLMFileAnalyzeErrorCode) -> String {
        switch error {
        case .noError:
            return "noError"
        case .fileNotFound:
            return "notFound"
        case .fileFormatIncorrectly:
            return "formatIncorrectly"
        case .unknownError:
            return "unknownError"
        @unknown default:
            return "unknownError"
        }
    }
}

class RequestPrinterInfoErrorModel {
    static func fetchGetPrinterInfoErrorCode(error: BRLMRequestPrinterInfoErrorCode) -> String {
        switch error {
        case .noError:
            return "noError"
        case .connectionFailed:
            return "connectionFailed"
        case .unsupported:
            return "unsupported"
        case .unknownError:
            return "unknownError"
        @unknown default:
            return "unknownError"
        }
    }
}

class OpenChannelErrorModel {
    static func fetchChannelErrorCode(error: BRLMOpenChannelErrorCode) -> String {
        switch error {
        case .noError:
            return "noError"
        case .openStreamFailure:
            return "openStreamFailure"
        case .timeout:
            return "timeout"
        @unknown default:
            return "unknown"
        }
    }
}

class PrintErrorModel { // swiftlint:disable:this type_body_length
    static func fetchErrorCode(errorCode: Int32?) -> String { // swiftlint:disable:this function_body_length
        let errorCodeDic: [Int32: String] = [
            ERROR_NONE_: "ERROR_NONE_",
            ERROR_TIMEOUT: "ERROR_TIMEOUT",
            ERROR_BADPAPERRES: "ERROR_BADPAPERRES",
            ERROR_IMAGELARGE: "ERROR_IMAGELARGE",
            ERROR_CREATESTREAM: "ERROR_CREATESTREAM",
            ERROR_OPENSTREAM: "ERROR_OPENSTREAM",
            ERROR_FILENOTEXIST: "ERROR_FILENOTEXIST",
            ERROR_PAGERANGEERROR: "ERROR_PAGERANGEERROR",
            ERROR_NOT_SAME_MODEL_: "ERROR_NOT_SAME_MODEL_",
            ERROR_BROTHER_PRINTER_NOT_FOUND_: "ERROR_BROTHER_PRINTER_NOT_FOUND_",
            ERROR_PAPER_EMPTY_: "ERROR_PAPER_EMPTY_",
            ERROR_BATTERY_EMPTY_: "ERROR_BATTERY_EMPTY_",
            ERROR_COMMUNICATION_ERROR_: "ERROR_COMMUNICATION_ERROR_",
            ERROR_OVERHEAT_: "ERROR_OVERHEAT_",
            ERROR_PAPER_JAM_: "ERROR_PAPER_JAM_",
            ERROR_HIGH_VOLTAGE_ADAPTER_: "ERROR_HIGH_VOLTAGE_ADAPTER_",
            ERROR_CHANGE_CASSETTE_: "ERROR_CHANGE_CASSETTE_",
            ERROR_FEED_OR_CASSETTE_EMPTY_: "ERROR_FEED_OR_CASSETTE_EMPTY_",
            ERROR_SYSTEM_ERROR_: "ERROR_SYSTEM_ERROR_",
            ERROR_NO_CASSETTE_: "ERROR_NO_CASSETTE_",
            ERROR_WRONG_CASSENDTE_DIRECT_: "ERROR_WRONG_CASSENDTE_DIRECT_",
            ERROR_CREATE_SOCKET_FAILED_: "ERROR_CREATE_SOCKET_FAILED_",
            ERROR_CONNECT_SOCKET_FAILED_: "ERROR_CONNECT_SOCKET_FAILED_",
            ERROR_GET_OUTPUT_STREAM_FAILED_: "ERROR_GET_OUTPUT_STREAM_FAILED_",
            ERROR_GET_INPUT_STREAM_FAILED_: "ERROR_GET_INPUT_STREAM_FAILED_",
            ERROR_CLOSE_SOCKET_FAILED_: "ERROR_CLOSE_SOCKET_FAILED_",
            ERROR_OUT_OF_MEMORY_: "ERROR_OUT_OF_MEMORY_",
            ERROR_SET_OVER_MARGIN_: "ERROR_SET_OVER_MARGIN_",
            ERROR_NO_SD_CARD_: "ERROR_NO_SD_CARD_",
            ERROR_FILE_NOT_SUPPORTED_: "ERROR_FILE_NOT_SUPPORTED_",
            ERROR_EVALUATION_TIMEUP_: "ERROR_EVALUATION_TIMEUP_",
            ERROR_WRONG_CUSTOM_INFO_: "ERROR_WRONG_CUSTOM_INFO_",
            ERROR_NO_ADDRESS_: "ERROR_NO_ADDRESS_",
            ERROR_NOT_MATCH_ADDRESS_: "ERROR_NOT_MATCH_ADDRESS_",
            ERROR_FILE_NOT_FOUND_: "ERROR_FILE_NOT_FOUND_",
            ERROR_TEMPLATE_FILE_NOT_MATCH_MODEL_: "ERROR_TEMPLATE_FILE_NOT_MATCH_MODEL_",
            ERROR_TEMPLATE_NOT_TRANS_MODEL_: "ERROR_TEMPLATE_NOT_TRANS_MODEL_",
            ERROR_COVER_OPEN_: "ERROR_COVER_OPEN_",
            ERROR_WRONG_LABEL_: "ERROR_WRONG_LABEL_",
            ERROR_PORT_NOT_SUPPORTED_: "ERROR_PORT_NOT_SUPPORTED_",
            ERROR_WRONG_TEMPLATE_KEY_: "ERROR_WRONG_TEMPLATE_KEY_",
            ERROR_BUSY_: "ERROR_BUSY_",
            ERROR_TEMPLATE_NOT_PRINT_MODEL_: "ERROR_TEMPLATE_NOT_PRINT_MODEL_",
            ERROR_CANCEL_: "ERROR_CANCEL_",
            ERROR_PRINTER_SETTING_NOT_SUPPORTED_: "ERROR_PRINTER_SETTING_NOT_SUPPORTED_",
            ERROR_INVALID_PARAMETER_: "ERROR_INVALID_PARAMETER_",
            ERROR_INTERNAL_ERROR_: "ERROR_INTERNAL_ERROR_",
            ERROR_TEMPLATE_NOT_CONTROL_MODEL_: "ERROR_TEMPLATE_NOT_CONTROL_MODEL_",
            ERROR_TEMPLATE_NOT_EXIST_: "ERROR_TEMPLATE_NOT_EXIST_",
            ERROR_BADENCRYPT_: "ERROR_BADENCRYPT_",
            ERROR_BUFFER_FULL_: "ERROR_BUFFER_FULL_",
            ERROR_TUBE_EMPTY_: "ERROR_TUBE_EMPTY_",
            ERROR_TUBE_RIBON_EMPTY_: "ERROR_TUBE_RIBON_EMPTY_",
            ERROR_UPDATE_FRIM_NOT_SUPPORTED_: "ERROR_UPDATE_FRIM_NOT_SUPPORTED_",
            ERROR_OS_VERSION_NOT_SUPPORTED_: "ERROR_OS_VERSION_NOT_SUPPORTED_",
            ERROR_MINIMUM_LENGTH_LIMIT_: "ERROR_MINIMUM_LENGTH_LIMIT_",
            ERROR_FAIL_TO_CONVERT_CSV_TO_BLF_: "ERROR_FAIL_TO_CONVERT_CSV_TO_BLF_",
            ERROR_RESOLUTION_MODE_: "ERROR_RESOLUTION_MODE_"
        ]
        if let errorCode = errorCode {
            return errorCodeDic[errorCode] ?? "ERROR_UNKNOWN"
        } else {
            return "ERROR_UNKNOWN"
        }
    }

    static func fetchPrinterStatusErrorCode(error: BRLMPrinterStatusErrorCode?) -> String {
        switch error {
        case .noError:
            return "noError"
        case .noPaper:
            return "noPaper"
        case .coverOpen:
            return "coverOpen"
        case .busy:
            return "busy"
        case .paperJam:
            return "paperJam"
        case .highVoltageAdapter:
            return "highVoltageAdapter"
        case .batteryEmpty:
            return "batteryEmpty"
        case .batteryTrouble:
            return "batteryTrouble"
        case .tubeNotDetected:
            return "tubeNotDetected"
        case .systemError:
            return "systemError"
        case .anotherError:
            return "anotherError"
        case .motorSlow:
            return "motorSlow"
        case .unsupportedCharger:
            return "unsupportedCharger"
        case .incompatibleOptionalEquipment:
            return "incompatibleOptionalEquipment"
        case .none:
            return "none"
        @unknown default:
            return "unknown"
        }
    }

    static func fetchPrintErrorCode(error: BRLMPrintErrorCode?) -> String { // swiftlint:disable:this cyclomatic_complexity function_body_length line_length
        switch error {
        case .noError:
            return "noError"
        case .printSettingsError:
            return "printSettingsError"
        case .filepathURLError:
            return "filepathURLError"
        case .pdfPageError:
            return "pdfPageError"
        case .printSettingsNotSupportError:
            return "printSettingsNotSupportError"
        case .dataBufferError:
            return "dataBufferError"
        case .printerModelError:
            return "printerModelError"
        case .canceled:
            return "canceled"
        case .channelTimeout:
            return "channelTimeout"
        case .setModelError:
            return "setModelError"
        case .unsupportedFile:
            return "unsupportedFile"
        case .setMarginError:
            return "setMarginError"
        case .setLabelSizeError:
            return "setLabelSizeError"
        case .customPaperSizeError:
            return "customPaperSizeError"
        case .setLengthError:
            return "setLengthError"
        case .tubeSettingError:
            return "tubeSettingError"
        case .channelErrorStreamStatusError:
            return "channelErrorStreamStatusError"
        case .channelErrorUnsupportedChannel:
            return "channelErrorUnsupportedChannel"
        case .printerStatusErrorPaperEmpty:
            return "printerStatusErrorPaperEmpty"
        case .printerStatusErrorCoverOpen:
            return "printerStatusErrorCoverOpen"
        case .printerStatusErrorBusy:
            return "printerStatusErrorBusy"
        case .printerStatusErrorPrinterTurnedOff:
            return "printerStatusErrorPrinterTurnedOff"
        case .printerStatusErrorBatteryWeak:
            return "printerStatusErrorBatteryWeak"
        case .printerStatusErrorExpansionBufferFull:
            return "printerStatusErrorExpansionBufferFull"
        case .printerStatusErrorCommunicationError:
            return "printerStatusErrorCommunicationError"
        case .printerStatusErrorPaperJam:
            return "printerStatusErrorPaperJam"
        case .printerStatusErrorMediaCannotBeFed:
            return "printerStatusErrorMediaCannotBeFed"
        case .printerStatusErrorOverHeat:
            return "printerStatusErrorOverHeat"
        case .printerStatusErrorHighVoltageAdapter:
            return "printerStatusErrorHighVoltageAdapter"
        case .printerStatusErrorUnknownError:
            return "printerStatusErrorUnknownError"
        case .templatePrintNotSupported:
            return "templatePrintNotSupported"
        case .invalidTemplateKey:
            return "invalidTemplateKey"
        case .printerStatusErrorMotorSlow:
            return "printerStatusErrorMotorSlow"
        case .unsupportedCharger:
            return "unsupportedCharger"
        case .printerStatusErrorIncompatibleOptionalEquipment:
            return "printerStatusErrorIncompatibleOptionalEquipment"
        case .unknownError, .none:
            return "unknownError"
        @unknown default:
            return "unknownError"
        }
    }
    
    static func fetchRemoveTemplateResultErrorCode(error: BRLMRemoveTemplateErrorCode?) -> String {
        switch error {
        case .noError: return "noError"
        case .unsupported: return "unsupported"
        case .keyNotFound: return "keyNotFound"
        case .connectionFailed: return "connectionFailed"
        case .unresponsiveState: return "unresponsiveState"
        case .aborted: return "aborted"
        case .missingCredential: return "missingCredential"
        case .invalidCredential: return "invalidCredential"
        case .expiredCredential: return "expiredCredential"
        case .mismatchedCredentialFormat: return "mismatchedCredentialFormat"
        case .unknownError: return "unknownError"
        case .none: return "none"
        @unknown default:
            return "unknown"
        }
    }

    static func fetchRemoveTemplateSummaryErrorCode(error: BRLMRemoveTemplateSummaryErrorCode?) -> String {
        switch error {
        case .allSuccess: return "allSuccess"
        case .partialSuccess: return "partialSuccess"
        case .allFailed: return "allFailed"
        case .initializationFailed: return "initializationFailed"
        case .invalidArgument: return "invalidArgument"
        case .unknownError: return "unknownError"
        case .none: return "none"
        @unknown default:
            return "unknown"
        }
    }
    
    static func fetchTransferErrorCode(error: BRLMTransferErrorCode?) -> String { // swiftlint:disable:this cyclomatic_complexity function_body_length line_length
        switch error {
        case .noError: return "NoError"
        case .unsupportedFunction: return "UnsupportedFunction"
        case .unsupportedFunctionByCurrentConnectionInterface: return "UnsupportedFunctionByCurrentConnectionInterface"
        case .fileNotFound: return "FileNotFound"
        case .unsupportedFile: return "UnsupportedFile"
        case .fileNotForSelectedPrinter: return "FileNotForSelectedPrinter"
        case .printerStatusError: return "PrinterStatusError"
        case .connectionFailed: return "ConnectionFailed"
        case .aborted: return "Aborted"
        case .missingCredential: return "missingCredential"
        case .invalidCredential: return "invalidCredential"
        case .expiredCredential: return "expiredCredential"
        case .mismatchedCredentialFormat: return "mismatchedCredentialFormat"
        case .unknownError: return "UnknownError"
        case .none: return "none"
        @unknown default:
            return "unknownError"
        }
    }
    
    static func fetchTransferSummaryErrorCode(error: BRLMTransferSummaryErrorCode?) -> String { // swiftlint:disable:this cyclomatic_complexity function_body_length line_length
        switch error {
        case .allSuccess: return "AllSuccess"
        case .partialSuccess: return "PartialSuccess"
        case .allFailed: return "AllFailed"
        case .initializationFailed: return "InitializationFailed"
        case .invalidArgument: return "InvalidArgument"
        case .unknownError: return "UnknownError"
        case .none: return "none"
        @unknown default:
            return "unknownError"
        }
    }
    
    static func fetchTransferResult<T>(result: BRLMTransferResult<T>?) -> String {
        var description: String = PrintErrorModel.fetchTransferSummaryErrorCode(error: result?.code)
        description += "\n\n"
        description += (result?.errorDetails?.mapValues( { PrintErrorModel.fetchTransferErrorCode(error: BRLMTransferErrorCode(rawValue: UInt($0.intValue))) } ).map{"\($0) : \($1)"}.joined(separator: "\n") ?? "") // swiftlint:disable:line_length
        description += "\n\n"
        description += result?.allLogs.map{$0.description}.joined(separator: "\n") ?? ""
        return description
    }
    
    static func fetchRemoveTemplateResult(result: BRLMRemoveTemplateResult?) -> String {
        var description: String = PrintErrorModel.fetchRemoveTemplateSummaryErrorCode(error: result?.errorCode)
        description += "\n\n"
        description += (result?.errorCodeDetails.mapValues( { PrintErrorModel.fetchRemoveTemplateResultErrorCode(error: BRLMRemoveTemplateErrorCode(rawValue: $0.intValue)) } ).map{"\($0) : \($1)"}.joined(separator: "\n") ?? "") // swiftlint:disable:line_length
        return description
    }
}
