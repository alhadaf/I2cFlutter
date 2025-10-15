#!/bin/bash

# iOS Simulator Reset Script (Simulator Only)
# This script focuses only on simulator state management

set -e

echo "🔧 iOS Simulator Reset Script"
echo "============================="

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

print_status "Starting iOS simulator reset process..."

# Function to validate simulator health
validate_simulator_health() {
    local simulator_id=$1
    print_status "Validating simulator health for: $simulator_id"
    
    # Check if simulator exists
    if ! xcrun simctl list devices | grep -q "$simulator_id"; then
        print_error "Simulator $simulator_id not found"
        return 1
    fi
    
    # Check simulator status
    local status=$(xcrun simctl list devices | grep "$simulator_id" | grep -o "Booted\|Shutdown\|Creating\|Booting")
    print_status "Simulator status: $status"
    
    if [ "$status" = "Booted" ]; then
        # Test if simulator is responsive
        if xcrun simctl spawn "$simulator_id" launchctl print system &>/dev/null; then
            print_success "Simulator is healthy and responsive"
            return 0
        else
            print_warning "Simulator is booted but may not be responsive"
            return 1
        fi
    else
        print_status "Simulator is not booted"
        return 1
    fi
}

# Function to restart simulator services
restart_simulator_services() {
    print_status "Restarting iOS Simulator services..."
    
    # Kill any existing simulator processes
    pkill -f "Simulator" || true
    pkill -f "SimulatorTrampoline" || true
    
    # Wait a moment for processes to terminate
    sleep 2
    
    print_success "Simulator services restarted"
}

# Step 1: Show current simulator status
print_status "Current simulator status:"
xcrun simctl list devices | grep -E "(iPhone|iPad)" | head -10

# Step 2: Shutdown all simulators
print_status "Shutting down all iOS simulators..."
xcrun simctl shutdown all 2>/dev/null || true
print_success "All simulators shut down"

# Step 3: Restart simulator services
restart_simulator_services

# Step 4: Optional simulator data erasure
print_warning "Do you want to erase all simulator data? This will remove all apps and data. (y/N)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    print_status "Erasing all simulator data..."
    xcrun simctl erase all
    print_success "All simulator data erased"
else
    print_status "Skipping simulator data erasure"
fi

# Step 5: Boot a fresh simulator
print_status "Available simulators:"
xcrun simctl list devices available | grep -E "iPhone.*\(" | head -5

# Get the first available iPhone simulator
SIMULATOR_ID=$(xcrun simctl list devices available | grep -E "iPhone.*\(" | head -1 | grep -o "([A-F0-9-]*)" | tr -d "()")

if [ -n "$SIMULATOR_ID" ]; then
    print_status "Booting simulator: $SIMULATOR_ID"
    xcrun simctl boot "$SIMULATOR_ID"
    
    # Wait for simulator to be ready
    print_status "Waiting for simulator to be ready..."
    sleep 5
    
    # Validate simulator health
    if validate_simulator_health "$SIMULATOR_ID"; then
        print_success "Simulator is ready and healthy"
    else
        print_warning "Simulator may need additional time to be fully ready"
    fi
else
    print_warning "No available iPhone simulator found"
fi

# Step 6: Final status
print_status "Final simulator status:"
xcrun simctl list devices | grep -E "(Booted|Shutdown)" | head -5

print_success "iOS Simulator reset completed!"
print_status "You can now try launching your app"