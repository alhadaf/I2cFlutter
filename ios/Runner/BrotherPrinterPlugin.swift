import Flutter
import UIKit
import ExternalAccessory
import CoreBluetooth

// Brother SDK temporarily disabled for simulator compatibility
// #if !targetEnvironment(simulator)
// import BRLMPrinterKit
// #endif

// MARK: - Protocol Definitions for Simulator Compatibility

// Mock types for all builds (Brother SDK temporarily disabled)
// #if targetEnvironment(simulator)
class MockBRLMChannel {
    private let connectionType: String
    
    init(bluetoothSerialName: String) { 
        self.connectionType = "bluetooth"
    }
    
    init(wifiIPAddress: String, port: UInt16) { 
        self.connectionType = "wifi"
    }
    
    init(mfiAccessoryName: String) { 
        self.connectionType = "mfi"
    }
}

class MockBRLMPrinterDriver {
    func printImage(with image: UIImage, settings: Any?) -> MockBRLMPrintError {
        return MockBRLMPrintError()
    }
    
    func getPrinterStatus() -> MockBRLMPrintError {
        return MockBRLMPrintError()
    }
}

class MockBRLMPrinterDriverGenerator {
    static func open(_ channel: MockBRLMChannel) -> MockBRLMPrinterDriver? {
        return MockBRLMPrinterDriver()
    }
}

class MockBRLMPrintError {
    enum Code: Int {
        case noError = 0
        case simulatorMode = 999
    }
    
    let code: Code = .simulatorMode
    let description: String = "Simulator mode - Brother SDK not available"
}

class MockBRLMQLPrintSettings {
    var numCopies: Int = 1
    var autoCut: Bool = true
    
    init?(defaultPrintSettingsWith model: Any) {}
}

class MockBRLMPrinter {
    let ipAddress: String? = "192.168.1.100"
    let modelName: String? = "Mock Brother Printer"
    let macAddress: String? = "00:00:00:00:00:00"
}

class MockBRLMPrinterSearcher {
    func searchWiFiPrinters(_ timeout: Double, completion: @escaping ([MockBRLMPrinter]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion([MockBRLMPrinter()])
        }
    }
}

// Type aliases for simulator compatibility
typealias BRLMChannel = MockBRLMChannel
typealias BRLMPrinterDriver = MockBRLMPrinterDriver
typealias BRLMPrinterDriverGenerator = MockBRLMPrinterDriverGenerator
typealias BRLMPrintError = MockBRLMPrintError
typealias BRLMQLPrintSettings = MockBRLMQLPrintSettings
typealias BRLMPrinter = MockBRLMPrinter
typealias BRLMPrinterSearcher = MockBRLMPrinterSearcher

// #endif

