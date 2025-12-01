# GitHub Actions - Automatic APK Builds

## ✅ What This Does

This workflow **automatically builds** both TEST and PROD Android APKs whenever you push code to GitHub!

### Features:
- ✅ Builds **TEST APK** (with `z.test.soldout.com.ua`)
- ✅ Builds **PROD APK** (with `z.soldout.com.ua`)
- ✅ Uploads APKs as downloadable artifacts
- ✅ Creates GitHub releases with both APKs
- ✅ Can trigger manually for on-demand builds
- ✅ No local Android Studio needed!

---

## 🚀 Setup (5 Minutes)

### Step 1: Push to GitHub

If you haven't already, push this project to GitHub:

```bash
cd "/Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток орга/org-mobile-app"

# Initialize git (if not already)
git init

# Add all files
git add .

# Commit
git commit -m "Add GitHub Actions workflow for APK builds"

# Add your GitHub repo as remote
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Push
git push -u origin main
```

### Step 2: Enable GitHub Actions

1. Go to your GitHub repository
2. Click the **"Actions"** tab
3. GitHub will automatically detect the workflow
4. Click **"I understand my workflows, go ahead and enable them"**

### Step 3: Trigger First Build

**Option A: Automatic (Push code)**
```bash
git push
```

**Option B: Manual (On-demand)**
1. Go to **Actions** tab
2. Click **"Build Android APKs"** workflow
3. Click **"Run workflow"** button
4. Choose: `test`, `prod`, or `both`
5. Click green **"Run workflow"**

---

## 📥 Download Your APKs

### Method 1: From Workflow Run (Always Available)

1. Go to **Actions** tab
2. Click on the latest workflow run
3. Scroll down to **"Artifacts"** section
4. Download:
   - `soldout-test-apk.zip` (TEST environment)
   - `soldout-prod-apk.zip` (PROD environment)
5. Unzip and install!

### Method 2: From Releases (When pushed to main/master)

1. Go to **Releases** section (right side of repo)
2. Download latest release
3. Both APKs included in one release

---

## ⏱️ Build Time

- **First build**: 8-12 minutes (downloads Android SDK)
- **Subsequent builds**: 5-8 minutes (SDK cached)
- **Both APKs**: Built in parallel (same total time)

---

## 🎯 How It Works

### On Every Push:
```
You push code → GitHub detects changes → 
Builds TEST APK + PROD APK in parallel →
Uploads both as artifacts → 
Creates release (if push to main)
```

### Parallel Jobs:
```
Job 1: Build TEST APK (Ubuntu + Node 14 + Android SDK)
       ↓
       Installs deps → Builds → Uploads artifact

Job 2: Build PROD APK (Ubuntu + Node 14 + Android SDK)
       ↓
       Changes endpoints.js → Builds → Uploads artifact

Job 3: Create Release
       ↓
       Downloads both APKs → Creates GitHub release
```

---

## 🔧 Configuration

### Trigger Events:

**Automatic builds on:**
- Push to `main`, `master`, or `develop` branches
- Pull requests to `main` or `master`

**Manual builds:**
- Go to Actions → Run workflow
- Choose environment: `test`, `prod`, or `both`

### Customize Branches:

Edit `.github/workflows/build-apk.yml`:

```yaml
on:
  push:
    branches: [ main, master, develop, YOUR_BRANCH ]
```

---

## 📱 Install APKs on Android

1. **Download APK** from GitHub (see above)
2. **Transfer to phone**:
   - Email to yourself
   - Upload to Google Drive
   - Connect via USB
3. **Enable Unknown Sources**:
   - Settings → Security → Unknown Sources (enable)
4. **Install**:
   - Tap APK file → Install

---

## 🆚 Comparison

| Method | Setup Time | Build Time | Maintenance |
|--------|-----------|------------|-------------|
| **GitHub Actions** | 5 min | 5-8 min | None (automatic) |
| Local (Android Studio) | 1-2 hours | 15-20 min | Manual each time |
| Cloud Service | 10-30 min | 10-15 min | May require payment |

---

## 🔄 Workflow Status

Check build status:

1. **Actions tab**: See all builds, logs, and status
2. **Badge**: Add to README (optional):

```markdown
![Build APKs](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/build-apk.yml/badge.svg)
```

3. **Email notifications**: GitHub emails you on build failures

---

## 🐛 Troubleshooting

### Build Failed?

1. **Check logs**:
   - Actions → Click failed run → Click job → View logs

2. **Common issues**:
   - SASS errors → Fixed in workflow (uses legacy OpenSSL)
   - Node version → Locked to Node 14
   - Cordova version → Locked to 10.0.0

3. **Re-run failed builds**:
   - Click failed run → "Re-run failed jobs"

### First Build Slow?

- Normal! First build downloads Android SDK (~2 GB)
- Subsequent builds are much faster (cached)

### APKs Not Appearing?

- Check "Artifacts" section at bottom of workflow run
- Retention: 30 days (configurable in workflow)

---

## 📊 What Gets Built

### TEST APK:
- **File**: `soldout-test-debug.apk`
- **API**: `https://z.test.soldout.com.ua`
- **Package**: `com.soldoutstatistics.app`
- **Debuggable**: Yes

### PROD APK:
- **File**: `soldout-prod-debug.apk`
- **API**: `https://z.soldout.com.ua`
- **Package**: `com.soldoutstatistics.app`
- **Debuggable**: Yes (can change to release build)

---

## 🔐 Release (Signed) APKs

Current builds are DEBUG APKs (for testing).

For **Google Play Store**, you need RELEASE APKs:

### Add Signing to Workflow:

1. **Generate keystore locally**:
```bash
keytool -genkey -v -keystore soldout-release.keystore \
  -alias soldout -keyalg RSA -keysize 2048 -validity 10000
```

2. **Add secrets to GitHub**:
   - Settings → Secrets and variables → Actions
   - Add:
     - `KEYSTORE_FILE` (base64 encoded keystore)
     - `KEYSTORE_PASSWORD`
     - `KEY_ALIAS`
     - `KEY_PASSWORD`

3. **Update workflow** to use release mode

I can help configure this when you're ready!

---

## 💡 Pro Tips

### 1. Test Branch First
Create a `develop` branch for testing builds before merging to `main`:

```bash
git checkout -b develop
git push origin develop
```

### 2. Manual Builds
Use "Run workflow" for on-demand builds without pushing code

### 3. Cache Management
GitHub caches Node modules and Android SDK (saves 2-3 minutes per build)

### 4. Parallel Builds
Both TEST and PROD build simultaneously (no wait time)

---

## 🎉 You're Done!

**Next Steps:**

1. ✅ Push code to GitHub
2. ✅ Go to Actions tab
3. ✅ Watch build run (5-8 min)
4. ✅ Download APKs
5. ✅ Install on phone
6. ✅ Test your app!

**Future builds:**
- Just push code → APKs built automatically!
- No more manual builds needed

---

## 📞 Support

Having issues? Check:

1. **Build logs** in Actions tab
2. **YAML syntax** if you edited the workflow
3. **GitHub Actions documentation**: https://docs.github.com/en/actions

---

**Enjoy automatic APK builds!** 🚀📱

