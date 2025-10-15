import Flutter
import UIKit
import ExternalAccessory

@objc class MFiAuthenticationPlugin: NSObject, FlutterPlugin {
    
    private var methodChannel: FlutterMethodChannel?
    private var accessoryManager: EAAccessoryManager?
    private var authenticatedAccessories: Set<String> = []
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MFiAuthenticationPlugin()
        
        let methodChannel = FlutterMethodChannel(
            name: "mfi_authentication",
            binaryMessenger: registrar.messenger()
        )
        
        instance.methodChannel = methodChannel
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            initialize(result: result)
        case "isAuthRequired":
            isAuthRequired(call: call, result: result)
        case "authenticate":
            authenticate(call: call, result: result)
        case "validateCertificate":
            validateCertificate(call: call, result: result)
        case "getSupportedProtocols":
            getSupportedProtocols(result: result)
        case "isMFiSupported":
            isMFiSupported(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initialize(result: @escaping FlutterResult) {
        do {
            accessoryManager = EAAccessoryManager.shared()
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(accessoryDidConnect(_:)),
                name: .EAAccessoryDidConnect,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(accessoryDidDisconnect(_:)),
                name: .EAAccessoryDidDisconnect,
                object: nil
            )
            
            result(true)
        } catch {
            result(FlutterError(
                code: "INIT_ERROR",
                message: "Failed to initialize MFi authentication: \(error.localizedDescription)",
                details: nil
            ))
        }
    }
    
    private func isAuthRequired(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let printerId = args["printerId"] as? String,
              let connectionData = args["connectionData"] as? [String: Any] else {
            result(FlutterError(
                code: "INVALID_ARGS",
                message: "Missing printerId or connectionData",
                details: nil
            ))
            return
        }
        
        if authenticatedAccessories.contains(printerId) {
            result(false)
            return
        }
        
        if let serialNumber = connectionData["serialNumber"] as? String {
            let accessories = EAAccessoryManager.shared().connectedAccessories
            
            for accessory in accessories {
                if accessory.serialNumber == serialNumber {
                    let requiresAuth = isBrotherMFiAccessory(accessory)
                    result(requiresAuth)
                    return
                }
            }
        }
        
        result(false)
    }
    
    private func authenticate(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let printerId = args["printerId"] as? String,
              let connectionData = args["connectionData"] as? [String: Any] else {
            result([
                "success": false,
                "error": "Missing printerId or connectionData"
            ])
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let authResult = self.performMFiAuthentication(
                printerId: printerId,
                connectionData: connectionData
            )
            
            DispatchQueue.main.async {
                result(authResult)
            }
        }
    }
    
    private func performMFiAuthentication(printerId: String, connectionData: [String: Any]) -> [String: Any] {
        guard let serialNumber = connectionData["serialNumber"] as? String else {
            return [
                "success": false,
                "error": "Missing serial number in connection data"
            ]
        }
        
        let accessories = EAAccessoryManager.shared().connectedAccessories
        
        for accessory in accessories {
            if accessory.serialNumber == serialNumber {
                return authenticateAccessory(accessory, printerId: printerId)
            }
        }
        
        return [
            "success": false,
            "error": "Accessory not found for authentication"
        ]
    }
    
    private func authenticateAccessory(_ accessory: EAAccessory, printerId: String) -> [String: Any] {
        let supportedProtocols = ["com.brother.ptcbp", "com.brother.mfp"]
        var authenticatedProtocol: String?
        
        for protocolString in supportedProtocols {
            if accessory.protocolStrings.contains(protocolString) {
                authenticatedProtocol = protocolString
                break
            }
        }
        
        guard let protocolToUse = authenticatedProtocol else {
            return [
                "success": false,
                "error": "No supported Brother protocols found"
            ]
        }
        
        let session = EASession(accessory: accessory, forProtocol: protocolToUse)
        
        if session != nil {
            authenticatedAccessories.insert(printerId)
            
            session?.inputStream?.close()
            session?.outputStream?.close()
            
            return [
                "success": true,
                "certificateInfo": getCertificateInfo(accessory),
                "additionalData": [
                    "protocol": protocolToUse,
                    "manufacturer": accessory.manufacturer,
                    "modelNumber": accessory.modelNumber,
                    "serialNumber": accessory.serialNumber,
                    "firmwareRevision": accessory.firmwareRevision,
                    "hardwareRevision": accessory.hardwareRevision
                ]
            ]
        } else {
            return [
                "success": false,
                "error": "Failed to establish session with MFi accessory"
            ]
        }
    }
    
