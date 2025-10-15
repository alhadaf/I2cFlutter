# iOS Development Setup Guide

This guide helps you set up a reliable iOS development environment for Flutter projects and avoid common simulator issues.

## Prerequisites

### 1. System Requirements
- macOS 10.15 (Catalina) or later
- Xcode 12.0 or later
- At least 8GB RAM (16GB recommended)
- At least 50GB free disk space

### 2. Required Software
- Xcode (from Mac App Store)
- Xcode Command Line Tools
- Flutter SDK
- CocoaPods

## Initial Setup

### 1. Install Xcode
```bash
# Install from Mac App Store or
# Download from Apple Developer Portal
```

### 2. Install Command Line Tools
```bash
xcode-select --install
```

### 3. Install Flutter
```bash
# Download Flutter SDK
# Add to PATH in ~/.zshrc or ~/.bash_profile
export PATH="$PATH:[PATH_TO_FLUTTER]/flutter/bin"
```

### 4. Install CocoaPods
```bash
sudo gem install cocoapods
```

## Project Configuration

### 1. Bundle Identifier Best Practices

**DO:**
- Use reverse domain notation: `com.yourcompany.appname`
- Use lowercase letters and numbers only
- Make it unique and meaningful
- Keep it consistent across environments

**DON'T:**
- Use `com.example.*` (causes simulator issues)
- Include spaces or special characters
- Use generic names like `com.test.app`

**Examples:**
```
✅ Good: com.eventcheckin.mobile
✅ Good: com.yourcompany.eventapp
❌ Bad: com.example.eventCheckinMobile
❌ Bad: com.test.app
```###
 2. Info.plist Configuration

Ensure your `ios/Runner/Info.plist` includes all required permissions:

```xml
<!-- Camera access for QR scanning -->
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes for event check-in.</string>

<!-- Bluetooth for printer connectivity -->
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app needs Bluetooth access to connect to Brother label printers.</string>

<!-- Local network for WiFi printers -->
<key>NSLocalNetworkUsageDescription</key>
<string>This app needs local network access to discover and connect to printers.</string>
```

### 3. Simulator Management

**Recommended Simulators:**
- iPhone 14 Pro (iOS 16.0+)
- iPhone 13 (iOS 15.0+)
- iPad Pro 12.9" (latest iOS)

**Create Simulators:**
```bash
# List available device types
xcrun simctl list devicetypes

# List available runtimes
xcrun simctl list runtimes

# Create a new simulator
xcrun simctl create "iPhone 14 Pro Test" "iPhone 14 Pro" "iOS-16-0"
```

## Development Workflow

### 1. Daily Startup Routine
```bash
# 1. Check Flutter doctor
flutter doctor

# 2. Check simulator health
./scripts/simulator_health_check.sh

# 3. Boot preferred simulator
xcrun simctl boot "iPhone 14 Pro"

# 4. Verify project dependencies
flutter pub get
cd ios && pod install && cd ..
```

### 2. Before Major Changes
```bash
# Validate current setup
./scripts/app_launch_validation.sh --quick

# Create backup of working configuration
cp ios/Runner.xcodeproj/project.pbxproj ios/Runner.xcodeproj/project.pbxproj.backup
```

### 3. After Major Changes
```bash
# Clean rebuild
./scripts/flutter_clean_rebuild.sh

# Validate everything works
./scripts/app_launch_validation.sh
```

## Maintenance Tasks

### Weekly
- Run simulator health check
- Clean old simulator data: `xcrun simctl delete unavailable`
- Update Flutter: `flutter upgrade`

### Monthly
- Update Xcode
- Clean derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
- Update CocoaPods: `sudo gem update cocoapods`

## Troubleshooting Prevention

### 1. Environment Variables
Add to your shell profile (`~/.zshrc` or `~/.bash_profile`):

```bash
# Flutter
export PATH="$PATH:[PATH_TO_FLUTTER]/flutter/bin"

# iOS Development
export FLUTTER_ROOT="[PATH_TO_FLUTTER]/flutter"
export ANDROID_HOME="$HOME/Library/Android/sdk"

# CocoaPods
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"
```

### 2. Git Ignore Configuration
Ensure your `.gitignore` includes:

```
# iOS
ios/Pods/
ios/Podfile.lock
ios/Runner.xcworkspace/xcuserdata/
ios/build/
ios/DerivedData/

# Flutter
build/
.dart_tool/
.packages
.pub-cache/
.pub/
```

### 3. Regular Validation
Set up a weekly cron job or reminder to run:

```bash
./scripts/simulator_health_check.sh
./scripts/validate_bundle_identifier.sh
```

## Team Development

### 1. Shared Configuration
- Use consistent bundle identifiers across team
- Document required iOS versions
- Share simulator configurations
- Use version control for iOS configuration files

### 2. CI/CD Considerations
- Test on multiple iOS versions
- Validate bundle identifiers in CI
- Include simulator reset in CI cleanup

### 3. Documentation
- Document any custom iOS configurations
- Keep troubleshooting steps updated
- Share working simulator setups

## Performance Optimization

### 1. Simulator Performance
- Close unused simulators
- Allocate sufficient RAM to simulators
- Use SSD storage for better performance
- Don't run multiple simulators simultaneously

### 2. Build Performance
- Use `flutter build ios --debug --simulator` for faster builds
- Enable incremental builds
- Use `--hot-reload` during development

### 3. System Resources
- Monitor memory usage: `memory_pressure`
- Keep at least 20% disk space free
- Close unnecessary applications during development

## Security Best Practices

### 1. Code Signing
- Use automatic signing for development
- Keep provisioning profiles updated
- Don't commit signing certificates to version control

### 2. Bundle Identifiers
- Use unique identifiers for each environment
- Don't use generic or test identifiers in production
- Register bundle identifiers with Apple Developer Program

### 3. Permissions
- Only request necessary permissions
- Provide clear, descriptive permission messages
- Test permission flows thoroughly

## Useful Commands Reference

```bash
# Simulator Management
xcrun simctl list devices                    # List all simulators
xcrun simctl boot [DEVICE_ID]               # Boot specific simulator
xcrun simctl shutdown all                   # Shutdown all simulators
xcrun simctl erase all                      # Erase all simulator data

# App Management
xcrun simctl install [DEVICE_ID] [APP_PATH] # Install app
xcrun simctl launch [DEVICE_ID] [BUNDLE_ID] # Launch app
xcrun simctl uninstall [DEVICE_ID] [BUNDLE_ID] # Uninstall app

# Debugging
xcrun simctl spawn [DEVICE_ID] log stream   # View logs
xcrun simctl list apps [DEVICE_ID]          # List installed apps
xcrun simctl privacy [DEVICE_ID] reset all [BUNDLE_ID] # Reset permissions

# Flutter Commands
flutter devices                             # List available devices
flutter run -d [DEVICE_ID]                 # Run on specific device
flutter build ios --debug --simulator      # Build for simulator
flutter clean                              # Clean project
```

This setup guide should help you maintain a stable iOS development environment and avoid the common issues that lead to simulator launch failures.