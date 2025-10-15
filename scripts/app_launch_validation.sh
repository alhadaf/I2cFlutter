#!/bin/bash

# App Launch Validation Script
# This script validates that the Flutter app can be properly installed and launched

set -e

echo "🔧 App Launch Validation"
echo "========================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if we're on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is designed for macOS only"
        exit 1
    fi
    
    # Check if Flutter is installed
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter not found. Please install Flutter."
        exit 1
    fi
    
    # Check if we're in a Flutter project
    if [ ! -f "pubspec.yaml" ]; then
        print_error "Not in a Flutter project directory"
        exit 1
    fi
    
    # Check if iOS directory exists
    if [ ! -d "ios" ]; then
        print_error "iOS directory not found. This doesn't appear to be a Flutter project with iOS support."
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Function to get bundle identifier
get_bundle_identifier() {
    if [ -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
        grep "PRODUCT_BUNDLE_IDENTIFIER" "ios/Runner.xcodeproj/project.pbxproj" | head -1 | sed 's/.*= \(.*\);/\1/' | tr -d ' '
    else
        print_error "Cannot find bundle identifier"
        return 1
    fi
}

# Function to validate Flutter project
validate_flutter_project() {
    print_status "Validating Flutter project configuration..."
    
    # Check pubspec.yaml
    if [ -f "pubspec.yaml" ]; then
        local app_name=$(grep "^name:" pubspec.yaml | cut -d' ' -f2)
        print_status "App name: $app_name"
    fi
    
    # Check Flutter dependencies
    print_status "Checking Flutter dependencies..."
    if flutter pub deps > /dev/null 2>&1; then
        print_success "Flutter dependencies are valid"
    else
        print_warning "Flutter dependencies may have issues"
        print_status "Running flutter pub get..."
        flutter pub get
    fi
    
    # Validate iOS configuration
    print_status "Validating iOS configuration..."
    local bundle_id=$(get_bundle_identifier)
    if [ -n "$bundle_id" ]; then
        print_status "Bundle identifier: $bundle_id"
        
        # Check for problematic bundle ID
        if [[ $bundle_id == com.example* ]]; then
            print_warning "Bundle identifier uses 'com.example' prefix - this may cause issues"
            print_status "Consider running: ./scripts/validate_bundle_identifier.sh"
        else
            print_success "Bundle identifier looks good"
        fi
    fi
}

# Function to check simulator availability
check_simulator_availability() {
    print_status "Checking simulator availability..."
    
    # Check if any simulators are available
    local available_simulators=$(xcrun simctl list devices available | grep -E "iPhone.*\(" | wc -l)
    if [ "$available_simulators" -eq 0 ]; then
        print_error "No available iPhone simulators found"
        print_status "Available simulators:"
        xcrun simctl list devices available
        return 1
    fi
    
    print_success "Found $available_simulators available iPhone simulators"
    
    # Check if a simulator is already booted
    local booted_simulator=$(xcrun simctl list devices | grep "Booted" | head -1)
    if [ -n "$booted_simulator" ]; then
        print_success "Simulator is already booted:"
        echo "$booted_simulator"
        return 0
    else
        print_status "No simulator is currently booted"
        return 1
    fi
}

# Function to boot simulator if needed
boot_simulator_if_needed() {
    if ! check_simulator_availability; then
        print_status "Booting a simulator..."
        
        # Get the first available iPhone simulator
        local simulator_id=$(xcrun simctl list devices available | grep -E "iPhone.*\(" | head -1 | grep -o "([A-F0-9-]*)" | tr -d "()")
        
        if [ -n "$simulator_id" ]; then
            print_status "Booting simulator: $simulator_id"
            xcrun simctl boot "$simulator_id"
            
            # Wait for simulator to be ready
            print_status "Waiting for simulator to boot..."
            sleep 10
            
            # Verify simulator is booted
            if xcrun simctl list devices | grep "$simulator_id" | grep -q "Booted"; then
                print_success "Simulator booted successfully"
            else
                print_error "Failed to boot simulator"
                return 1
            fi
        else
            print_error "No suitable simulator found"
            return 1
        fi
    fi
}

# Function to validate app build
validate_app_build() {
    print_status "Validating app build..."
    
    # Try to build the app for iOS
    print_status "Building Flutter app for iOS (debug mode)..."
    if flutter build ios --debug --no-codesign --simulator; then
        print_success "App build successful"
    else
        print_error "App build failed"
        print_status "Common build issues:"
        print_status "1. Missing dependencies - run: flutter pub get"
        print_status "2. iOS dependencies - run: cd ios && pod install"
        print_status "3. Clean build - run: ./scripts/flutter_clean_rebuild.sh"
        return 1
    fi
}

# Function to test app installation
test_app_installation() {
    print_status "Testing app installation on simulator..."
    
    # Get the booted simulator
    local simulator_id=$(xcrun simctl list devices | grep "Booted" | head -1 | grep -o "([A-F0-9-]*)" | tr -d "()")
    
    if [ -z "$simulator_id" ]; then
        print_error "No booted simulator found"
        return 1
    fi
    
    # Get bundle identifier
    local bundle_id=$(get_bundle_identifier)
    if [ -z "$bundle_id" ]; then
        print_error "Cannot determine bundle identifier"
        return 1
    fi
    
    # Check if app is already installed
    if xcrun simctl list apps "$simulator_id" | grep -q "$bundle_id"; then
        print_status "App is already installed, uninstalling first..."
        xcrun simctl uninstall "$simulator_id" "$bundle_id" || true
    fi
    
    # Find the app bundle
    local app_bundle=$(find "build/ios/iphonesimulator" -name "*.app" -type d | head -1)
    if [ -z "$app_bundle" ]; then
        print_error "Cannot find built app bundle"
        print_status "Make sure to build the app first: flutter build ios --debug --simulator"
        return 1
    fi
    
    print_status "Installing app bundle: $app_bundle"
    if xcrun simctl install "$simulator_id" "$app_bundle"; then
        print_success "App installed successfully"
    else
        print_error "App installation failed"
        return 1
    fi
    
    # Verify installation
    if xcrun simctl list apps "$simulator_id" | grep -q "$bundle_id"; then
        print_success "App installation verified"
    else
        print_error "App installation verification failed"
        return 1
    fi
}

# Function to test app launch
test_app_launch() {
    print_status "Testing app launch..."
    
    # Get the booted simulator
    local simulator_id=$(xcrun simctl list devices | grep "Booted" | head -1 | grep -o "([A-F0-9-]*)" | tr -d "()")
    local bundle_id=$(get_bundle_identifier)
    
    if [ -z "$simulator_id" ] || [ -z "$bundle_id" ]; then
        print_error "Cannot determine simulator ID or bundle identifier"
        return 1
    fi
    
    print_status "Launching app: $bundle_id"
    if xcrun simctl launch "$simulator_id" "$bundle_id"; then
        print_success "App launched successfully"
        
        # Wait a moment and check if app is still running
        sleep 3
        if xcrun simctl list apps "$simulator_id" | grep "$bundle_id" | grep -q "Running"; then
            print_success "App is running successfully"
        else
            print_warning "App may have crashed after launch"
            print_status "Check simulator logs for details"
        fi
    else
        print_error "App launch failed"
        print_status "This is the error you were experiencing!"
        print_status "Possible solutions:"
        print_status "1. Reset simulator: ./scripts/ios_simulator_reset_only.sh"
        print_status "2. Clean rebuild: ./scripts/flutter_clean_rebuild.sh"
        print_status "3. Check bundle ID: ./scripts/validate_bundle_identifier.sh"
        return 1
    fi
}

# Function to validate permissions
validate_permissions() {
    print_status "Validating app permissions..."
    
    # Check Info.plist for required permissions
    if [ -f "ios/Runner/Info.plist" ]; then
        local permissions_found=0
        
        # Check for camera permission
        if grep -q "NSCameraUsageDescription" "ios/Runner/Info.plist"; then
            print_success "Camera permission description found"
            permissions_found=$((permissions_found + 1))
        fi
        
        # Check for Bluetooth permission
        if grep -q "NSBluetoothAlwaysUsageDescription" "ios/Runner/Info.plist"; then
            print_success "Bluetooth permission description found"
            permissions_found=$((permissions_found + 1))
        fi
        
        # Check for network permission
        if grep -q "NSLocalNetworkUsageDescription" "ios/Runner/Info.plist"; then
            print_success "Local network permission description found"
            permissions_found=$((permissions_found + 1))
        fi
        
        print_status "Found $permissions_found permission descriptions"
    else
        print_warning "Info.plist not found"
    fi
}

# Main validation function
run_validation() {
    print_status "Starting comprehensive app launch validation..."
    echo ""
    
    # Run all validation steps
    check_prerequisites
    echo ""
    
    validate_flutter_project
    echo ""
    
    boot_simulator_if_needed
    echo ""
    
    validate_app_build
    echo ""
    
    test_app_installation
    echo ""
    
    test_app_launch
    echo ""
    
    validate_permissions
    echo ""
    
    print_success "App launch validation completed successfully!"
    print_status "Your app should now be able to launch without the SBMainWorkspace error"
}

# Function to run quick validation (without full build)
run_quick_validation() {
    print_status "Running quick validation (no build)..."
    
    check_prerequisites
    validate_flutter_project
    boot_simulator_if_needed
    validate_permissions
    
    print_success "Quick validation completed!"
}

# Main execution
if [ "$1" = "--quick" ]; then
    run_quick_validation
else
    run_validation
fi