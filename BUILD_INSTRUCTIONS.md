# Building Android APKs for Soldout App

## Prerequisites

To build Android APKs, you need:

1. **Android Studio** with Android SDK
2. **Java JDK 8** (not newer versions for Cordova compatibility)
3. **Gradle**
4. **Node.js 14** (we're using this in Docker)

---

## Option 1: Quick Build (If you have Android Studio installed)

### Step 1: Check Prerequisites

```bash
# Check if Android SDK is installed
echo $ANDROID_HOME

# Check Java version (should be 1.8)
java -version

# Check Gradle
gradle -version
```

### Step 2: Build TEST Environment APK

```bash
cd "/Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток орга/org-mobile-app"

# Ensure you're on Node 14 (if using nvm)
nvm use 14

# Build for Android
npx quasar build -m cordova -T android

# APK will be in: src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

### Step 3: Build PRODUCTION Environment APK

```bash
# Switch to production API
# Edit src/api/endpoints.js and uncomment production URL

# Clean previous build
rm -rf src-cordova/platforms src-cordova/www

# Build for Android
npx quasar build -m cordova -T android

# APK will be in: src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

---

## Option 2: Using Docker (Automated)

I've created a Docker-based build system for you.

### Build Android Docker Image

```bash
cd "/Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток орга/org-mobile-app"

docker build -f Dockerfile.android -t soldout-android-builder .
```

This will take 10-15 minutes as it downloads Android SDK and tools.

### Run Build Script

```bash
# Make script executable
chmod +x build-apks.sh

# Run the build
./build-apks.sh
```

The script will:
1. Build TEST environment APK
2. Build PRODUCTION environment APK  
3. Place both APKs in `builds/` directory
4. Restore TEST configuration

---

## Option 3: Manual Docker Build

If automated script fails, build manually:

### Build TEST APK

```bash
# Run build container
docker run --rm \
  -v "$(pwd)":/app \
  -w /app \
  soldout-android-builder \
  sh -c "npx quasar build -m cordova -T android --debug"

# Copy APK
cp src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk \
   soldout-test-debug.apk
```

### Build PRODUCTION APK

```bash
# Edit src/api/endpoints.js - switch to production URL
# Then run:

docker run --rm \
  -v "$(pwd)":/app \
  -w /app \
  soldout-android-builder \
  sh -c "npx quasar build -m cordova -T android --debug"

# Copy APK
cp src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk \
   soldout-prod-debug.apk
```

---

## Signing APKs for Production

Debug APKs work for testing but need to be signed for Google Play Store:

```bash
# Generate keystore (one time only)
keytool -genkey -v -keystore soldout-release-key.keystore \
  -alias soldout -keyalg RSA -keysize 2048 -validity 10000

# Sign the APK
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
  -keystore soldout-release-key.keystore \
  app-release-unsigned.apk soldout

# Align the APK
zipalign -v 4 app-release-unsigned.apk soldout-signed.apk
```

---

## Troubleshooting

### "Android SDK not found"
Set ANDROID_HOME environment variable:
```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

### "Gradle build failed"
Check Java version - must be JDK 8:
```bash
java -version  # Should show 1.8.x
```

### "Command failed with exit code 1"
Clean and rebuild:
```bash
rm -rf src-cordova/platforms src-cordova/plugins src-cordova/www
npx quasar build -m cordova -T android
```

---

## Quick Test Build (Easiest)

If you just want to test quickly and have Android Studio installed:

```bash
# 1. Open Android Studio
# 2. Go to Tools > SDK Manager
# 3. Install Android SDK Platform 28 or higher
# 4. Run:

cd "/Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток орга/org-mobile-app"
npx quasar build -m cordova -T android --debug

# APK location:
# src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

Copy this APK to your Android device and install it!

---

## Build Output Locations

After successful build:

- **Debug APK**: `src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk`
- **Release APK**: `src-cordova/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk`

---

## Next Steps After Building

1. **Test APK**: Install on Android device
2. **Test Functionality**: Login, view events, check statistics
3. **Sign for Production**: Use your release keystore
4. **Upload to Play Store**: Use signed APK

Need help? Check the Quasar Cordova docs:
https://quasar.dev/quasar-cli/developing-cordova-apps/build-commands

