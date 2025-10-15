#!/bin/bash

# Bundle Identifier Validation Script
# This script validates and provides suggestions for bundle identifiers

set -e

echo "🔧 Bundle Identifier Validation Script"
echo "======================================"

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

# Function to validate bundle identifier format
validate_bundle_id_format() {
    local bundle_id=$1
    
    # Check if bundle ID matches the expected pattern
    if [[ $bundle_id =~ ^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to check for problematic patterns
check_problematic_patterns() {
    local bundle_id=$1
    local issues=()
    
    # Check for com.example prefix
    if [[ $bundle_id == com.example* ]]; then
        issues+=("Uses generic 'com.example' prefix")
    fi
    
    # Check for test suffixes in main bundle
    if [[ $bundle_id == *Test* ]] || [[ $bundle_id == *Tests* ]]; then
        issues+=("Contains test-related naming in main bundle")
    fi
    
    # Check for invalid characters
    if [[ $bundle_id =~ [^a-zA-Z0-9.] ]]; then
        issues+=("Contains invalid characters (only letters, numbers, and dots allowed)")
    fi
    
    # Check for consecutive dots
    if [[ $bundle_id =~ \.\. ]]; then
        issues+=("Contains consecutive dots")
    fi
    
    # Check for starting or ending with dot
    if [[ $bundle_id =~ ^\. ]] || [[ $bundle_id =~ \.$ ]]; then
        issues+=("Starts or ends with a dot")
    fi
    
    # Check minimum components (should have at least 2 components)
    local component_count=$(echo "$bundle_id" | tr -cd '.' | wc -c)
    if [ $component_count -lt 1 ]; then
        issues+=("Should have at least 2 components (e.g., com.company)")
    fi
    
    # Return issues
    printf '%s\n' "${issues[@]}"
}

# Function to suggest bundle identifier
suggest_bundle_id() {
    local current_bundle_id=$1
    local app_name=$2
    
    print_status "Generating bundle identifier suggestions..."
    
    # Extract app name from current bundle ID or use provided name
    if [ -z "$app_name" ]; then
        app_name=$(echo "$current_bundle_id" | sed 's/.*\.//')
    fi
    
    # Clean app name (remove spaces, special chars, make lowercase)
    clean_app_name=$(echo "$app_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-zA-Z0-9]//g')
    
    echo "Suggested bundle identifiers:"
    echo "1. com.yourcompany.$clean_app_name"
    echo "2. com.$(whoami).$clean_app_name"
    echo "3. org.yourorg.$clean_app_name"
    echo "4. dev.yourname.$clean_app_name"
    echo "5. app.$clean_app_name.mobile"
}

# Function to check for conflicts with existing apps
check_bundle_conflicts() {
    local bundle_id=$1
    
    print_status "Checking for potential conflicts..."
    
    # Check if bundle ID is used in simulator
    if command -v xcrun &> /dev/null; then
        local conflicts=$(xcrun simctl list apps | grep -i "$bundle_id" || true)
        if [ -n "$conflicts" ]; then
            print_warning "Found potential conflicts in simulator:"
            echo "$conflicts"
        else
            print_success "No conflicts found in simulator"
        fi
    fi
}

# Main validation function
validate_project_bundle_id() {
    print_status "Validating current project bundle identifier..."
    
    # Find current bundle ID from Xcode project
    if [ -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
        local current_bundle_id=$(grep "PRODUCT_BUNDLE_IDENTIFIER" "ios/Runner.xcodeproj/project.pbxproj" | head -1 | sed 's/.*= \(.*\);/\1/' | tr -d ' ')
        
        print_status "Current bundle identifier: $current_bundle_id"
        
        # Validate format
        if validate_bundle_id_format "$current_bundle_id"; then
            print_success "Bundle identifier format is valid"
        else
            print_error "Bundle identifier format is invalid"
        fi
        
        # Check for issues
        local issues=($(check_problematic_patterns "$current_bundle_id"))
        if [ ${#issues[@]} -gt 0 ]; then
            print_warning "Found issues with current bundle identifier:"
            for issue in "${issues[@]}"; do
                echo "  - $issue"
            done
            
            # Suggest alternatives
            suggest_bundle_id "$current_bundle_id"
        else
            print_success "No issues found with current bundle identifier"
        fi
        
        # Check for conflicts
        check_bundle_conflicts "$current_bundle_id"
        
    else
        print_error "Xcode project file not found"
        return 1
    fi
}

# Function to interactively update bundle identifier
interactive_update() {
    print_status "Interactive bundle identifier update"
    echo "Current bundle identifier needs updating."
    echo ""
    
    suggest_bundle_id "$(grep "PRODUCT_BUNDLE_IDENTIFIER" "ios/Runner.xcodeproj/project.pbxproj" | head -1 | sed 's/.*= \(.*\);/\1/' | tr -d ' ')"
    
    echo ""
    print_status "Enter new bundle identifier (or press Enter to skip):"
    read -r new_bundle_id
    
    if [ -n "$new_bundle_id" ]; then
        if validate_bundle_id_format "$new_bundle_id"; then
            local issues=($(check_problematic_patterns "$new_bundle_id"))
            if [ ${#issues[@]} -eq 0 ]; then
                print_success "New bundle identifier looks good: $new_bundle_id"
                print_status "Would you like to update the project with this bundle identifier? (y/N)"
                read -r update_response
                if [[ "$update_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
                    # Call the update script
                    if [ -f "scripts/update_bundle_identifier.sh" ]; then
                        # Modify the update script to use the new bundle ID
                        sed -i.tmp "s/NEW_BUNDLE_ID=.*/NEW_BUNDLE_ID=\"$new_bundle_id\"/" "scripts/update_bundle_identifier.sh"
                        rm "scripts/update_bundle_identifier.sh.tmp"
                        ./scripts/update_bundle_identifier.sh
                    else
                        print_error "Update script not found"
                    fi
                fi
            else
                print_error "New bundle identifier has issues:"
                for issue in "${issues[@]}"; do
                    echo "  - $issue"
                done
            fi
        else
            print_error "Invalid bundle identifier format"
        fi
    fi
}

# Main execution
print_status "Starting bundle identifier validation..."

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    print_error "Not in a Flutter project directory"
    exit 1
fi

# Validate current bundle ID
validate_project_bundle_id

# Ask if user wants to update
echo ""
print_status "Would you like to interactively update the bundle identifier? (y/N)"
read -r interactive_response
if [[ "$interactive_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    interactive_update
fi

print_success "Bundle identifier validation completed!"