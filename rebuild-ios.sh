#!/bin/bash

set -e

echo "🔨 Rebuilding iOS App with Cordova Support"
echo "=========================================="
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"
# Почистимо локальну dist, щоб уникнути старих артефактів (цей шлях змонтовано в контейнер)
rm -rf dist/spa

echo "📦 Step 1: Building web assets in Docker..."
docker exec soldout-app-container sh -c "cd /app && npx quasar build"
echo "🔎 Checking build output..."
if ! docker exec soldout-app-container sh -c "[ -d /app/dist/spa ]"; then
  echo "❌ Не знайдено /app/dist/spa у контейнері після quasar build"
  echo "   Перевірте логи quasar або виконайте вручну:"
  echo "   docker exec soldout-app-container sh -c \"cd /app && npx quasar build\""
  exit 1
fi
echo "✅ Web assets built"

echo "📋 Step 2: Copying from Docker to local..."
if [ ! -d dist/spa ]; then
  echo "❌ dist/spa не знайдено на хості після білду (ймовірно, bind-mount не спрацював)"
  echo "   Перевірте, що контейнер запущено з мапінгом робочої директорії"
  exit 1
fi
rm -rf src-cordova/www
mkdir -p src-cordova/www
cp -r dist/spa/* src-cordova/www/
echo "✅ Assets copied to src-cordova/www/"

echo "🔧 Step 3: Running cordova prepare ios..."
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
cd src-cordova
candidate_nvm="$HOME/.nvm/nvm.sh"
if [ -s "$candidate_nvm" ]; then
  # shellcheck source=/dev/null
  . "$candidate_nvm"
fi
if ! command -v node >/dev/null 2>&1; then
  echo "❌ Node не знайдено. Увімкніть nvm або встановіть Node 14/18."
  exit 1
fi
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

