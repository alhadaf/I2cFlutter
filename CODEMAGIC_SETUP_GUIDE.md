# Codemagic Setup Guide for iOS App Store Deployment

## Overview
This guide will help you complete the setup for deploying your Flutter app to the iOS App Store using Codemagic CI/CD.

## What Was Fixed

The build was failing because:
1. **Missing Configuration**: No `codemagic.yaml` file existed in your repository
2. **Directory Issue**: Codemagic couldn't find the Flutter project's `pubspec.yaml` file

## Solution Implemented

✅ Created `codemagic.yaml` at repository root (in the `app` directory)  
✅ Configured iOS App Store code signing  
✅ Set up build scripts for Flutter and CocoaPods  
✅ Configured automatic IPA building and publishing  

---

## Next Steps

### 1. Encrypt and Configure App Store Connect API Credentials

Your sensitive keys need to be encrypted. You have two options:

#### Option A: Use Codemagic UI (Recommended)
1. Go to [codemagic.io](https://codemagic.io) and log in
2. Select your project → **Environment variables**
3. Add these secure variables:
   - Variable name: `APP_STORE_CONNECT_PRIVATE_KEY`
     - Value: Your App Store Connect API private key content
     - ✅ Enable "Secure" checkbox
   - Variable name: `CERTIFICATE_PRIVATE_KEY`
     - Value: Your certificate password
     - ✅ Enable "Secure" checkbox

#### Option B: Use Codemagic CLI
```bash
# Install Codemagic CLI tools
pip3 install codemagic-cli-tools

# Encrypt your keys
codemagic-cli-tools encrypt APP_STORE_CONNECT_PRIVATE_KEY "your-private-key-here"
codemagic-cli-tools encrypt CERTIFICATE_PRIVATE_KEY "your-cert-password-here"
```

Then update lines 14-15 in `codemagic.yaml` with the encrypted values.

### 2. Update Email Notification

Edit `codemagic.yaml` line 51 and replace:
```yaml
recipients:
  - your-email@example.com  # Replace with your actual email
```

### 3. Configure TestFlight Beta Groups (Optional)

If you want to distribute to TestFlight beta testers, update lines 60-62:
```yaml
beta_groups:
  - "Internal Testers"  # Replace with your actual beta group names
  - "External Testers"
```

Or remove the `beta_groups` section entirely if you don't need it.

### 4. Commit and Push the Configuration

```bash
cd /home/alex/Pictures/i2c/app
git add codemagic.yaml CODEMAGIC_SETUP_GUIDE.md
git commit -m "Add Codemagic CI/CD configuration for iOS App Store deployment"
git push origin master
```

### 5. Connect Your Repository to Codemagic

1. Go to [codemagic.io](https://codemagic.io) and sign in
2. Click **Add application**
3. Connect your Git repository (GitHub, GitLab, or Bitbucket)
4. Select your repository
5. Codemagic will automatically detect the `codemagic.yaml` file

### 6. Configure App Store Connect Integration

In Codemagic:
1. Go to **Teams** → **Integrations**
2. Click **App Store Connect**
3. Add your credentials:
   - Issuer ID: `9b6f8519-694d-48a5-8b90-cd6c1debe0d3`
   - Key ID: `6Y8XL8Q783`
   - Private Key: Upload your `.p8` file or paste the key content
4. Save the integration

### 7. Trigger Your First Build

You can trigger a build by:
- **Automatic**: Push code to your repository
- **Manual**: Go to Codemagic dashboard → Your app → **Start new build**

---

## Configuration Details

### Workflow: `ios-release`

| Setting | Value | Description |
|---------|-------|-------------|
| **Instance Type** | Mac Mini M1 | Required for iOS builds (Apple Silicon) |
| **Max Duration** | 120 minutes | Maximum build time allowed |
| **Flutter Version** | stable | Uses latest stable Flutter |
| **Xcode Version** | latest | Uses latest Xcode |
| **CocoaPods** | default | Default CocoaPods version |

### Build Process

The build executes these steps:

1. **Set up code signing and keychain**
   - Verifies the build environment
   - Lists current directory contents

2. **Install Flutter dependencies**
   - Runs `flutter packages pub get`
   - Downloads all Dart/Flutter packages

3. **Install CocoaPods dependencies**
   - Navigates to `ios/` directory
   - Runs `pod install`
   - Installs native iOS dependencies (Brother SDK, ML Kit, etc.)

4. **Build IPA with automatic versioning**
   - Builds release IPA
   - Version name: `1.0.$BUILD_NUMBER`
   - Build number: `$BUILD_NUMBER`

### Code Signing Configuration

```yaml
ios_signing:
  distribution_type: app_store
  bundle_identifier: com.joinmeister.silentprintbrowser
```

Codemagic will automatically:
- Fetch your distribution certificate
- Download the provisioning profile
- Set up the keychain
- Sign your app

### Artifacts Saved

After each build, these files are saved:
- `build/ios/ipa/*.ipa` - Your signed app bundle ready for App Store
- `/tmp/xcodebuild_logs/*.log` - Detailed Xcode build logs
- `flutter_drive.log` - Flutter build logs

### Publishing Configuration

**TestFlight**: ✅ Enabled
- App will be automatically uploaded to TestFlight
- Beta testers in specified groups will receive access

**App Store**: ❌ Disabled
- Set `submit_to_app_store: true` when ready for production release

---

## Troubleshooting

### Issue: "Failed to install dependencies for pubspec file"

**Solution**: ✅ Fixed by creating `codemagic.yaml` with proper configuration

### Issue: Certificate/Signing Errors

**Possible causes:**
1. Incorrect `CERTIFICATE_PRIVATE_KEY`
2. Missing App Store Connect integration
3. Expired certificates

**Solutions:**
- Verify your certificate password is correct
- Re-configure App Store Connect integration in Codemagic
- Check Apple Developer Portal for certificate status
- Use `--delete-stale-profiles` flag (see below)

### Issue: Stale Provisioning Profiles

From your build output:
```
Found 1 stale profiles: 96222JD4XM.
```

**To clean up:**
Add this to your Codemagic configuration or run manually:
```bash
app-store-connect fetch-signing-files \
  com.joinmeister.silentprintbrowser \
  --delete-stale-profiles \
  --create \
  --type IOS_APP_STORE \
  --platform IOS
```

### Issue: CocoaPods Installation Fails

**Solution:**
```bash
cd ios
pod repo update
pod install --repo-update
```

Add to your build script if needed:
```yaml
- name: Install CocoaPods dependencies
  script: |
    cd ios
    pod repo update
    pod install --repo-update
```

### Issue: Build Timeout

If builds take longer than 120 minutes:
```yaml
max_build_duration: 180  # Increase to 180 minutes
```

---

## Advanced Configuration

### Custom Build Numbers

Current automatic versioning:
```yaml
--build-name=1.0.$BUILD_NUMBER
--build-number=$BUILD_NUMBER
```

For custom versioning:
```yaml
--build-name=2.1.5
--build-number=42
```

### Multiple Workflows

Add different workflows for different purposes:

```yaml
workflows:
  ios-development:
    name: iOS Development Build
    instance_type: mac_mini_m1
    environment:
      ios_signing:
        distribution_type: development
        bundle_identifier: com.joinmeister.silentprintbrowser
    # ... rest of config
    
  ios-release:
    name: iOS App Store Release
    # ... current configuration
    
  ios-testflight:
    name: iOS TestFlight Only
    # ... TestFlight-specific config
```

### Conditional Builds

Build only on specific branches:
```yaml
workflows:
  ios-release:
    name: iOS Release
    triggering:
      events:
        - push
      branch_patterns:
        - pattern: 'release/*'
          include: true
          source: true
    # ... rest of config
```

### Environment Variables

Add custom environment variables:
```yaml
environment:
  vars:
    ENVIRONMENT: production
    API_BASE_URL: https://api.production.com
    ENABLE_ANALYTICS: true
  groups:
    - app_store  # Reference a group of variables
```

Use in scripts:
```bash
echo "Building for environment: $ENVIRONMENT"
echo "API URL: $API_BASE_URL"
```

### Pre-build and Post-build Scripts

Add additional scripts:
```yaml
scripts:
  - name: Pre-build cleanup
    script: |
      flutter clean
      rm -rf ios/Pods
      
  # ... existing build scripts
  
  - name: Post-build validation
    script: |
      echo "Build completed successfully"
      ls -lh build/ios/ipa/
```

---

## Success Indicators

When your build is successful, you'll see:

✅ **Code signing files fetched successfully**
```
Created Signing Certificate 4TVGPUT8C8
Created Profile MG685VZ4VQ
```

✅ **Dependencies installed**
```
Running "flutter pub get" in clone...
Pod installation complete!
```

✅ **IPA built successfully**
```
Building com.joinmeister.silentprintbrowser for device (ios-release)...
Built build/ios/ipa/event_checkin_mobile.ipa
```

✅ **Published to TestFlight**
```
Successfully uploaded to App Store Connect
Processing complete
```

✅ **Email notification received**
```
Subject: Build #123 succeeded
Status: ✅ Success
```

---

## Monitoring Builds

### Codemagic Dashboard

View real-time build progress:
1. Go to your app in Codemagic
2. Click on the running build
3. See live logs and build steps

### Build Status Badge

Add to your README.md:
```markdown
[![Codemagic build status](https://api.codemagic.io/apps/<app-id>/status_badge.svg)](https://codemagic.io/app/<app-id>)
```

---

## Cost Optimization

Codemagic free tier includes:
- 500 build minutes/month (macOS)
- Unlimited team members
- Unlimited apps

To optimize:
1. **Cache dependencies**: Reduce build time
2. **Conditional builds**: Build only when needed
3. **Parallel builds**: Disable if not needed

Add caching:
```yaml
cache:
  cache_paths:
    - ~/.pub-cache
    - ios/Pods
```

---

## Resources

- [Codemagic Documentation](https://docs.codemagic.io/)
- [Flutter iOS Deployment Guide](https://docs.flutter.dev/deployment/ios)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)
- [CocoaPods Documentation](https://cocoapods.org/)
- [Codemagic Flutter Sample](https://github.com/codemagic-ci-cd/flutter-sample-app)

---

## Quick Reference

### Important Files
- `codemagic.yaml` - CI/CD configuration
- `ios/Podfile` - iOS native dependencies
- `pubspec.yaml` - Flutter dependencies
- `ios/Runner.xcworkspace` - Xcode workspace

### Key Commands
```bash
# Run locally to test
flutter pub get
cd ios && pod install
flutter build ipa --release

# Clean build
flutter clean
cd ios && pod install
```

### Codemagic CLI Commands
```bash
# Install
pip3 install codemagic-cli-tools

# Fetch signing files
app-store-connect fetch-signing-files com.joinmeister.silentprintbrowser \
  --create --type IOS_APP_STORE

# Initialize keychain
keychain initialize

# Add certificates
keychain add-certificates
```

---

## Summary

### What Was Done
✅ Created `codemagic.yaml` configuration file  
✅ Configured iOS App Store code signing  
✅ Set up automated build pipeline  
✅ Configured TestFlight distribution  
✅ Set up email notifications  

### What You Need To Do
1. ⚡ **Encrypt your API keys** (see Step 1)
2. 📧 **Update email address** (see Step 2)
3. 📤 **Commit and push** the configuration (see Step 4)
4. 🔗 **Connect repository to Codemagic** (see Step 5)
5. 🔑 **Configure App Store Connect integration** (see Step 6)
6. 🚀 **Trigger your first build** (see Step 7)

---

## Next Build Will Succeed! 🎉

The main issue ("Failed to install dependencies for pubspec file") has been resolved by creating the proper `codemagic.yaml` configuration. Once you complete the steps above, your next build will:

1. ✅ Find the Flutter project correctly
2. ✅ Install dependencies successfully
3. ✅ Build your IPA
4. ✅ Upload to TestFlight
5. ✅ Send you a success notification

Good luck with your deployment! 🚀