@objc class BrotherPrinterPlugin: NSObject, FlutterPlugin, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    private var methodChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    
    private var centralManager: CBCentralManager?
    private var connectedPeripheral: CBPeripheral?
    private var discoveredPrinters: [String: [String: Any]] = [:]
    private var isScanning = false
    
    // Brother SDK components (new API)
    private var printerDriver: BRLMPrinterDriver?
    private var channel: BRLMChannel?
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let instance = BrotherPrinterPlugin()
        
        let methodChannel = FlutterMethodChannel(
            name: "brother_printer",
            binaryMessenger: registrar.messenger()
        )
        
        let eventChannel = FlutterEventChannel(
            name: "brother_printer_events",
            binaryMessenger: registrar.messenger()
        )
        
        instance.methodChannel = methodChannel
        instance.eventChannel = eventChannel
        
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            initialize(result: result)
        case "discoverPrinters":
            discoverPrinters(result: result)
        case "connectToPrinter":
            connectToPrinter(call: call, result: result)
        case "disconnect":
            disconnect(result: result)
        case "printBadge":
            printBadge(call: call, result: result)
        case "getPrinterStatus":
            getPrinterStatus(result: result)
        case "getPrinterCapabilities":
            getPrinterCapabilities(call: call, result: result)
        case "testConnection":
            testConnection(result: result)
        case "setPrintSettings":
            setPrintSettings(call: call, result: result)
        case "connectDirectly":
            connectDirectly(call: call, result: result)
        case "printDirectly":
            printDirectly(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initialize(result: @escaping FlutterResult) {
        do {
            // Initialize Core Bluetooth
            centralManager = CBCentralManager(delegate: self, queue: nil)
            
            result(true)
            sendEvent(type: "initialized", data: [
                "success": true,
                "mockMode": true,
                "message": "Running in mock mode - Brother SDK features are mocked"
            ])
        } catch {
            result(FlutterError(
                code: "INIT_ERROR",
                message: "Failed to initialize Brother SDK: \(error.localizedDescription)",
                details: nil
            ))
        }
    }
    
    private func discoverPrinters(result: @escaping FlutterResult) {
        if isScanning {
            result(Array(discoveredPrinters.values))
            return
        }
        
        discoveredPrinters.removeAll()
        isScanning = true
        
        // Discover MFi printers
        discoverMFiPrinters()
        
        // Discover Bluetooth printers
        discoverBluetoothPrinters()
        
        // Discover WiFi printers using new SDK
        discoverWiFiPrinters()
        
        // Return results after discovery timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isScanning = false
            result(Array(self.discoveredPrinters.values))
        }
    }
    
    private func discoverMFiPrinters() {
        // Discover MFi-certified Brother printers using External Accessory
        let accessories = EAAccessoryManager.shared().connectedAccessories
        
        for accessory in accessories {
            if isBrotherPrinter(accessory: accessory) {
                let printerInfo = createMFiPrinterInfo(accessory: accessory)
                discoveredPrinters[printerInfo["id"] as! String] = printerInfo
                sendEvent(type: "printerDiscovered", data: printerInfo)
            }
        }
    }
    
    private func discoverBluetoothPrinters() {
        guard let centralManager = centralManager,
              centralManager.state == .poweredOn else {
            print("Bluetooth not available")
            return
        }
        
        // Scan for Brother printer services
        let brotherServiceUUIDs = [
            CBUUID(string: "E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"), // Brother service UUID
        ]
        
        centralManager.scanForPeripherals(withServices: brotherServiceUUIDs, options: nil)
        
        // Stop scanning after timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            centralManager.stopScan()
        }
    }
    
    private func discoverWiFiPrinters() {
        DispatchQueue.global(qos: .background).async {
            // Use Brother SDK to discover network printers
            let searcher = BRLMPrinterSearcher()
            
            searcher.searchWiFiPrinters(5.0) { [weak self] printers in
                guard let self = self else { return }
                
                for printer in printers {
                    let printerInfo = self.createWiFiPrinterInfo(printer: printer)
                    DispatchQueue.main.async {
                        self.discoveredPrinters[printerInfo["id"] as! String] = printerInfo
                        self.sendEvent(type: "printerDiscovered", data: printerInfo)
                        
                        // Add mock mode indicator
                        var mockInfo = printerInfo
                        mockInfo["mockMode"] = true
                        mockInfo["name"] = "\(printerInfo["name"] as? String ?? "Printer") (Mock)"
                        self.discoveredPrinters[printerInfo["id"] as! String] = mockInfo
                    }
                }
            }
        }
    }
    
    private func connectToPrinter(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let printerId = args["printerId"] as? String,
              let connectionType = args["connectionType"] as? String else {
            result(FlutterError(
                code: "INVALID_ARGS",
                message: "Missing printerId or connectionType",
                details: nil
            ))
            return
        }
        
        guard let printerInfo = discoveredPrinters[printerId] else {
            result(FlutterError(
                code: "PRINTER_NOT_FOUND",
                message: "Printer not found: \(printerId)",
                details: nil
            ))
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let success: Bool
            
            switch connectionType {
            case "mfi":
                success = self.connectMFi(printerInfo: printerInfo)
            case "bluetooth":
                success = self.connectBluetooth(printerInfo: printerInfo)
            case "wifi":
                success = self.connectWiFi(printerInfo: printerInfo)
            default:
                success = false
            }
            
            DispatchQueue.main.async {
                if success {
                    result(true)
                    self.sendEvent(type: "statusChanged", data: ["status": "connected"])
                } else {
                    result(false)
                    self.sendEvent(type: "statusChanged", data: ["status": "error"])
                }
            }
        }
    }
    
    private func connectMFi(printerInfo: [String: Any]) -> Bool {
        // Mock mode - mock connection success
        channel = MockBRLMChannel(mfiAccessoryName: "MockMFiPrinter")
        return true
    }
    
    private func connectBluetooth(printerInfo: [String: Any]) -> Bool {
        // Mock mode - mock connection success
        channel = MockBRLMChannel(bluetoothSerialName: "MockPrinter")
        return true
    }
    
    private func connectWiFi(printerInfo: [String: Any]) -> Bool {
        // Mock mode - mock connection success
        channel = MockBRLMChannel(wifiIPAddress: "192.168.1.100", port: 9100)
        return true
    }
    
    private func connectDirectly(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let connectionType = args["connectionType"] as? String else {
            result(false)
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            var success = false
            
            switch connectionType {
            case "bluetooth":
                if let bluetoothAddress = args["bluetoothAddress"] as? String {
                    self.channel = MockBRLMChannel(bluetoothSerialName: bluetoothAddress)
                    success = true
                }
            case "wifi":
                if let ipAddress = args["ipAddress"] as? String {
                    let port = args["port"] as? Int ?? 9100
                    self.channel = MockBRLMChannel(wifiIPAddress: ipAddress, port: UInt16(port))
                    success = true
                }
            default:
                break
            }
            
            DispatchQueue.main.async {
                result(success)
                if success {
                    self.sendEvent(type: "statusChanged", data: ["status": "connected"])
                }
            }
        }
    }
    
    private func disconnect(result: @escaping FlutterResult) {
        channel = nil
        printerDriver = nil
        connectedPeripheral = nil
        
        result(true)
        sendEvent(type: "statusChanged", data: ["status": "disconnected"])
    }
    
    private func printBadge(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let imageData = args["imageData"] as? FlutterStandardTypedData,
              let printSettings = args["printSettings"] as? [String: Any] else {
            result([
                "success": false,
                "error": "Missing imageData or printSettings"
            ])
            return
        }
        
        // Mock mode - return mock success (Brother SDK temporarily disabled)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            result([
                "success": true,
                "message": "Print completed successfully (Mock Mode)",
                "mockMode": true
            ])
            self.sendEvent(type: "statusChanged", data: ["status": "connected"])
        }
        return
        
        guard let channel = self.channel else {
            result([
                "success": false,
                "error": "No printer connected"
            ])
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            do {
                // Convert image data to UIImage
                guard let image = UIImage(data: imageData.data) else {
                    DispatchQueue.main.async {
                        result([
                            "success": false,
                            "error": "Invalid image data"
                        ])
                    }
                    return
                }
                
                // Create printer driver with Brother SDK
                guard let printerDriver = BRLMPrinterDriverGenerator.open(channel) else {
                    DispatchQueue.main.async {
                        result([
                            "success": false,
                            "error": "Failed to create printer driver"
                        ])
                    }
                    return
                }
                
                self.printerDriver = printerDriver
                
                // Configure print settings for QL series (most common) - Mock mode
                let qlPrintSettings = BRLMQLPrintSettings(defaultPrintSettingsWith: "QL_820NWB")
                
                // Apply custom settings
                if let copies = printSettings["copies"] as? Int {
                    qlPrintSettings?.numCopies = copies
                }
                
                if let autoCut = printSettings["autoCut"] as? Bool {
                    qlPrintSettings?.autoCut = autoCut
                }
                
                // Print image using Brother SDK
                let printError = printerDriver.printImage(with: image, settings: qlPrintSettings)
                
                DispatchQueue.main.async {
                    if printError.code == .noError {
                        result([
                            "success": true,
                            "message": "Print completed successfully"
                        ])
                        self.sendEvent(type: "statusChanged", data: ["status": "connected"])
                    } else {
                        result([
                            "success": false,
                            "error": "Print failed: \(printError.description)",
                            "errorCode": printError.code.rawValue
                        ])
                        self.sendEvent(type: "statusChanged", data: ["status": "error"])
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    result([
                        "success": false,
                        "error": "Print exception: \(error.localizedDescription)",
                        "errorCode": "PRINT_EXCEPTION"
                    ])
                }
            }
        }
    }
    
    private func printDirectly(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let imageData = args["imageData"] as? FlutterStandardTypedData,
              let printSettings = args["printSettings"] as? [String: Any],
              let connectionType = args["connectionType"] as? String else {
            result([
                "success": false,
                "error": "Missing required parameters"
            ])
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            // Create direct connection
            var channel: BRLMChannel?
            
            switch connectionType {
            case "bluetooth":
                if let bluetoothAddress = args["bluetoothAddress"] as? String {
                    channel = MockBRLMChannel(bluetoothSerialName: bluetoothAddress)
                }
            case "wifi":
                if let ipAddress = args["ipAddress"] as? String {
                    let port = args["port"] as? Int ?? 9100
                    channel = MockBRLMChannel(wifiIPAddress: ipAddress, port: UInt16(port))
                }
            default:
                break
            }
            
            guard let validChannel = channel else {
                DispatchQueue.main.async {
                    result([
                        "success": false,
                        "error": "Failed to create connection"
                    ])
                }
                return
            }
            
            // Convert image and print
            guard let image = UIImage(data: imageData.data),
                  let printerDriver = MockBRLMPrinterDriverGenerator.open(validChannel) else {
                DispatchQueue.main.async {
                    result([
                        "success": false,
                        "error": "Failed to initialize printing"
                    ])
                }
                return
            }
            
            // Mock mode print settings
            let qlPrintSettings = MockBRLMQLPrintSettings(defaultPrintSettingsWith: "QL_820NWB")
            let printError = printerDriver.printImage(with: image, settings: qlPrintSettings)
            
            DispatchQueue.main.async {
                result([
                    "success": printError.code == .noError,
                    "error": printError.code == .noError ? nil : printError.description,
                    "errorCode": printError.code.rawValue
                ])
            }
        }
    }
    
    private func getPrinterStatus(result: @escaping FlutterResult) {
        guard let printerDriver = self.printerDriver else {
            result([
                "connected": false,
                "error": "Printer not connected"
            ])
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let status = printerDriver.getPrinterStatus()
            let connected = status.code == .noError
            
            DispatchQueue.main.async {
                result([
                    "connected": connected,
                    "status": connected ? "connected" : "disconnected",
                    "errorCode": status.code.rawValue
                ])
            }
        }
    }
    
    private func getPrinterCapabilities(call: FlutterMethodCall, result: @escaping FlutterResult) {
        // Return default capabilities for Brother printers
        result(getDefaultCapabilities())
    }
    
    private func testConnection(result: @escaping FlutterResult) {
        guard let printerDriver = self.printerDriver else {
            result(false)
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let status = printerDriver.getPrinterStatus()
            let connected = status.code == .noError
            
            DispatchQueue.main.async {
                result(connected)
            }
        }
    }
    
    private func setPrintSettings(call: FlutterMethodCall, result: @escaping FlutterResult) {
        // Settings are applied during printing in the new SDK
        result(true)
    }
    
    // MARK: - Helper Methods
    
    private func isBrotherPrinter(accessory: EAAccessory) -> Bool {
        let name = accessory.name.lowercased()
        return name.contains("brother") ||
               name.contains("ql-") ||
               name.contains("pt-") ||
               name.contains("td-")
    }
    
    private func createMFiPrinterInfo(accessory: EAAccessory) -> [String: Any] {
        return [
            "id": "mfi_\(accessory.serialNumber)",
            "name": accessory.name,
            "model": accessory.modelNumber,
            "connectionType": "mfi",
            "accessoryName": accessory.name,
            "status": "disconnected",
            "isMfiCertified": true,
            "capabilities": getDefaultCapabilities(),
            "connectionData": [
                "serialNumber": accessory.serialNumber,
                "manufacturer": accessory.manufacturer,
                "modelNumber": accessory.modelNumber
            ],
            "lastSeen": Date().timeIntervalSince1970 * 1000
        ]
    }
    
    private func createWiFiPrinterInfo(printer: BRLMPrinter) -> [String: Any] {
        return [
            "id": "wifi_\(printer.ipAddress ?? "unknown")",
            "name": printer.modelName ?? "Brother Printer",
            "model": printer.modelName ?? "Unknown",
            "connectionType": "wifi",
            "ipAddress": printer.ipAddress ?? "",
            "status": "disconnected",
            "isMfiCertified": false,
            "capabilities": getDefaultCapabilities(),
            "connectionData": [
                "ipAddress": printer.ipAddress ?? "",
                "macAddress": printer.macAddress ?? ""
            ],
            "lastSeen": Date().timeIntervalSince1970 * 1000
        ]
    }
    
    private func getDefaultCapabilities() -> [String: Any] {
        return [
            "supportedLabelSizes": [
                [
                    "id": "62x29",
                    "name": "Address Label (62x29mm)",
                    "widthMm": 62,
                    "heightMm": 29,
                    "isRoll": true
                ],
                [
                    "id": "62x100",
                    "name": "Shipping Label (62x100mm)",
                    "widthMm": 62,
                    "heightMm": 100,
                    "isRoll": true
                ]
            ],
            "maxResolutionDpi": 300,
            "supportsColor": false,
            "supportsCutting": true,
            "maxPrintWidth": 62,
            "supportedFormats": ["PNG", "BMP"],
            "supportsBluetooth": true,
            "supportsWifi": true,
            "supportsUsb": false
        ]
    }
    
    private func sendEvent(type: String, data: [String: Any]) {
        eventSink?([
            "type": type,
            "data": data,
            "timestamp": Date().timeIntervalSince1970 * 1000
        ])
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth powered on")
        case .poweredOff:
            print("Bluetooth powered off")
        case .unauthorized:
            print("Bluetooth unauthorized")
        case .unsupported:
            print("Bluetooth unsupported")
        default:
            print("Bluetooth state: \(central.state.rawValue)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let name = peripheral.name ?? "Unknown"
        
        if isBrotherBluetoothPrinter(name: name) {
            let printerInfo = createBluetoothPrinterInfo(peripheral: peripheral)
            discoveredPrinters[printerInfo["id"] as! String] = printerInfo
            sendEvent(type: "printerDiscovered", data: printerInfo)
        }
    }
    
    private func isBrotherBluetoothPrinter(name: String) -> Bool {
        let lowercaseName = name.lowercased()
        return lowercaseName.contains("brother") ||
               lowercaseName.contains("ql-") ||
               lowercaseName.contains("pt-") ||
               lowercaseName.contains("td-")
    }
    
    private func createBluetoothPrinterInfo(peripheral: CBPeripheral) -> [String: Any] {
        return [
            "id": "bt_\(peripheral.identifier.uuidString)",
            "name": peripheral.name ?? "Brother Printer",
            "model": peripheral.name ?? "Unknown",
            "connectionType": "bluetooth",
            "bluetoothName": peripheral.name ?? "",
            "status": "disconnected",
            "isMfiCertified": false,
            "capabilities": getDefaultCapabilities(),
            "connectionData": [
                "bluetoothId": peripheral.identifier.uuidString,
                "bluetoothName": peripheral.name ?? ""
            ],
            "lastSeen": Date().timeIntervalSince1970 * 1000
        ]
    }
}

// MARK: - FlutterStreamHandler

extension BrotherPrinterPlugin: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}