# 📦 Soldout App - Build Packages

## ✅ What's Ready

I've created TWO packages ready to be converted to Android APKs:

### 1. TEST Environment
**File**: `soldout-test-phonegap.zip` (2.2 MB)  
**API**: `https://z.test.soldout.com.ua`  
**Use**: For testing with test backend

### 2. PRODUCTION Environment  
**File**: `soldout-prod-phonegap.zip` (2.2 MB)  
**API**: `https://z.soldout.com.ua`  
**Use**: For production deployment

---

## 🚀 Converting to APK (3 Easy Methods)

### Method 1: PhoneGap Build (Easiest - 10 minutes) ⭐ RECOMMENDED

1. **Go to**: https://build.phonegap.com/
   - Sign up/login (free account)

2. **Create New App**:
   - Click "+ New App"
   - Select "Upload a .zip file"
   - Upload `soldout-test-phonegap.zip`
   - Wait 5-10 minutes

3. **Download APK**:
   - Click "Android" when build completes
   - Install on your device!

4. **Repeat for PROD**:
   - Upload `soldout-prod-phonegap.zip`
   - Download second APK

**Time**: ~15-20 minutes total for both APKs

---

### Method 2: Ionic Appflow (Free Tier)

1. **Go to**: https://ionic.io/appflow
2. **Sign up** (free tier available)
3. **Create app** and upload zip
4. **Build APK** in cloud
5. **Download** when ready

---

### Method 3: Local Build (Requires Android Studio)

If you have Android Studio installed:

```bash
# Extract the zip
cd "/Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток орга/org-mobile-app"

# Install dependencies (if not already)
npm install --ignore-scripts

# Set Android environment
export ANDROID_HOME=$HOME/Library/Android/sdk

# Build TEST APK
npx quasar build -m cordova -T android --debug

# APK location:
# src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

---

## 📱 Installing APKs on Android

Once you have the APK files:

1. **Enable Unknown Sources**:
   - Settings → Security → Unknown Sources (enable)

2. **Transfer APK** to phone:
   - Email it to yourself
   - Use USB cable
   - Upload to Google Drive

3. **Install**:
   - Tap the APK file
   - Click "Install"
   - Open app!

---

## 🔄 Quick Rebuild

If you need to rebuild with changes:

```bash
cd "/Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток орга/org-mobile-app"

# For TEST
zip -r builds/soldout-test-phonegap.zip . \
  -x "node_modules/*" -x ".git/*" -x "dist/*" -x "builds/*" -q

# For PROD (edit endpoints.js first)
zip -r builds/soldout-prod-phonegap.zip . \
  -x "node_modules/*" -x ".git/*" -x "dist/*" -x "builds/*" -q
```

---

## 📊 Package Contents

Each zip contains:
- ✅ Source code
- ✅ Configuration files
- ✅ Cordova setup (`src-cordova/config.xml`)
- ✅ Icons and splash screens
- ✅ Package dependencies list
- ✅ Build scripts

What's **NOT** included (by design):
- ❌ `node_modules/` (too large, rebuilt by build service)
- ❌ `.git/` (not needed for builds)
- ❌ `dist/` (generated during build)

---

## 🎯 Next Steps

### Quick Path (15 minutes):
1. Go to https://build.phonegap.com/
2. Upload `soldout-test-phonegap.zip`
3. Wait for build
4. Download APK
5. Repeat for `soldout-prod-phonegap.zip`

### Full Control Path (1 hour):
1. Install Android Studio
2. Run `./build-apk.sh` from project root
3. Get APKs directly in `builds/` folder

---

## 💾 File Sizes

- TEST package: **2.2 MB**
- PROD package: **2.2 MB**
- Final APK: **~15-20 MB** (after build)

---

## ✅ App Details

**App Name**: Soldout Event  
**Package ID**: com.soldoutstatistics.app  
**Version**: 0.0.3  
**Min Android**: 5.0 (API 21)  
**Target Android**: Latest

---

## 🔐 For Play Store

These packages create DEBUG APKs suitable for testing.

For Google Play Store, you need:
1. **Signed Release APK**
2. **Keystore file**  
3. **App signing setup**

I can help with that once you have Android Studio installed!

---

## 📞 Support

Need help with:
- PhoneGap Build setup?
- Installing APK on device?
- Signing for Play Store?
- Android Studio installation?

Just ask! 🙂

---

**Ready to go!** Both packages are in the `builds/` folder waiting for you! 🎉

