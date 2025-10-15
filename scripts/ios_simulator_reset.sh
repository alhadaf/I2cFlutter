#!/bin/bash

# iOS Simulator Reset and Recovery Script
# This script fixes common iOS simulator launch issues

set -e

echo "🔧 iOS Simulator Reset and Recovery Script"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only"
    exit 1
fi

# Check if Xcode command line tools are installed
if ! command -v xcrun &> /dev/null; then
    print_error "Xcode command line tools not found. Please install Xcode."
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter not found. Please install Flutter."
    exit 1
fi

print_status "Starting iOS simulator reset and recovery process..."

# Step 1: Shutdown all simulators
print_status "Shutting down all iOS simulators..."
xcrun simctl shutdown all 2>/dev/null || true
print_success "All simulators shut down"

# Step 2: List current simulators (for debugging)
print_status "Current simulator status:"
xcrun simctl list devices | grep -E "(Booted|Shutdown)" || true

# Step 3: Erase all simulators
print_warning "This will erase all simulator data. Continue? (y/N)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    print_status "Erasing all simulator data..."
    xcrun simctl erase all
    print_success "All simulator data erased"
else
    print_warning "Skipping simulator data erasure"
fi

# Step 4: Clean Flutter project
print_status "Cleaning Flutter project..."
flutter clean
print_success "Flutter project cleaned"

# Step 5: Clean iOS specific files
print_status "Cleaning iOS build files..."
if [ -d "ios" ]; then
    cd ios
    
    # Remove Pods and Podfile.lock
    if [ -d "Pods" ]; then
        rm -rf Pods
        print_success "Removed Pods directory"
    fi
    
    if [ -f "Podfile.lock" ]; then
        rm -f Podfile.lock
        print_success "Removed Podfile.lock"
    fi
    
    # Remove build directories
    if [ -d "build" ]; then
        rm -rf build
        print_success "Removed iOS build directory"
    fi
    
    # Remove DerivedData
    if [ -d "DerivedData" ]; then
        rm -rf DerivedData
        print_success "Removed DerivedData"
    fi
    
    cd ..
else
    print_warning "iOS directory not found"
fi

# Step 6: Get Flutter dependencies
print_status "Getting Flutter dependencies..."
flutter pub get
print_success "Flutter dependencies updated"

# Step 7: Install iOS dependencies
if [ -d "ios" ]; then
    print_status "Installing iOS dependencies..."
    cd ios
    
    # Check if CocoaPods is installed
    if command -v pod &> /dev/null; then
        pod install --repo-update
        print_success "iOS dependencies installed"
    else
        print_warning "CocoaPods not found. Installing..."
        sudo gem install cocoapods
        pod install --repo-update
        print_success "CocoaPods installed and dependencies updated"
    fi
    
    cd ..
fi

# Step 8: Boot a fresh simulator
print_status "Booting a fresh iOS simulator..."
# Get the first available iPhone simulator
SIMULATOR_ID=$(xcrun simctl list devices available | grep -E "iPhone.*\(" | head -1 | grep -o "([A-F0-9-]*)" | tr -d "()")

if [ -n "$SIMULATOR_ID" ]; then
    xcrun simctl boot "$SIMULATOR_ID"
    print_success "Simulator booted: $SIMULATOR_ID"
    
    # Wait for simulator to be ready
    print_status "Waiting for simulator to be ready..."
    sleep 5
    
    # Check simulator status
    STATUS=$(xcrun simctl list devices | grep "$SIMULATOR_ID" | grep -o "Booted\|Shutdown")
    if [ "$STATUS" = "Booted" ]; then
        print_success "Simulator is ready"
    else
        print_warning "Simulator may not be fully ready"
    fi
else
    print_warning "No available iPhone simulator found"
fi

# Step 9: Final status check
print_status "Final system status:"
echo "Flutter doctor:"
flutter doctor --verbose | head -20

echo ""
print_status "Available simulators:"
xcrun simctl list devices available | grep -E "iPhone|iPad" | head -5

echo ""
print_success "Recovery process completed!"
print_status "You can now try running: flutter run"

# Optional: Ask if user wants to run the app immediately
echo ""
print_warning "Would you like to run the Flutter app now? (y/N)"
read -r run_response
if [[ "$run_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    print_status "Running Flutter app..."
    flutter run
fi