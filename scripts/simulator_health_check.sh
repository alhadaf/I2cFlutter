#!/bin/bash

# iOS Simulator Health Check Utility
# This script performs comprehensive health checks on iOS simulators

set -e

echo "🔧 iOS Simulator Health Check"
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

# Function to check simulator service status
check_simulator_services() {
    print_status "Checking iOS Simulator services..."
    
    # Check if Simulator.app is running
    if pgrep -f "Simulator" > /dev/null; then
        print_success "iOS Simulator app is running"
    else
        print_warning "iOS Simulator app is not running"
    fi
    
    # Check for simulator processes
    local sim_processes=$(pgrep -f "com.apple.CoreSimulator" | wc -l)
    if [ "$sim_processes" -gt 0 ]; then
        print_success "CoreSimulator processes are running ($sim_processes processes)"
    else
        print_warning "No CoreSimulator processes found"
    fi
    
    # Check simulator service status
    if launchctl list | grep -q "com.apple.CoreSimulator"; then
        print_success "CoreSimulator service is loaded"
    else
        print_warning "CoreSimulator service is not loaded"
    fi
}

# Function to check available simulators
check_available_simulators() {
    print_status "Checking available simulators..."
    
    local total_simulators=$(xcrun simctl list devices | grep -E "iPhone|iPad" | wc -l)
    local available_simulators=$(xcrun simctl list devices available | grep -E "iPhone|iPad" | wc -l)
    local booted_simulators=$(xcrun simctl list devices | grep "Booted" | wc -l)
    
    print_status "Total simulators: $total_simulators"
    print_status "Available simulators: $available_simulators"
    print_status "Booted simulators: $booted_simulators"
    
    if [ "$available_simulators" -gt 0 ]; then
        print_success "Simulators are available"
        
        print_status "Available iPhone simulators:"
        xcrun simctl list devices available | grep "iPhone" | head -5
    else
        print_error "No available simulators found"
        return 1
    fi
}

# Function to check simulator disk space
check_simulator_disk_space() {
    print_status "Checking simulator disk space..."
    
    local simulator_path="$HOME/Library/Developer/CoreSimulator/Devices"
    if [ -d "$simulator_path" ]; then
        local disk_usage=$(du -sh "$simulator_path" 2>/dev/null | cut -f1)
        print_status "Simulator data usage: $disk_usage"
        
        # Check available disk space
        local available_space=$(df -h "$HOME" | tail -1 | awk '{print $4}')
        print_status "Available disk space: $available_space"
        
        # Warn if simulator data is very large
        local usage_gb=$(du -sg "$simulator_path" 2>/dev/null | cut -f1)
        if [ "$usage_gb" -gt 10 ]; then
            print_warning "Simulator data is using ${usage_gb}GB of disk space"
            print_warning "Consider cleaning up old simulators if needed"
        fi
    else
        print_warning "Simulator data directory not found"
    fi
}

# Function to test simulator responsiveness
test_simulator_responsiveness() {
    local simulator_id=$1
    print_status "Testing simulator responsiveness: $simulator_id"
    
    # Try to get simulator info
    if xcrun simctl list devices | grep -q "$simulator_id"; then
        print_success "Simulator exists in device list"
    else
        print_error "Simulator not found in device list"
        return 1
    fi
    
    # Check if simulator is booted
    local status=$(xcrun simctl list devices | grep "$simulator_id" | grep -o "Booted\|Shutdown\|Creating\|Booting")
    print_status "Simulator status: $status"
    
    if [ "$status" = "Booted" ]; then
        # Test basic simulator commands
        if xcrun simctl spawn "$simulator_id" echo "test" &>/dev/null; then
            print_success "Simulator is responsive to spawn commands"
        else
            print_warning "Simulator may not be fully responsive"
        fi
        
        # Test if we can get device info
        if xcrun simctl getenv "$simulator_id" HOME &>/dev/null; then
            print_success "Simulator environment is accessible"
        else
            print_warning "Simulator environment may not be ready"
        fi
    else
        print_status "Simulator is not booted, cannot test responsiveness"
    fi
}

