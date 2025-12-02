#!/bin/bash

set -e

echo "🔨 Rebuilding iOS App with Cordova Support"
echo "=========================================="
echo ""

cd "/Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток орга/org-mobile-app"

echo "📦 Step 1: Building web assets in Docker..."
docker exec soldout-app-container sh -c "npx quasar build" > /dev/null 2>&1
echo "✅ Web assets built"

echo "📋 Step 2: Copying from Docker to local..."
rm -rf dist/spa
docker cp soldout-app-container:/app/dist/spa ./dist/
rm -rf src-cordova/www
mkdir -p src-cordova/www
cp -r dist/spa/* src-cordova/www/
echo "✅ Assets copied to src-cordova/www/"

echo "🔧 Step 3: Running cordova prepare ios..."
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
cd src-cordova
cordova prepare ios > /dev/null 2>&1
echo "✅ Cordova prepared"

echo "📝 Step 4: Injecting cordova.js into index.html..."
INDEX_FILE="platforms/ios/www/index.html"
if ! grep -q "cordova.js" "$INDEX_FILE"; then
    sed -i '' 's|<div id=q-app></div>|<div id=q-app></div><script src=cordova.js></script>|' "$INDEX_FILE"
    echo "✅ cordova.js injected"
else
    echo "✅ cordova.js already present"
fi

echo ""
echo "=========================================="
echo "✅ Build Complete!"
echo ""
echo "📱 Next steps:"
echo "   1. Open Xcode"
echo "   2. Product → Clean Build Folder (Cmd+Shift+K)"
echo "   3. Product → Run (Cmd+R)"
echo ""
echo "🔍 Check Safari Console for:"
echo "   - ✅ Cordova deviceready event fired!"
echo "   - 📱 Using Cordova Native HTTP Plugin"
echo ""

