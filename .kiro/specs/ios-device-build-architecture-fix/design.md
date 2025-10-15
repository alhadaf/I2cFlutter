# Design Document

## Overview

The iOS device build failure is caused by a Flutter framework architecture mismatch. The error indicates that the Flutter.framework binary contains only `arm64` architecture, but the build system expects both `arm64` and `x86_64` architectures. This is problematic because device builds should only require `arm64` for physical devices, while `x86_64` is needed for simulators. The issue stems from incorrect architecture configuration in the Xcode project and potentially corrupted Flutter framework binaries.

## Architecture

### Problem Analysis
The error "Binary does not contain architectures 'arm64 x86_64'" occurs because:
1. **Incorrect Architecture Configuration**: The Xcode project is configured with `ARCHS = "arm64 x86_64"` for Release builds, which is incorrect for device-only builds
2. **Flutter Framework State**: The Flutter.framework may be in an inconsistent state with missing architectures
3. **Build Configuration Mismatch**: The build system expects simulator architectures during device builds
4. **Lipo Processing Issues**: The thin binary script is failing to process the framework correctly

### Root Cause
Device builds should use only `arm64` architecture, while the current configuration includes `x86_64` (simulator architecture). This causes the build system to expect both architectures in the Flutter framework, but device builds only generate `arm64`.

## Components and Interfaces

### 1. Architecture Configuration Manager
- **Purpose**: Manage architecture settings for different build targets
- **Functions**:
  - `validateArchitectureSettings()`: Check current architecture configuration
  - `updateDeviceBuildArchs()`: Set correct architectures for device builds
  - `updateSimulatorBuildArchs()`: Set correct architectures for simulator builds
  - `detectBuildTarget()`: Determine if building for device or simulator

### 2. Flutter Framework Validator
- **Purpose**: Ensure Flutter framework is in correct state for builds
- **Functions**:
  - `validateFrameworkArchitectures()`: Check available architectures in framework
  - `rebuildFlutterFramework()`: Force rebuild of Flutter framework
  - `cleanFrameworkCache()`: Clear corrupted framework binaries

### 3. Build Configuration Fixer
- **Purpose**: Automatically fix architecture-related build configurations
- **Functions**:
  - `fixXcodeArchSettings()`: Update Xcode project architecture settings
  - `updateBuildConfigurations()`: Ensure consistent configuration across build types
  - `validateBuildSettings()`: Check for configuration conflicts

## Data Models

### Architecture Configuration
```
ArchConfig {
  buildType: enum (device, simulator, universal)
  architectures: array<string> (e.g., ["arm64"] for device, ["arm64", "x86_64"] for simulator)
  validArchs: array<string>
  excludedArchs: array<string>
}
```

### Build Target
```
BuildTarget {
  platform: enum (iphoneos, iphonesimulator)
  configuration: enum (Debug, Release, Profile)
  architectures: array<string>
  sdkVersion: string
}
```

## Error Handling

### Error Categories
1. **Architecture Mismatch**: Handle cases where expected vs actual architectures don't match
2. **Framework Corruption**: Handle corrupted or incomplete Flutter framework binaries
3. **Build Configuration Errors**: Handle incorrect Xcode project settings
4. **Lipo Processing Failures**: Handle binary processing and thinning errors

### Recovery Strategies
1. **Automatic Architecture Fix**: Detect build target and set appropriate architectures
2. **Framework Rebuild**: Force clean rebuild of Flutter framework when corrupted
3. **Configuration Reset**: Reset Xcode project to correct architecture settings
4. **Incremental Fixes**: Apply targeted fixes without full project rebuild

## Testing Strategy

### Validation Tests
1. **Architecture Detection Test**: Verify correct architecture detection for different build targets
2. **Framework Validation Test**: Check Flutter framework contains expected architectures
3. **Build Configuration Test**: Validate Xcode project settings are correct
4. **Device Build Test**: Verify successful device build and archive

### Integration Tests
1. **End-to-End Device Build**: Full build cycle for device deployment
2. **Simulator Build Compatibility**: Ensure simulator builds still work after fixes
3. **Multi-Configuration Test**: Test Debug, Release, and Profile configurations
4. **Framework Recovery Test**: Test recovery from corrupted framework state

## Implementation Approach

### Phase 1: Immediate Fix
1. **Correct Architecture Settings**: Update Xcode project to use device-appropriate architectures
2. **Clean Flutter State**: Remove corrupted Flutter framework and rebuild
3. **Validate Build Target**: Ensure build system targets correct platform

### Phase 2: Automated Detection and Fix
1. **Build Target Detection**: Automatically detect device vs simulator builds
2. **Dynamic Architecture Configuration**: Set architectures based on build target
3. **Framework Health Monitoring**: Detect and fix framework corruption

### Phase 3: Prevention and Monitoring
1. **Pre-build Validation**: Check configuration before starting builds
2. **Build Health Checks**: Monitor for architecture-related issues
3. **Configuration Templates**: Provide correct configuration templates

## Technical Details

### Correct Architecture Settings
- **Device Builds (iphoneos)**: `ARCHS = "arm64"`, `VALID_ARCHS = "arm64"`
- **Simulator Builds (iphonesimulator)**: `ARCHS = "arm64 x86_64"`, `VALID_ARCHS = "arm64 x86_64"`
- **Universal Builds**: Use build-time detection to set appropriate architectures

### Flutter Framework Management
- **Framework Location**: `ios/Flutter/Flutter.framework`
- **Architecture Check**: Use `lipo -info` to verify available architectures
- **Rebuild Command**: `flutter clean && flutter build ios --release`

### Xcode Project Updates
- **Target**: Runner project in `ios/Runner.xcodeproj/project.pbxproj`
- **Configurations**: Update Debug, Release, and Profile build configurations
- **Settings**: Focus on `ARCHS`, `VALID_ARCHS`, and `EXCLUDED_ARCHS` settings