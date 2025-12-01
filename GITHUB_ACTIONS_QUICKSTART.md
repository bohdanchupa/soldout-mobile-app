# 🚀 Quick Start: Get Your APKs in 15 Minutes

## ✅ I've Set Up Automatic APK Builds for You!

### What It Does:
- ✅ **Builds TEST and PROD APKs automatically** on every push
- ✅ **No Android Studio needed** - GitHub does everything
- ✅ **5-8 minute builds** - Fast and automatic
- ✅ **Download APKs** directly from GitHub

---

## 📋 3 Simple Steps to Get Your APKs

### Step 1: Push to GitHub (2 minutes)

```bash
cd "/Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток орга/org-mobile-app"

# If you don't have a GitHub repo yet, create one at https://github.com/new
# Then:

git add .
git commit -m "Add GitHub Actions for automatic APK builds"
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

---

### Step 2: Enable GitHub Actions (1 minute)

1. Go to your GitHub repository
2. Click **"Actions"** tab at the top
3. Click **"I understand my workflows, go ahead and enable them"**

---

### Step 3: Trigger Build & Download APKs (10 minutes)

**Option A: Automatic (just push)**
```bash
git push
```

**Option B: Manual (click a button)**
1. Go to **Actions** tab
2. Click **"Build Android APKs"** on the left
3. Click **"Run workflow"** button (top right)
4. Select **"both"** (builds TEST and PROD)
5. Click green **"Run workflow"**

**Wait 8-10 minutes** (first build is slower)

**Download your APKs:**
1. Click on the running workflow
2. Wait for completion ✅
3. Scroll down to **"Artifacts"** section
4. Download:
   - `soldout-test-apk` → Unzip → Install
   - `soldout-prod-apk` → Unzip → Install

---

## 🎉 Done!

You now have:
- ✅ `soldout-test-debug.apk` (TEST environment)
- ✅ `soldout-prod-debug.apk` (PROD environment)

---

## 📱 Install on Android Phone

1. **Transfer APK** to your phone (email, Drive, or USB)
2. **Enable Unknown Sources**:
   - Settings → Security → Install unknown apps → Enable for your file manager
3. **Tap APK** → Install
4. **Open app** and test!

---

## 🔄 Future Builds

Every time you push code:
```bash
git add .
git commit -m "Update feature"
git push
```

→ GitHub **automatically builds** new APKs!  
→ Download from **Actions → Latest run → Artifacts**

---

## 📊 Build Status

| What | Where | Time |
|------|-------|------|
| **View builds** | Actions tab | Real-time |
| **Download APKs** | Artifacts section | After build |
| **Build time** | First: 10 min, Later: 5-8 min | Automatic |

---

## 🆘 Troubleshooting

### Build Failed?
- Go to Actions → Click failed run → View logs
- Usually fixes itself on retry

### Can't Find APKs?
- Scroll to **bottom** of workflow run page
- Look for **"Artifacts"** section
- APKs expire after 30 days (rebuild anytime)

### Need Release APK (for Play Store)?
- Let me know - I'll configure signed release builds

---

## 💡 Pro Tips

1. **Manual builds**: Use "Run workflow" button anytime (no code push needed)
2. **Both environments**: Builds TEST and PROD simultaneously  
3. **No cost**: GitHub Actions is free for public repos (2,000 min/month for private)
4. **Auto-updates**: Push code → New APKs automatically

---

## 📚 More Info

Detailed documentation: `.github/workflows/README.md`

---

## ✨ Summary

You went from **"I need APKs"** to **"Auto-building APKs on every push"** in 15 minutes!

**No more:**
- ❌ Android Studio installation
- ❌ Manual builds  
- ❌ Complex setup

**Just:**
- ✅ Push code
- ✅ Download APKs
- ✅ Install and test

---

**Questions?** The workflow is fully configured and ready to use. Just push to GitHub! 🚀

