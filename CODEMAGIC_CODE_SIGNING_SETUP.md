# Codemagic Code Signing Setup - Step by Step

## ❌ Current Error
```
No valid code signing certificates were found
Failed to build for iOS
```

## ✅ Solution: Configure App Store Connect in Codemagic

You need to set up App Store Connect integration in Codemagic. Here's exactly how:

---

## 📋 Step-by-Step Instructions

### Step 1: Go to Codemagic Dashboard
1. Open https://codemagic.io in your browser
2. Log in to your account
3. You should see your app **I2cFlutter** (or similar name)

### Step 2: Create Environment Variable Group
1. In the left sidebar, click **"Teams"**
2. Click on your team name
3. Click **"Integrations"** tab at the top
4. OR navigate to: **Teams → [Your Team] → Global variables and secrets**

### Step 3: Create a New Variable Group
1. Look for **"Environment variable groups"** section
2. Click **"+ Add group"** or **"Create new group"**
3. Name it: `app_store_credentials`
4. Click **Create** or **Save**

### Step 4: Add Variables to the Group
Now add these **3 variables** to the `app_store_credentials` group:

#### Variable 1: APP_STORE_CONNECT_ISSUER_ID
- **Variable name:** `APP_STORE_CONNECT_ISSUER_ID`
- **Variable value:** `9b6f8519-694d-48a5-8b90-cd6c1debe0d3`
- **Secure:** ❌ No (this is not sensitive)

#### Variable 2: APP_STORE_CONNECT_KEY_IDENTIFIER  
- **Variable name:** `APP_STORE_CONNECT_KEY_IDENTIFIER`
- **Variable value:** `6Y8XL8Q783`
- **Secure:** ❌ No (this is not sensitive)

#### Variable 3: APP_STORE_CONNECT_PRIVATE_KEY
- **Variable name:** `APP_STORE_CONNECT_PRIVATE_KEY`
- **Variable value:** (Paste the entire content of your `.p8` file)
  ```
  -----BEGIN PRIVATE KEY-----
  MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgWU5KD55bAlGtk9M8
  BVwB2bgRkHAuu/2QDuYfr7pIr4CgCgYIKoZIzj0DAQehRANCAATmEBouQZ6UBvRO
  irnwKmA+gGLbZAbC8oETn5NqJUbsQimSxM02eHJslb9M5mTT8IVIn1NWwk0ipsEc
  zDfDDnOZ
  -----END PRIVATE KEY-----
  ```
- **Secure:** ✅ Yes (check this box - this is sensitive!)

### Step 5: Save the Group
- Click **Save** or **Add** to save the variable group
- Make sure all 3 variables are visible in the `app_store_credentials` group

---

## 🔄 Alternative: Add Variables Directly to App

If you can't find the Teams/Groups section, add them directly to your app:

1. Go to **Applications** → **I2cFlutter**
2. Click **Settings** (⚙️)
3. Click **Environment variables** in the left menu
4. Add the same 3 variables listed above
5. Make sure `APP_STORE_CONNECT_PRIVATE_KEY` is marked as **Secure** ✅

---

## 📤 Commit and Push the Updated Config

```bash
cd /home/alex/Pictures/i2c/app
git add codemagic.yaml
git commit -m "Configure code signing with environment variable group"
git push origin master
```

---

## 🚀 Trigger a New Build

After adding the variables:

1. Go to Codemagic → Your App
2. Click **"Start new build"**
3. Select branch: **master**
4. Select workflow: **ios-release**
5. Click **"Start build"**

---

## ✅ What Should Happen

When the build runs with proper credentials, you should see:

```
== Fetch iOS code signing files ==
Found 1 Bundle ID matching...
Creating new Signing Certificate...
Created Signing Certificate [ID]
Creating new Profile...
Created Profile [ID]
✅ Code signing configured successfully

== Install Flutter dependencies ==
Got dependencies!
✅ Dependencies installed

== Build iOS app ==
Building iOS app...
✅ Build succeeded
```

---

## 🎯 Quick Visual Reference

### Where Variables Go:

**Codemagic UI Path:**
```
Codemagic Dashboard
  └── Teams (left sidebar)
      └── [Your Team Name]
          └── Integrations (top tabs)
              └── Environment variable groups
                  └── + Add group
                      └── Name: app_store_credentials
                          ├── APP_STORE_CONNECT_ISSUER_ID = 9b6f8519-694d-48a5-8b90-cd6c1debe0d3
                          ├── APP_STORE_CONNECT_KEY_IDENTIFIER = 6Y8XL8Q783
                          └── APP_STORE_CONNECT_PRIVATE_KEY = [.p8 content] 🔒
```

**OR Direct to App:**
```
Applications
  └── I2cFlutter
      └── Settings ⚙️
          └── Environment variables
              ├── APP_STORE_CONNECT_ISSUER_ID
              ├── APP_STORE_CONNECT_KEY_IDENTIFIER
              └── APP_STORE_CONNECT_PRIVATE_KEY 🔒
```

---

## 📝 Copy-Paste Values

For quick reference, here are the exact values to copy:

**Issuer ID:**
```
9b6f8519-694d-48a5-8b90-cd6c1debe0d3
```

**Key ID:**
```
6Y8XL8Q783
```

**Private Key (your .p8 file content):**
```
-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgWU5KD55bAlGtk9M8
BVwB2bgRkHAuu/2QDuYfr7pIr4CgCgYIKoZIzj0DAQehRANCAATmEBouQZ6UBvRO
irnwKmA+gGLbZAbC8oETn5NqJUbsQimSxM02eHJslb9M5mTT8IVIn1NWwk0ipsEc
zDfDDnOZ
-----END PRIVATE KEY-----
```

---

## ❓ Troubleshooting

### "I can't find Environment variable groups"
- Try adding variables directly to the app under Settings → Environment variables
- Then remove the `groups:` section from `codemagic.yaml`

### "Variables are not being picked up"
- Make sure variable names are EXACTLY as shown (case-sensitive)
- Ensure you clicked Save/Add after entering each variable
- Try triggering a completely new build (not restarting an old one)

### "Still getting code signing errors"
- Verify the `.p8` content is complete (including BEGIN/END lines)
- Check that PRIVATE_KEY is marked as Secure
- Make sure the group name `app_store_credentials` matches exactly in both places

---

## 🎉 Summary

**What you need to do:**
1. ✅ Go to Codemagic
2. ✅ Create `app_store_credentials` environment variable group (or add to app directly)
3. ✅ Add the 3 variables (Issuer ID, Key ID, Private Key)
4. ✅ Commit and push the updated `codemagic.yaml`
5. ✅ Trigger a new build

**After this, your code signing will work and the build will succeed!** 🚀

