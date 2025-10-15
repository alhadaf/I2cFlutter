# iOS Simulator Build Guide for Brother SDK

This guide explains how the Brother SDK is conditionally excluded from iOS simulator builds to ensure compatibility and prevent build errors.

## Overview

The Brother SDK (BRLMPrinterKit) is not compatible with iOS simulators, which can cause build failures and runtime crashes when developing and testing the app. This implementation provides conditional compilation to exclude the Brother SDK from simulator builds while providing mock functionality for testing.

## Implementation Details

### 1. Conditional Compilation in Swift

The `BrotherPrinterPlugin.swift` file uses conditional compilation to exclude Brother SDK imports and provide mock implementations for simulator builds:

```swift
#if !targetEnvironment(simulator)
import BRLMPrinterKit
#endif

#if targetEnvironment(simulator)
// Mock types and implementations for simulator
class MockBRLMChannel { ... }
class MockBRLMPrinterDriver { ... }
// ... other mock classes
#endif
```

### 2. Flutter-Side Detection

The Flutter `BrotherPrinterService` detects simulator mode and provides appropriate mock behavior:

```dart
static bool get isSimulator {
  if (!Platform.isIOS) return false;
  
  return Platform.environment.containsKey('SIMULATOR_DEVICE_NAME') ||
         Platform.environment.containsKey('SIMULATOR_UDID') ||
         Platform.environment['FLUTTER_TEST'] == 'true';
}
```

### 3. Build Script Integration

The `conditional_brother_sdk.sh` script handles framework linking based on the build target:

- **Simulator builds**: Excludes Brother SDK framework
- **Device builds**: Includes Brother SDK framework from XCFramework

## Features in Simulator Mode

When running in simulator mode, the app provides:

### Mock Printers
- Brother QL-820NWB (WiFi) - Simulator
- Brother QL-810W (Bluetooth) - Simulator

### Mock Functionality
- Printer discovery with simulated delay
- Connection simulation with status updates
- Print job simulation with realistic timing
- Status monitoring and event handling

### UI Indicators
- Settings screen shows "iOS Simulator Mode" indicator
- Print results include simulator mode flags
- Debug logs clearly indicate simulator operations

## Development Workflow

### Building for Simulator
```bash
# Standard Flutter build for simulator
flutter build ios --simulator
```

The build system automatically:
1. Excludes Brother SDK framework
2. Uses mock implementations
3. Provides simulator-specific UI feedback

### Building for Device
```bash
# Standard Flutter build for device
flutter build ios --release
```

The build system automatically:
1. Includes Brother SDK framework
2. Uses real Brother SDK implementations
3. Provides full printer functionality

## Testing in Simulator

### Available Test Scenarios
1. **Printer Discovery**: Mock printers appear after simulated delay
2. **Connection Testing**: Simulated connection success/failure
3. **Print Operations**: Mock print jobs with realistic timing
4. **Error Handling**: Simulated error conditions
5. **UI Flows**: Complete check-in workflow testing

### Limitations in Simulator
- No actual printer communication
- No real Bluetooth/WiFi scanning
- No physical print output
- No MFi authentication testing

## Troubleshooting

### Build Errors
If you encounter build errors related to Brother SDK:

1. **Clean build folder**: `flutter clean && cd ios && rm -rf Pods/ Podfile.lock`
2. **Reinstall pods**: `pod install`
3. **Verify XCFramework**: Check that `BRLMPrinterKit.xcframework` exists in `ios/Frameworks/`

### Runtime Issues
If the app crashes in simulator:

1. Check that conditional compilation is working
2. Verify simulator detection logic
3. Review debug logs for simulator mode indicators

### Missing Mock Features
If certain features don't work in simulator:

1. Add mock implementations to the Swift mock classes
2. Update Flutter simulator detection logic
3. Extend mock printer capabilities as needed

## File Structure

```
ios/
├── Runner/
│   ├── BrotherPrinterPlugin.swift          # Main plugin with conditional compilation
│   └── ...
├── Frameworks/
│   └── BRLMPrinterKit.xcframework/         # Brother SDK (device builds only)
├── conditional_brother_sdk.sh              # Build script for framework linking
├── Podfile                                 # CocoaPods configuration
└── SIMULATOR_BUILD_GUIDE.md               # This guide

lib/services/
├── brother_printer_service.dart           # Service with simulator detection
└── ...
```

## Best Practices

### For Development
1. Test UI flows in simulator using mock printers
2. Test actual printing on physical devices
3. Use debug logs to verify simulator/device mode
4. Keep mock implementations up-to-date with real SDK

### For Production
1. Always test final builds on physical devices
2. Verify Brother SDK integration works correctly
3. Test all supported printer models
4. Validate MFi authentication on real hardware

## Future Enhancements

Potential improvements to simulator support:

1. **Enhanced Mock Printers**: More realistic printer models and capabilities
2. **Error Simulation**: Configurable error scenarios for testing
3. **Print Preview**: Visual representation of print output in simulator
4. **Network Simulation**: Mock network printer discovery
5. **Configuration UI**: Settings to control mock behavior

## Support

For issues related to simulator builds:

1. Check this guide for common solutions
2. Review debug logs for simulator mode indicators
3. Verify conditional compilation is working correctly
4. Test on both simulator and physical device