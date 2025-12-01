# 📱 APK Build Summary - Soldout App

## ✅ What's Been Prepared

I've set up everything you need to build Android APKs for both TEST and PRODUCTION environments:

### Files Created:

1. **`build-apk.sh`** - Automated build script for both environments
2. **`BUILD_INSTRUCTIONS.md`** - Comprehensive build guide  
3. **`Dockerfile.android`** - Docker image for Android builds
4. **`build-apks.sh`** - Alternative Docker-based build script

---

## 🔍 Current Status

**Java**: ✅ Installed (`/usr/bin/java`)  
**Android SDK**: ❌ Not found at default location  
**Android Studio**: ❌ Not detected

---

## 🚨 Requirements to Build APKs

To build Android APKs, you need:

### 1. Android Studio
Download from: https://developer.android.com/studio

### 2. Android SDK
- Installed automatically with Android Studio
- Or download command-line tools separately

### 3. Java JDK 8
- ✅ You have Java, but may need JDK 8 specifically
- Check: `java -version` (should show 1.8.x)

### 4. Environment Variables
```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

---

## 🚀 How to Build APKs

### Option 1: Quick Build (Once Android Studio is installed)

```bash
cd "/Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток орга/org-mobile-app"

# Run the build script
./build-apk.sh
```

This will:
- ✅ Build TEST environment APK → `builds/soldout-test.apk`
- ✅ Build PRODUCTION environment APK → `builds/soldout-prod.apk`
- ✅ Restore TEST configuration
- ⏱️ Takes ~15-20 minutes total

### Option 2: Manual Build

```bash
# Set up environment
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Build TEST APK
cd "/Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток орга/org-mobile-app"
npx quasar build -m cordova -T android --debug

# APK location: src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk

# For PRODUCTION: Edit src/api/endpoints.js first, then repeat
```

---

## 📦 Alternative: Use Online Build Service

If you don't want to install Android Studio locally:

### 1. **Adobe PhoneGap Build** (Free tier available)
- Upload your project
- Cloud builds APK for you
- Download when ready

### 2. **Ionic Appflow**
- Similar service for Cordova apps
- Handles Android/iOS builds

### 3. **GitHub Actions** (Free for public repos)
- Automated builds on push
- I can set this up if you have a GitHub repo

---

## 🎯 Quick Start Guide

### Step 1: Install Android Studio

1. Download from https://developer.android.com/studio
2. Run installer
3. Open Android Studio
4. Go to Tools → SDK Manager
5. Install:
   - Android SDK Platform 28 (minimum)
   - Android SDK Build-Tools
   - Android SDK Platform-Tools

### Step 2: Set Environment Variables

Add to your `~/.zshrc` or `~/.bash_profile`:

```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools/$(ls $ANDROID_HOME/build-tools | tail -1)
```

Then reload:
```bash
source ~/.zshrc  # or source ~/.bash_profile
```

### Step 3: Install Cordova Requirements

```bash
cd src-cordova
npm install
```

### Step 4: Build APKs

```bash
cd ..
./build-apk.sh
```

---

## 📝 APK Details

### TEST Environment APK
- **API**: `https://z.test.soldout.com.ua`
- **File**: `builds/soldout-test.apk`
- **Use**: For testing with test backend

### PRODUCTION Environment APK  
- **API**: `https://z.soldout.com.ua`
- **File**: `builds/soldout-prod.apk`
- **Use**: For production deployment

Both APKs are:
- ✅ Debug builds (for testing)
- ✅ Can be installed via USB or direct download
- ⚠️ **NOT signed** (not for Play Store)

---

## 🔐 Signing APKs for Play Store

Debug APKs work for testing, but Play Store requires signed release APKs:

```bash
# 1. Generate keystore (one time)
keytool -genkey -v -keystore soldout-release-key.keystore \
  -alias soldout -keyalg RSA -keysize 2048 -validity 10000

# 2. Build release APK
npx quasar build -m cordova -T android --release

# 3. Sign the APK
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
  -keystore soldout-release-key.keystore \
  src-cordova/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  soldout

# 4. Align the APK
zipalign -v 4 \
  src-cordova/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  soldout-signed.apk
```

---

## 🆘 Troubleshooting

### "ANDROID_HOME not set"
```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
```

### "sdkmanager not found"
Install Android SDK command-line tools from Android Studio

### "Gradle build failed"
```bash
# Clean and rebuild
rm -rf src-cordova/platforms
./build-apk.sh
```

### "Java version mismatch"
Cordova works best with JDK 8. If you have newer version:
```bash
# Install JDK 8 via Homebrew
brew install --cask adoptopenjdk8
```

---

## 📞 Next Steps

1. **Install Android Studio** (~2GB download, ~30 min setup)
2. **Configure environment variables**
3. **Run `./build-apk.sh`** 
4. **Test APKs** on Android device
5. **Sign for production** when ready for Play Store

---

## 💡 Quick Test Without Building

If you just want to test the app without building APKs:

1. **Keep using the Docker container** at `http://localhost:4200`
2. **Open on phone's browser**: `http://your-computer-ip:4200`
3. **Test all functionality** in mobile browser
4. **Build APK later** when ready for offline use

---

## ⏱️ Estimated Time

- **Android Studio Installation**: 30-45 minutes
- **First APK Build**: 15-20 minutes
- **Subsequent Builds**: 5-10 minutes
- **Total Setup**: ~1 hour for first time

---

## 📚 Additional Resources

- **Quasar Cordova Docs**: https://quasar.dev/quasar-cli/developing-cordova-apps
- **Cordova Android Docs**: https://cordova.apache.org/docs/en/latest/guide/platforms/android/
- **Android Studio Guide**: https://developer.android.com/studio/intro

---

**Ready to build?** Just install Android Studio and run `./build-apk.sh`!

Need help? Check `BUILD_INSTRUCTIONS.md` for detailed step-by-step guide.

