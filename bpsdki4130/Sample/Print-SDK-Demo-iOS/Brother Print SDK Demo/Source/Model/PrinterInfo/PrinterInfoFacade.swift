//
//  PrinterInfoFacade.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/28.
//

import BRLMPrinterKit
import Foundation

class PrinterInfoFacade {

    // fetch Printer Firm Version
    func fetchMainFirmVersion(printerInfo: DiscoveredPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestMainFirmVersion()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)
    }

    // fetch Printer Serial Number
    func fetchSerial(printerInfo: DiscoveredPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestSerialNumber()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)
    }

    // fetch Printer Status
    func fetchStatus(printerInfo: DiscoveredPrinterInfo, callback: @escaping (String) -> Void) {
        DispatchQueue.global().async {
            guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: printerInfo) else {
                DispatchQueue.main.async {
                    callback(NSLocalizedString("create_channel_error", comment: ""))
                }
                return
            }
            let credential = PrinterConnectUtil().fetchCurrentChannelCredential(printerInfo: printerInfo)
            let generateResult = PrinterConnectUtil().generatePrinterDriver(channel: channel, channelCredential: credential)
            if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
                DispatchQueue.main.async {
                    callback(OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code))
                }
                return
            }
            let driver = generateResult.driver
            let printError = driver?.getPrinterStatus()
            driver?.closeChannel()
            DispatchQueue.main.async {
                callback(self.getStatusDetail(status: printError?.status))
            }
        }
    }

    // fetch Printer Media Version
    func fetchMediaVersion(printerInfo: DiscoveredPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestMediaVersion()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)
    }

    // fetch Printer System Report
    func fetchSystemReport(printerInfo: DiscoveredPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestSystemReport()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)
    }

    // fetch Printer Battery Info
    func fetchBatteryInfo(printerInfo: DiscoveredPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestBatteryInfo()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)

    }
    
    // fetch Boot mode
    func fetchIsBootMode(printerInfo: DiscoveredPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestIsBootMode()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)
    }

    // fetch internal model flag
    func fetchInternalModelFlag(printerInfo: DiscoveredPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestPrinterInternalModelFlag()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)
    }

    func fetchBluetoothFirmVersion(printerInfo: DiscoveredPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestBluetoothFirmVersion()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)
    }
    
    func fetchTemplateInfoList(printerInfo: DiscoveredPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestTemplateInfoList()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)
    }

    func fetchPtouchDeviceDependedDataHeaderList(printerInfo: DiscoveredPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestPtouchDeviceDependedDataHeaderList()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)
    }

    
    private func generateDriver(printerInfo: DiscoveredPrinterInfo, errorString: inout String) -> BRLMPrinterDriver? {
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: printerInfo) else {
            errorString = NSLocalizedString("create_channel_error", comment: "")
            return nil
        }
        let credential = PrinterConnectUtil().fetchCurrentChannelCredential(printerInfo: printerInfo)
        let generateResult = PrinterConnectUtil().generatePrinterDriver(channel: channel, channelCredential: credential)
        if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
            errorString = OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code)
            return nil
        }
        guard let  driver = generateResult.driver else {
            errorString = NSLocalizedString("unknown_error", comment: "")
            return nil
        }
        return driver
    }

    private func generateResultString(getPrinterInfoResult: Any) -> String {
        var resultString = NSLocalizedString("unknown_error", comment: "")
        if let result = getPrinterInfoResult as? BRLMRequestPrinterInfoResult<AnyObject> {
            resultString = "\(NSLocalizedString("result", comment: "")) : "
            + "\(RequestPrinterInfoErrorModel.fetchGetPrinterInfoErrorCode(error: result.error.code))\n"
            if let value = result.printerInfo as? String {
                resultString += "\(NSLocalizedString("value", comment: "")) : \(value)"
            } else if let value = result.printerInfo as? BRLMBatteryInfo {
                resultString += "\(NSLocalizedString("battery_charge", comment: "")) : "
                + "\(value.chargeLevel)\n"
                + "\(NSLocalizedString("battery_health", comment: "")) : "
                + "\(value.healthLevel)\n"
                + "\(NSLocalizedString("battery_health_level", comment: "")) : "
                + "\(getBatteryHealthLevelString(healthStatus: value.healthStatus))"
            } else if let value = result.printerInfo as? NSNumber {
                resultString += "\(NSLocalizedString("value", comment: "")) : \(value)"
            } else if let value = result.printerInfo as? [BRLMPtouchTemplateInfo] {
                resultString += "\(NSLocalizedString("value", comment: "")) : \(generateTemplateInfoString(templateInfos: value))"
            } else if let value = result.printerInfo as? [BRLMPtouchDeviceDependedDataHeader] {
                resultString += "\(NSLocalizedString("value", comment: "")) : \(generatePtouchDeviceDependedDataHeaderString(pdddhArray: value))"
            }


            resultString += "\n\n" + result.error.allLogs.description
        }

        return resultString
    }

    private func generatePtouchDeviceDependedDataHeaderString(pdddhArray: [BRLMPtouchDeviceDependedDataHeader]) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long

        return pdddhArray.map { pdddh in
            return """
            dataKind: \(generateDataKingStrng(dataKind: pdddh.dataKind))
            version:  \(pdddh.version ?? "")
            name:  \(pdddh.name ?? "")
            dataSize:  \(pdddh.dataSize)
            destinationCode:  \(pdddh.destinationCode ?? "")
            modifiedDate:  \(dateFormatter.string(from: pdddh.modifiedDate))
            """
        }.joined(separator: "\n\n")
        
    }
    
    private func generateDataKingStrng(dataKind:BRLMPtouchDeviceDependedDataHeaderDataKind) -> String {
        var datakindString = ""
        switch dataKind {
        case .mainFirm:
            datakindString = NSLocalizedString("main_firm", comment: "")
        case .template:
            datakindString = NSLocalizedString("template", comment: "")
        case .database:
            datakindString = NSLocalizedString("database", comment: "")
        case .media:
            datakindString = NSLocalizedString("media", comment: "")
        case .font:
            datakindString = NSLocalizedString("font", comment: "")
        case .bootFirm:
            datakindString = NSLocalizedString("boot_firm", comment: "")
        case .bluetoothFirm:
            datakindString = NSLocalizedString("bluetooth_firm", comment: "")
        case .anyFirm:
            datakindString = NSLocalizedString("any_firm", comment: "")
        case .userData:
            datakindString = NSLocalizedString("userData", comment: "")
        case .other:
            datakindString = NSLocalizedString("other", comment: "")
        @unknown default:
            datakindString = NSLocalizedString("unknown", comment: "")
        }
        return datakindString
    }
    
    

    
    private func generateTemplateInfoString(templateInfos: [BRLMPtouchTemplateInfo]) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        return templateInfos.map { templateInfo in
            let modifiedDateString = dateFormatter.string(from: templateInfo.modifiedDate)
            let fileName = templateInfo.fileName ?? "nil"
            
            return """
            fileName: \(fileName)
            key: \(templateInfo.key)
            fileSize: \(templateInfo.fileSize)
            checkSum: \(templateInfo.checksum)
            modifiedDate: \(modifiedDateString)
            rawModifiedDate: \(templateInfo.rawModifiedDate)
            """
        }.joined(separator: "\n\n")
    }
    
    private func getBatteryHealthLevelString(healthStatus: BRLMBatteryInfoHealthStatus) -> String {
        var healthStatusString = ""
        switch healthStatus {
        case .excellent:
            healthStatusString = NSLocalizedString("battery_health_excellent", comment: "")
        case .good:
            healthStatusString = NSLocalizedString("battery_health_good", comment: "")
        case .replaceSoon:
            healthStatusString = NSLocalizedString("battery_health_replace_soon", comment: "")
        case .replaceBattery:
            healthStatusString = NSLocalizedString("battery_health_replace_battery", comment: "")
        case .notInstalled:
            healthStatusString = NSLocalizedString("battery_health_not_installed", comment: "")
        @unknown default:
            healthStatusString = NSLocalizedString("battery_health_not_installed", comment: "")
        }
        return healthStatusString
    }

    private func getStatusDetail(status: BRLMPrinterStatus?) -> String {
        guard let status = status else { return "" }
        let error = "Error: " + PrintErrorModel.fetchPrinterStatusErrorCode(error: status.errorCode) + "\n"
        let model = "Model: " + (PrinterModel.allCases.first(where: { value in
            value.printerModel == status.model
        })?.rawValue ?? "") + "\n"
        let mediaType = "MediaInfo.MediaType: " + EnumToString.mediaTypeName(mediaType: status.mediaInfo?.mediaType) + "\n"
        let mediaBackgroundColor = "MediaInfo.BackgroundColor: " +
        EnumToString.mediaBackgroundColor(color: status.mediaInfo?.backgroundColor) + "\n"
        let mediaInkColor = "MediaInfo.InkColor: " + EnumToString.mediaInkColor(color: status.mediaInfo?.inkColor) + "\n"
        let mediaWidth = "MediaInfo.Width: " +
        (status.mediaInfo?.width_mm == nil ? "none" : String(status.mediaInfo?.width_mm ?? 0)) + "\n"
        let mediaHeight = "MediaInfo.Height: " +
        (status.mediaInfo?.height_mm == nil ? "none" : String(status.mediaInfo?.height_mm ?? 0)) + "\n"
        let mediaIsHeightInfinite = "MediaInfo.IsHeightInfinite: " +
        (status.mediaInfo?.isHeightInfinite == nil ? "none" : String(status.mediaInfo?.isHeightInfinite ?? false)) + "\n"
        var getQLLabelResult: Bool = false
        var getPTLabelResult: Bool = false
        let mediaQLLabelSize = "MediaInfo.QLLabelSize: " +
        EnumToString.qlLabelSize(size: status.mediaInfo?.getQLLabelSize(&getQLLabelResult)) + "\n"
        let mediaPTLabelSize = "MediaInfo.PTLabelSize: " +
        EnumToString.ptLabelSize(size: status.mediaInfo?.getPTLabelSize(&getPTLabelResult)) + "\n"

        let mediaInfo = status.mediaInfo == nil ? "MediaInfo: none\n" :
        (mediaType + mediaBackgroundColor + mediaInkColor + mediaWidth +
         mediaHeight + mediaIsHeightInfinite + mediaQLLabelSize + mediaPTLabelSize)
        let batteryInfo = "BatteryMounted: " +
        EnumToString.printerBatteryStatusTernary(ternary: status.batteryStatus?.batteryMounted) + "\n" +
        "Charging: " + EnumToString.printerBatteryStatusTernary(ternary: status.batteryStatus?.charging) + "\n" +
        "ChargingLevel(current/max): " + (status.batteryStatus?.chargeLevel.current.description ?? "") + "/" +
        (status.batteryStatus?.chargeLevel.max.description ?? "")
        return model + error + mediaInfo + batteryInfo
    }
}
