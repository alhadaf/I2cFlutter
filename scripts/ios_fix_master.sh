#!/bin/bash

# iOS Fix Master Script
# This script provides a menu-driven interface to all iOS troubleshooting tools

set -e

echo "🔧 iOS Simulator Fix Master Script"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${CYAN}$1${NC}"
    echo "$(printf '=%.0s' {1..50})"
}

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

# Function to show main menu
show_menu() {
    clear
    print_header "iOS Simulator Fix Master Script"
    echo ""
    echo "Choose an option:"
    echo ""
    echo "🚀 Quick Fixes:"
    echo "  1) Complete Reset & Recovery (Recommended for SBMainWorkspace error)"
    echo "  2) Bundle Identifier Fix"
    echo "  3) Simulator Reset Only"
    echo "  4) Flutter Clean Rebuild"
    echo ""
    echo "🔍 Diagnostics:"
    echo "  5) Simulator Health Check"
    echo "  6) App Launch Validation"
    echo "  7) Bundle Identifier Validation"
    echo ""
    echo "📚 Documentation:"
    echo "  8) View Troubleshooting Guide"
    echo "  9) View Development Setup Guide"
    echo ""
    echo "  0) Exit"
    echo ""
    echo -n "Enter your choice [0-9]: "
}

# Function to run complete reset
run_complete_reset() {
    print_header "Complete Reset & Recovery"
    print_status "This will reset simulators, clean Flutter project, and fix bundle identifier"
    print_warning "This is the recommended solution for SBMainWorkspace errors"
    echo ""
    print_status "Press Enter to continue or Ctrl+C to cancel..."
    read -r
    
    if [ -f "scripts/ios_simulator_reset.sh" ]; then
        ./scripts/ios_simulator_reset.sh
    else
        print_error "Reset script not found"
    fi
}

# Function to fix bundle identifier
fix_bundle_identifier() {
    print_header "Bundle Identifier Fix"
    print_status "This will validate and optionally update your bundle identifier"
    echo ""
    
    if [ -f "scripts/validate_bundle_identifier.sh" ]; then
        ./scripts/validate_bundle_identifier.sh
    else
        print_error "Bundle identifier validation script not found"
    fi
}

# Function to reset simulator only
reset_simulator_only() {
    print_header "Simulator Reset Only"
    print_status "This will reset iOS simulators without affecting Flutter project"
    echo ""
    
    if [ -f "scripts/ios_simulator_reset_only.sh" ]; then
        ./scripts/ios_simulator_reset_only.sh
    else
        print_error "Simulator reset script not found"
    fi
}

# Function to clean rebuild Flutter
clean_rebuild_flutter() {
    print_header "Flutter Clean Rebuild"
    print_status "This will clean and rebuild your Flutter project"
    echo ""
    
    if [ -f "scripts/flutter_clean_rebuild.sh" ]; then
        ./scripts/flutter_clean_rebuild.sh
    else
        print_error "Flutter clean rebuild script not found"
    fi
}

# Function to run health check
run_health_check() {
    print_header "Simulator Health Check"
    print_status "This will diagnose your iOS simulator setup"
    echo ""
    
    if [ -f "scripts/simulator_health_check.sh" ]; then
        ./scripts/simulator_health_check.sh
    else
        print_error "Health check script not found"
    fi
}

# Function to validate app launch
validate_app_launch() {
    print_header "App Launch Validation"
    print_status "This will test if your app can be built and launched"
    echo ""
    print_warning "This may take several minutes as it builds the app"
    print_status "Press Enter to continue or Ctrl+C to cancel..."
    read -r
    
    if [ -f "scripts/app_launch_validation.sh" ]; then
        ./scripts/app_launch_validation.sh
    else
        print_error "App launch validation script not found"
    fi
}

# Function to validate bundle identifier
validate_bundle_id() {
    print_header "Bundle Identifier Validation"
    print_status "This will check your bundle identifier for issues"
    echo ""
    
    if [ -f "scripts/validate_bundle_identifier.sh" ]; then
        ./scripts/validate_bundle_identifier.sh
    else
        print_error "Bundle identifier validation script not found"
    fi
}

# Function to view troubleshooting guide
view_troubleshooting_guide() {
    print_header "Troubleshooting Guide"
    
    if [ -f "docs/ios_troubleshooting_guide.md" ]; then
        if command -v less &> /dev/null; then
            less docs/ios_troubleshooting_guide.md
        else
            cat docs/ios_troubleshooting_guide.md
        fi
    else
        print_error "Troubleshooting guide not found"
    fi
}

# Function to view setup guide
view_setup_guide() {
    print_header "Development Setup Guide"
    
    if [ -f "docs/ios_development_setup_guide.md" ]; then
        if command -v less &> /dev/null; then
            less docs/ios_development_setup_guide.md
        else
            cat docs/ios_development_setup_guide.md
        fi
    else
        print_error "Setup guide not found"
    fi
}

# Function to pause and wait for user input
pause() {
    echo ""
    print_status "Press Enter to continue..."
    read -r
}

# Main loop
while true; do
    show_menu
    read -r choice
    
    case $choice in
        1)
            run_complete_reset
            pause
            ;;
        2)
            fix_bundle_identifier
            pause
            ;;
        3)
            reset_simulator_only
            pause
            ;;
        4)
            clean_rebuild_flutter
            pause
            ;;
        5)
            run_health_check
            pause
            ;;
        6)
            validate_app_launch
            pause
            ;;
        7)
            validate_bundle_id
            pause
            ;;
        8)
            view_troubleshooting_guide
            pause
            ;;
        9)
            view_setup_guide
            pause
            ;;
        0)
            print_success "Goodbye!"
            exit 0
            ;;
        *)
            print_error "Invalid option. Please try again."
            sleep 2
            ;;
    esac
done