#!/bin/bash

# Update Bundle Identifier Script
# This script updates the bundle identifier from com.example.eventCheckinMobile to com.eventcheckin.mobile

set -e

echo "🔧 Updating Bundle Identifier"
echo "============================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

OLD_BUNDLE_ID="com.example.eventCheckinMobile"
NEW_BUNDLE_ID="com.eventcheckin.mobile"
OLD_TEST_BUNDLE_ID="com.example.eventCheckinMobile.RunnerTests"
NEW_TEST_BUNDLE_ID="com.eventcheckin.mobile.RunnerTests"

print_status "Updating bundle identifier from $OLD_BUNDLE_ID to $NEW_BUNDLE_ID"

# Update Xcode project file
if [ -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
    print_status "Updating Xcode project configuration..."
    
    # Create backup
    cp "ios/Runner.xcodeproj/project.pbxproj" "ios/Runner.xcodeproj/project.pbxproj.backup"
    
    # Update main app bundle identifier
    sed -i.tmp "s/$OLD_BUNDLE_ID/$NEW_BUNDLE_ID/g" "ios/Runner.xcodeproj/project.pbxproj"
    
    # Update test bundle identifier
    sed -i.tmp "s/$OLD_TEST_BUNDLE_ID/$NEW_TEST_BUNDLE_ID/g" "ios/Runner.xcodeproj/project.pbxproj"
    
    # Remove temporary file
    rm "ios/Runner.xcodeproj/project.pbxproj.tmp"
    
    print_success "Xcode project configuration updated"
else
    echo "Warning: Xcode project file not found"
fi

# Verify the changes
print_status "Verifying changes..."
if grep -q "$NEW_BUNDLE_ID" "ios/Runner.xcodeproj/project.pbxproj"; then
    print_success "Bundle identifier successfully updated in Xcode project"
else
    echo "Warning: Bundle identifier may not have been updated correctly"
fi

# Check Info.plist (should already use variable reference)
if [ -f "ios/Runner/Info.plist" ]; then
    if grep -q "PRODUCT_BUNDLE_IDENTIFIER" "ios/Runner/Info.plist"; then
        print_success "Info.plist correctly uses variable reference"
    else
        print_status "Info.plist uses hardcoded bundle identifier, updating..."
        # This is less common, but handle it if needed
        sed -i.tmp "s/$OLD_BUNDLE_ID/$NEW_BUNDLE_ID/g" "ios/Runner/Info.plist"
        rm "ios/Runner/Info.plist.tmp"
    fi
fi

print_success "Bundle identifier update completed!"
print_status "New bundle identifier: $NEW_BUNDLE_ID"
print_status "Backup created at: ios/Runner.xcodeproj/project.pbxproj.backup"