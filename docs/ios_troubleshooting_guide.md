# iOS Simulator Troubleshooting Guide

This guide helps you resolve common iOS simulator issues, particularly the "The request was denied by service delegate (SBMainWorkspace)" error.

## Quick Fix (Most Common Solution)

If you're experiencing the SBMainWorkspace error, try this first:

```bash
# Run the comprehensive reset script
./scripts/ios_simulator_reset.sh
```

This script will:
- Reset all simulators
- Clean Flutter project
- Update dependencies
- Boot a fresh simulator

## Common Issues and Solutions

### 1. SBMainWorkspace Error

**Error Message:**
```
Error: Unable to launch com.example.eventCheckinMobile on [DEVICE_ID]:
ProcessException: Process exited abnormally with exit code 1:
An error was encountered processing the command (domain=FBSOpenApplicationServiceErrorDomain, code=1):
Simulator device failed to launch com.example.eventCheckinMobile.
The request was denied by service delegate (SBMainWorkspace).
```

**Causes:**
- Corrupted simulator state
- Bundle identifier conflicts (especially `com.example.*`)
- Incomplete app installation
- iOS simulator service issues

**Solutions (in order of effectiveness):**

1. **Complete Reset (Recommended)**
   ```bash
   ./scripts/ios_simulator_reset.sh
   ```

2. **Bundle Identifier Fix**
   ```bash
   ./scripts/validate_bundle_identifier.sh
   ```

3. **Simulator-Only Reset**
   ```bash
   ./scripts/ios_simulator_reset_only.sh
   ```

4. **Flutter Clean Rebuild**
   ```bash
   ./scripts/flutter_clean_rebuild.sh
   ```

### 2. Simulator Won't Boot

**Symptoms:**
- Simulator appears to start but never becomes responsive
- Simulator status shows "Booting" indefinitely
- Black screen on simulator

**Solutions:**

1. **Check Simulator Health**
   ```bash
   ./scripts/simulator_health_check.sh
   ```

2. **Manual Reset**
   ```bash
   xcrun simctl shutdown all
   xcrun simctl erase all
   xcrun simctl boot [DEVICE_ID]
   ```

3. **Restart Simulator Services**
   ```bash
   sudo pkill -f "Simulator"
   sudo pkill -f "CoreSimulator"
   ```

### 3. Build Failures

**Common Build Errors:**
- CocoaPods issues
- Missing dependencies
- Xcode configuration problems

**Solutions:**

1. **Complete Clean Rebuild**
   ```bash
   ./scripts/flutter_clean_rebuild.sh
   ```

2. **Manual iOS Cleanup**
   ```bash
   cd ios
   rm -rf Pods Podfile.lock build
   pod install --repo-update
   cd ..
   flutter clean
   flutter pub get
   ```

### 4. Bundle Identifier Issues

**Symptoms:**
- Apps with `com.example.*` bundle IDs failing to launch
- Multiple apps with same bundle ID
- Invalid bundle identifier format

**Solutions:**

1. **Validate and Fix Bundle ID**
   ```bash
   ./scripts/validate_bundle_identifier.sh
   ```

2. **Manual Bundle ID Update**
   ```bash
   ./scripts/update_bundle_identifier.sh
   ```

### 5. Permission Issues

**Symptoms:**
- App crashes immediately after launch
- Permission dialogs not appearing
- Features not working (camera, Bluetooth, etc.)

**Solutions:**

1. **Check Info.plist Configuration**
   - Ensure all required permission descriptions are present
   - Verify permission strings are descriptive

2. **Reset Simulator Permissions**
   ```bash
   xcrun simctl privacy [DEVICE_ID] reset all [BUNDLE_ID]
   ```

## Diagnostic Commands

### Check Simulator Status
```bash
xcrun simctl list devices
```

### Check Available Simulators
```bash
xcrun simctl list devices available
```

### Check Booted Simulators
```bash
xcrun simctl list devices | grep Booted
```

### Check Installed Apps
```bash
xcrun simctl list apps [DEVICE_ID]
```

### View Simulator Logs
```bash
xcrun simctl spawn [DEVICE_ID] log stream --predicate 'eventMessage contains "[YOUR_APP_NAME]"'
```

### Check System Logs
```bash
tail -f ~/Library/Logs/CoreSimulator/CoreSimulator.log
```

## Advanced Troubleshooting

### 1. Complete System Reset

If all else fails, perform a complete reset:

```bash
# 1. Quit Xcode and Simulator
pkill -f "Xcode"
pkill -f "Simulator"

# 2. Reset all simulators
xcrun simctl shutdown all
xcrun simctl erase all

# 3. Clean Flutter completely
flutter clean
rm -rf ~/.pub-cache
flutter pub cache repair

# 4. Clean iOS completely
cd ios
rm -rf Pods Podfile.lock build DerivedData
cd ..

# 5. Reinstall dependencies
flutter pub get
cd ios && pod install --repo-update && cd ..

# 6. Restart computer (if needed)
```

### 2. Xcode Reset

Sometimes Xcode itself needs to be reset:

```bash
# Close Xcode first
pkill -f "Xcode"

# Clear Xcode derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Clear Xcode archives
rm -rf ~/Library/Developer/Xcode/Archives

# Restart Xcode
open -a Xcode
```

### 3. Check System Resources

Low system resources can cause simulator issues:

```bash
# Check memory usage
memory_pressure

# Check disk space
df -h

# Check running processes
ps aux | grep -E "(Simulator|Xcode|Flutter)"
```

## Prevention Tips

### 1. Regular Maintenance
- Run simulator health checks weekly
- Clean old simulator data regularly
- Keep Xcode and Flutter updated

### 2. Best Practices
- Use proper bundle identifiers (avoid `com.example.*`)
- Don't run multiple simulators simultaneously
- Close simulators when not in use
- Restart simulators after major changes

### 3. Development Workflow
- Use the validation scripts before major releases
- Test on multiple simulator types
- Keep backups of working configurations

## Script Reference

| Script | Purpose | Usage |
|--------|---------|-------|
| `ios_simulator_reset.sh` | Complete reset and recovery | `./scripts/ios_simulator_reset.sh` |
| `ios_simulator_reset_only.sh` | Simulator-only reset | `./scripts/ios_simulator_reset_only.sh` |
| `flutter_clean_rebuild.sh` | Flutter project cleanup | `./scripts/flutter_clean_rebuild.sh` |
| `validate_bundle_identifier.sh` | Bundle ID validation | `./scripts/validate_bundle_identifier.sh` |
| `update_bundle_identifier.sh` | Bundle ID update | `./scripts/update_bundle_identifier.sh` |
| `simulator_health_check.sh` | System diagnostics | `./scripts/simulator_health_check.sh` |
| `app_launch_validation.sh` | App launch testing | `./scripts/app_launch_validation.sh` |

## Getting Help

If you're still experiencing issues after trying these solutions:

1. Run the health check script for diagnostics
2. Check the Flutter doctor output
3. Review simulator logs for specific errors
4. Consider updating Xcode and Flutter to latest versions

## Common Error Codes

| Error Code | Description | Solution |
|------------|-------------|----------|
| FBSOpenApplicationServiceErrorDomain, code=1 | SBMainWorkspace delegate error | Reset simulator and bundle ID |
| LaunchServicesError error 0 | App not properly installed | Reinstall app |
| CoreSimulatorError | Simulator service issue | Restart simulator services |
| DeviceNotFoundError | Simulator not available | Boot simulator or create new one |

Remember: Most iOS simulator issues can be resolved with a complete reset using the provided scripts. Start with the simplest solution and work your way up to more complex fixes.