# Soldout App - Setup Guide & Compatibility Issues

## 🚨 Current Situation

Your Quasar v1 application has compatibility issues when running on:
- **Node.js v24.3.0** (current on your system)
- **Apple Silicon (ARM64)** architecture
- **macOS 24.6.0**

### The Problem

The app was built with:
- **Quasar v1.4.4** (released ~2019)  
- **Vue.js 2.6.10** (now EOL)
- **node-sass 4.13.0** (doesn't support ARM64)

Modern alternatives (Dart Sass) have breaking changes incompatible with old Quasar v1 SASS code.

---

## ✅ Working Solutions

### Option 1: Use Node.js v14 (RECOMMENDED)

Node.js v14 is the last version fully compatible with this stack and supports ARM64.

```bash
# Install nvm if you don't have it
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Restart terminal, then:
nvm install 14
nvm use 14

# Navigate to project
cd "/Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток орга/org-mobile-app"

# Clean install
rm -rf node_modules package-lock.json
npm install

# Start dev server
npx quasar dev
```

### Option 2: Use Docker

Create `Dockerfile`:
```dockerfile
FROM node:14

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 8080
CMD ["npx", "quasar", "dev", "--hostname", "0.0.0.0"]
```

Run:
```bash
docker build -t soldout-app .
docker run -p 8080:8080 -v $(pwd):/app soldout-app
```

### Option 3: Upgrade to Quasar v2 (Long-term Solution)

The proper solution is to upgrade:
- Quasar v1 → v2
- Vue 2 → Vue 3
- node-sass → sass
- Old dependencies → current versions

This requires significant refactoring but makes the app future-proof.

---

## 🔧 What We Fixed

During troubleshooting, we successfully:

✅ Installed dependencies with `--ignore-scripts` workaround  
✅ Added modern `sass` package  
✅ Fixed `/deep/` selectors to `::v-deep` in components:
   - `src/components/GeneralSineChart.vue`
   - `src/components/SineCharts.vue`
✅ Updated `quasar.conf.js` to configure sass-loader
✅ Fixed Node.js v24 OpenSSL compatibility with `NODE_OPTIONS=--openssl-legacy-provider`

---

## 📊 Dependency Status

| Package | Current | Latest | Status |
|---------|---------|--------|--------|
| quasar | 1.4.4 | 2.12+ | ⚠️ Major version behind |
| vue | 2.6.10 | 3.4+ | ⚠️ EOL, unsupported |
| axios | 0.18.1 | 1.6+ | 🚨 Critical security issues |
| node-sass | 4.13.0 | N/A | 🚨 Doesn't work on ARM64 |

---

## 🎯 Quick Start (After fixing Node version)

Once you're on Node.js v14:

```bash
# 1. Clean slate
rm -rf node_modules package-lock.json .quasar

# 2. Install
npm install

# 3. Run
npx quasar dev
```

The app should open at **http://localhost:8080**

---

## 📝 API Configuration

The app connects to:
- **Test API**: `https://z.test.soldout.com.ua`
- **Production API**: `https://z.soldout.com.ua` (commented out)

Edit `src/api/endpoints.js` to switch environments.

---

## 🔐 Security Warnings

The current codebase has **167 vulnerabilities**:
- 21 critical
- 60 high  
- 72 moderate
- 14 low

### Critical Issues:
1. **Axios 0.18.1** - SSRF vulnerability (CVE-2020-28168)
2. **Vue 2** - No longer receiving security updates
3. **Various deprecated packages**

**For production use**, these MUST be addressed.

---

## 🛠️ Development Workflow (After Setup)

```bash
# Start dev server
npx quasar dev

# Build for production
npx quasar build

# Build for Android
npx quasar build -m cordova -T android

# Build for iOS  
npx quasar build -m cordova -T ios
```

---

## 📱 Mobile Development

### Android Requirements:
- Android Studio
- Android SDK
- Java JDK 8

### iOS Requirements (macOS only):
- Xcode
- iOS SDK

---

## 🚀 Migration Path (Recommended)

For long-term maintainability:

### Phase 1: Update Dependencies
```bash
npm install axios@latest
npm install @quasar/app@latest
# Review breaking changes for each
```

### Phase 2: Migrate to Vue 3 + Quasar v2
- Use official migration guides
- Update component syntax (Options API → Composition API)
- Update Vuex (or migrate to Pinia)
- Test thoroughly

### Phase 3: Modern Tooling
- Replace Cordova with Capacitor
- Add TypeScript
- Implement proper testing

---

## 📞 Support Resources

- **Quasar v1 Docs**: https://v1.quasar.dev
- **Vue 2 Docs**: https://v2.vuejs.org  
- **Quasar Discord**: https://chat.quasar.dev
- **Migration Guide**: https://quasar.dev/start/upgrade-guide

---

## ⚡ TL;DR - I Just Want It Running!

```bash
# Install Node 14
nvm install 14
nvm use 14

# Go to project
cd "/Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток орга/org-mobile-app"

# Install & run
rm -rf node_modules
npm install
npx quasar dev
```

**Then open**: http://localhost:8080

---

*Last updated: December 2025*  
*Status: Requires Node.js v14 for development on Apple Silicon*

