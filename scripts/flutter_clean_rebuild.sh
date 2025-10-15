#!/bin/bash

# Flutter Clean Rebuild Script
# This script performs a complete Flutter project cleanup and rebuild

set -e

echo "🔧 Flutter Clean Rebuild Script"
echo "==============================="

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

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter not found. Please install Flutter."
    exit 1
fi

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    print_error "Not in a Flutter project directory. Please run this script from your Flutter project root."
    exit 1
fi

print_status "Starting Flutter clean rebuild process..."

# Step 1: Flutter clean
print_status "Running flutter clean..."
flutter clean
print_success "Flutter clean completed"

# Step 2: Clean build directories
print_status "Cleaning build directories..."

# Remove general build directory
if [ -d "build" ]; then
    rm -rf build
    print_success "Removed build directory"
fi

# Remove .dart_tool directory
if [ -d ".dart_tool" ]; then
    rm -rf .dart_tool
    print_success "Removed .dart_tool directory"
fi

# Step 3: Clean iOS specific files
if [ -d "ios" ]; then
    print_status "Cleaning iOS specific files..."
    cd ios
    
    # Remove Pods directory
    if [ -d "Pods" ]; then
        rm -rf Pods
        print_success "Removed Pods directory"
    fi
    
    # Remove Podfile.lock
    if [ -f "Podfile.lock" ]; then
        rm -f Podfile.lock
        print_success "Removed Podfile.lock"
    fi
    
    # Remove iOS build directory
    if [ -d "build" ]; then
        rm -rf build
        print_success "Removed iOS build directory"
    fi
    
    # Remove DerivedData if present
    if [ -d "DerivedData" ]; then
        rm -rf DerivedData
        print_success "Removed DerivedData"
    fi
    
    # Clean Xcode build cache
    if [ -d "Runner.xcworkspace/xcuserdata" ]; then
        rm -rf Runner.xcworkspace/xcuserdata
        print_success "Removed Xcode user data"
    fi
    
    cd ..
else
    print_warning "iOS directory not found"
fi

# Step 4: Clean Android specific files (if present)
if [ -d "android" ]; then
    print_status "Cleaning Android specific files..."
    cd android
    
    # Remove build directories
    if [ -d "build" ]; then
        rm -rf build
        print_success "Removed Android build directory"
    fi
    
    if [ -d "app/build" ]; then
        rm -rf app/build
        print_success "Removed Android app build directory"
    fi
    
    # Remove gradle cache
    if [ -d ".gradle" ]; then
        rm -rf .gradle
        print_success "Removed Gradle cache"
    fi
    
    cd ..
fi

# Step 5: Get Flutter dependencies
print_status "Getting Flutter dependencies..."
flutter pub get
print_success "Flutter dependencies updated"

# Step 6: Install iOS dependencies
if [ -d "ios" ]; then
    print_status "Installing iOS dependencies..."
    cd ios
    
    # Check if CocoaPods is installed
    if command -v pod &> /dev/null; then
        print_status "Running pod install..."
        pod install --repo-update
        print_success "iOS dependencies installed"
    else
        print_warning "CocoaPods not found. Please install CocoaPods:"
        print_warning "sudo gem install cocoapods"
        print_warning "Then run: cd ios && pod install"
    fi
    
    cd ..
fi

# Step 7: Verify Flutter setup
print_status "Verifying Flutter setup..."
flutter doctor --verbose | head -20

# Step 8: Pre-compile for better performance (optional)
print_warning "Would you like to pre-compile the app for better performance? (y/N)"
read -r compile_response
if [[ "$compile_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    print_status "Pre-compiling Flutter app..."
    flutter build ios --debug --no-codesign || print_warning "Pre-compilation failed, but this is not critical"
fi

print_success "Flutter clean rebuild completed!"
print_status "Your project is now ready for development"
print_status "You can run: flutter run"