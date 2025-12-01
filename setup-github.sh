#!/bin/bash

# Quick setup script for GitHub Actions APK builds

set -e

echo "🚀 Setting up GitHub Actions for Automatic APK Builds"
echo ""

# Check if git is initialized
if [ ! -d ".git" ]; then
  echo "📦 Initializing git repository..."
  git init
  echo "✅ Git initialized"
else
  echo "✅ Git already initialized"
fi

# Check if remote exists
if ! git remote | grep -q "origin"; then
  echo ""
  echo "⚠️  No GitHub remote found!"
  echo ""
  echo "Please add your GitHub repository:"
  echo ""
  echo "  1. Create a new repo at: https://github.com/new"
  echo "  2. Then run:"
  echo ""
  echo "     git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
  echo ""
  read -p "Press Enter after you've added the remote, or Ctrl+C to exit..."
fi

# Check for staged changes
echo ""
echo "📋 Checking for changes to commit..."

if git diff --quiet && git diff --cached --quiet; then
  echo "ℹ️  No changes to commit"
else
  echo "✅ Changes detected"
  
  # Add all files
  echo "📝 Staging all files..."
  git add .
  
  # Commit
  echo "💾 Creating commit..."
  git commit -m "Add GitHub Actions workflow for automatic APK builds

- Builds TEST APK (z.test.soldout.com.ua)
- Builds PROD APK (z.soldout.com.ua)
- Automatic on every push
- Manual trigger available
- Uploads artifacts and creates releases" || echo "⚠️  Commit may already exist"
  
  echo "✅ Committed"
fi

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
if [ -z "$CURRENT_BRANCH" ]; then
  CURRENT_BRANCH="main"
  echo ""
  echo "📌 Creating main branch..."
  git checkout -b main
fi

echo ""
echo "📡 Current branch: $CURRENT_BRANCH"
echo ""

# Push
echo "🚀 Ready to push to GitHub!"
echo ""
echo "Run this command to push:"
echo ""
echo "   git push -u origin $CURRENT_BRANCH"
echo ""
echo "Then:"
echo "  1. Go to your GitHub repo"
echo "  2. Click 'Actions' tab"
echo "  3. Enable GitHub Actions"
echo "  4. Click 'Build Android APKs' → 'Run workflow'"
echo "  5. Wait 8-10 minutes"
echo "  6. Download APKs from 'Artifacts' section!"
echo ""
echo "🎉 Setup complete!"
echo ""
echo "📚 Documentation:"
echo "   - Quick Start: GITHUB_ACTIONS_QUICKSTART.md"
echo "   - Detailed Guide: .github/workflows/README.md"