# Function to check for common issues
check_common_issues() {
    print_status "Checking for common simulator issues..."
    
    # Check for stuck simulator processes
    local stuck_processes=$(ps aux | grep -E "(SimulatorTrampoline|launchd_sim)" | grep -v grep | wc -l)
    if [ "$stuck_processes" -gt 0 ]; then
        print_warning "Found $stuck_processes potentially stuck simulator processes"
        print_status "You may need to kill these processes manually"
    fi
    
    # Check for simulator lock files
    local lock_files=$(find "$HOME/Library/Developer/CoreSimulator" -name "*.lock" 2>/dev/null | wc -l)
    if [ "$lock_files" -gt 0 ]; then
        print_warning "Found $lock_files simulator lock files"
        print_status "These may indicate crashed simulator sessions"
    fi
    
    # Check system resources
    local memory_pressure=$(memory_pressure | grep "System-wide memory free percentage" | awk '{print $5}' | tr -d '%')
    if [ -n "$memory_pressure" ] && [ "$memory_pressure" -lt 20 ]; then
        print_warning "System memory is low (${memory_pressure}% free)"
        print_status "This may affect simulator performance"
    fi
}

# Function to provide diagnostic information
provide_diagnostics() {
    print_status "Diagnostic Information:"
    echo "========================"
    
    # System info
    print_status "macOS Version: $(sw_vers -productVersion)"
    print_status "Xcode Version: $(xcodebuild -version | head -1)"
    
    # Simulator info
    print_status "Simulator Runtime Versions:"
    xcrun simctl list runtimes | grep "iOS" | head -3
    
    # Device types
    print_status "Available Device Types:"
    xcrun simctl list devicetypes | grep "iPhone" | head -3
    
    # Recent simulator logs (if any errors)
    local log_file="$HOME/Library/Logs/CoreSimulator/CoreSimulator.log"
    if [ -f "$log_file" ]; then
        print_status "Recent simulator errors (last 10):"
        tail -100 "$log_file" | grep -i error | tail -10 || print_status "No recent errors found"
    fi
}

# Main health check function
perform_health_check() {
    print_status "Starting comprehensive iOS Simulator health check..."
    echo ""
    
    # Run all checks
    check_simulator_services
    echo ""
    
    check_available_simulators
    echo ""
    
    check_simulator_disk_space
    echo ""
    
    check_common_issues
    echo ""
    
    # Test a specific simulator if one is booted
    local booted_simulator=$(xcrun simctl list devices | grep "Booted" | head -1 | grep -o "([A-F0-9-]*)" | tr -d "()")
    if [ -n "$booted_simulator" ]; then
        test_simulator_responsiveness "$booted_simulator"
        echo ""
    fi
    
    provide_diagnostics
}

# Function to suggest fixes
suggest_fixes() {
    print_status "Suggested fixes for common issues:"
    echo "=================================="
    echo "1. If simulators are not responsive:"
    echo "   - Run: ./scripts/ios_simulator_reset_only.sh"
    echo ""
    echo "2. If disk space is low:"
    echo "   - Run: xcrun simctl delete unavailable"
    echo "   - Clean old simulator data manually"
    echo ""
    echo "3. If services are not running:"
    echo "   - Restart Xcode"
    echo "   - Reboot your Mac"
    echo ""
    echo "4. If build issues persist:"
    echo "   - Run: ./scripts/flutter_clean_rebuild.sh"
    echo ""
    echo "5. For bundle identifier issues:"
    echo "   - Run: ./scripts/validate_bundle_identifier.sh"
}

# Main execution
perform_health_check

echo ""
print_success "Health check completed!"

# Ask if user wants to see suggested fixes
echo ""
print_status "Would you like to see suggested fixes? (y/N)"
read -r fixes_response
if [[ "$fixes_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo ""
    suggest_fixes
fi