    private func validateCertificate(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let printerId = args["printerId"] as? String,
              let connectionData = args["connectionData"] as? [String: Any] else {
            result(false)
            return
        }
        
        guard let serialNumber = connectionData["serialNumber"] as? String else {
            result(false)
            return
        }
        
        let accessories = EAAccessoryManager.shared().connectedAccessories
        
        for accessory in accessories {
            if accessory.serialNumber == serialNumber {
                let isValid = validateAccessoryCertificate(accessory)
                result(isValid)
                return
            }
        }
        
        result(false)
    }
    
    private func validateAccessoryCertificate(_ accessory: EAAccessory) -> Bool {
        guard !accessory.manufacturer.isEmpty,
              !accessory.modelNumber.isEmpty,
              !accessory.serialNumber.isEmpty else {
            return false
        }
        
        if !isBrotherMFiAccessory(accessory) {
            return false
        }
        
        let supportedProtocols = ["com.brother.ptcbp", "com.brother.mfp"]
        let hasValidProtocol = supportedProtocols.contains { protocolString in
            accessory.protocolStrings.contains(protocolString)
        }
        
        return hasValidProtocol
    }
    
    private func getSupportedProtocols(result: @escaping FlutterResult) {
        let protocols = ["com.brother.ptcbp", "com.brother.mfp"]
        result(protocols)
    }
    
    private func isMFiSupported(result: @escaping FlutterResult) {
        let supported = EAAccessoryManager.shared() != nil
        result(supported)
    }
    
    private func isBrotherMFiAccessory(_ accessory: EAAccessory) -> Bool {
        let manufacturer = accessory.manufacturer.lowercased()
        let modelNumber = accessory.modelNumber.lowercased()
        
        return manufacturer.contains("brother") ||
               modelNumber.contains("brother") ||
               modelNumber.contains("ql-") ||
               modelNumber.contains("pt-") ||
               modelNumber.contains("td-")
    }
    
    private func getCertificateInfo(_ accessory: EAAccessory) -> String {
        var info = "MFi Certified Accessory\n"
        info += "Manufacturer: \(accessory.manufacturer)\n"
        info += "Model: \(accessory.modelNumber)\n"
        info += "Serial: \(accessory.serialNumber)\n"
        info += "Firmware: \(accessory.firmwareRevision)\n"
        info += "Hardware: \(accessory.hardwareRevision)\n"
        info += "Protocols: \(accessory.protocolStrings.joined(separator: ", "))"
        
        return info
    }
    
    @objc private func accessoryDidConnect(_ notification: Notification) {
        guard let accessory = notification.userInfo?[EAAccessoryKey] as? EAAccessory else {
            return
        }
        
        print("MFi accessory connected: \(accessory.name)")
        
        if isBrotherMFiAccessory(accessory) {
            // Could send notification to Flutter about new Brother MFi printer
        }
    }
    
    @objc private func accessoryDidDisconnect(_ notification: Notification) {
        guard let accessory = notification.userInfo?[EAAccessoryKey] as? EAAccessory else {
            return
        }
        
        print("MFi accessory disconnected: \(accessory.name)")
        
        // In a real implementation, you'd have a mapping between printer IDs and serial numbers
        // For now, we'll just leave the authenticated accessories as is
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}