#!/bin/bash

# Script to build APKs for Test and Production environments
set -e

echo "🚀 Building Soldout App APKs for Test and Production"
echo "=================================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create builds directory
mkdir -p builds

echo ""
echo "${BLUE}📦 Step 1: Building TEST Environment APK${NC}"
echo "=================================================="

# Ensure we're using test environment
cat > src/api/endpoints.js << 'EOF'
// Test
const serviceUrl = 'https://z.test.soldout.com.ua'
// Prod
// const serviceUrl = 'https://z.soldout.com.ua'

export const serviceURL = serviceUrl

export const epToken = `${serviceUrl}/main-service/oauth/token`
export const epLogin = `${serviceUrl}/main-service/user/get`
export const epAllOrders = `${serviceUrl}/main-service/api/find-orders-by-organizator`
export const epAllTickets = `${serviceUrl}/main-service/api/find-tickets-by-organizator-short`
export const epSummOfPeriod = `${serviceUrl}/main-service/api/find-sum-by-organizator`
export const epEvents = `${serviceUrl}/main-service/api/find-bought-events-by-organizator`
export const epEventsToday = `${serviceUrl}/main-service/api/find-bought-events-and-info-by-organizator`
export const epEventsArchive = `${serviceUrl}/main-service/api/find-archive-events-by-organizator`
export const epEventInSum = `${serviceUrl}/main-service/api/find-sum-by-event`
export const epEventInCount = `${serviceUrl}/main-service/api/find-count-by-event`
export const epEventDetailsTable = `${serviceUrl}/main-service/api/find-color-price-by-event`
export const epEventDetailsTableForDate = `${serviceUrl}/main-service/api/find-color-price-by-event-and-date`
export const epStatisticInEntryScreen = `${serviceUrl}/main-service/api/find-events-by-organizator-main-short-info`
export const epEventSoldShortInfo = `${serviceUrl}/main-service/api/find-events-by-organizator-sold-short-info`
EOF

echo "${GREEN}✓ Configured for TEST environment${NC}"

# Build TEST APK
echo "Building APK..."
docker run --rm \
  -v "$(pwd)":/app \
  -w /app \
  --name soldout-build-test \
  soldout-app \
  sh -c "npx quasar build -m cordova -T android"

# Find and copy the APK
if [ -f "src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk" ]; then
  cp src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk builds/soldout-test-debug.apk
  echo "${GREEN}✓ TEST APK created: builds/soldout-test-debug.apk${NC}"
fi

if [ -f "src-cordova/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk" ]; then
  cp src-cordova/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk builds/soldout-test-release.apk
  echo "${GREEN}✓ TEST Release APK created: builds/soldout-test-release.apk${NC}"
fi

echo ""
echo "${BLUE}📦 Step 2: Building PRODUCTION Environment APK${NC}"
echo "=================================================="

# Switch to production environment
cat > src/api/endpoints.js << 'EOF'
// Test
// const serviceUrl = 'https://z.test.soldout.com.ua'
// Prod
const serviceUrl = 'https://z.soldout.com.ua'

export const serviceURL = serviceUrl

export const epToken = `${serviceUrl}/main-service/oauth/token`
export const epLogin = `${serviceUrl}/main-service/user/get`
export const epAllOrders = `${serviceUrl}/main-service/api/find-orders-by-organizator`
export const epAllTickets = `${serviceUrl}/main-service/api/find-tickets-by-organizator-short`
export const epSummOfPeriod = `${serviceUrl}/main-service/api/find-sum-by-organizator`
export const epEvents = `${serviceUrl}/main-service/api/find-bought-events-by-organizator`
export const epEventsToday = `${serviceUrl}/main-service/api/find-bought-events-and-info-by-organizator`
export const epEventsArchive = `${serviceUrl}/main-service/api/find-archive-events-by-organizator`
export const epEventInSum = `${serviceUrl}/main-service/api/find-sum-by-event`
export const epEventInCount = `${serviceUrl}/main-service/api/find-count-by-event`
export const epEventDetailsTable = `${serviceUrl}/main-service/api/find-color-price-by-event`
export const epEventDetailsTableForDate = `${serviceUrl}/main-service/api/find-color-price-by-event-and-date`
export const epStatisticInEntryScreen = `${serviceUrl}/main-service/api/find-events-by-organizator-main-short-info`
export const epEventSoldShortInfo = `${serviceUrl}/main-service/api/find-events-by-organizator-sold-short-info`
EOF

echo "${GREEN}✓ Configured for PRODUCTION environment${NC}"

# Clean previous build
rm -rf src-cordova/platforms src-cordova/www

# Build PRODUCTION APK
echo "Building APK..."
docker run --rm \
  -v "$(pwd)":/app \
  -w /app \
  --name soldout-build-prod \
  soldout-app \
  sh -c "npx quasar build -m cordova -T android"

# Find and copy the APK
if [ -f "src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk" ]; then
  cp src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk builds/soldout-prod-debug.apk
  echo "${GREEN}✓ PRODUCTION APK created: builds/soldout-prod-debug.apk${NC}"
fi

if [ -f "src-cordova/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk" ]; then
  cp src-cordova/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk builds/soldout-prod-release.apk
  echo "${GREEN}✓ PRODUCTION Release APK created: builds/soldout-prod-release.apk${NC}"
fi

# Restore test environment
cat > src/api/endpoints.js << 'EOF'
// Test
const serviceUrl = 'https://z.test.soldout.com.ua'
// Prod
// const serviceUrl = 'https://z.soldout.com.ua'

export const serviceURL = serviceUrl

export const epToken = `${serviceUrl}/main-service/oauth/token`
export const epLogin = `${serviceUrl}/main-service/user/get`
export const epAllOrders = `${serviceUrl}/main-service/api/find-orders-by-organizator`
export const epAllTickets = `${serviceUrl}/main-service/api/find-tickets-by-organizator-short`
export const epSummOfPeriod = `${serviceUrl}/main-service/api/find-sum-by-organizator`
export const epEvents = `${serviceUrl}/main-service/api/find-bought-events-by-organizator`
export const epEventsToday = `${serviceUrl}/main-service/api/find-bought-events-and-info-by-organizator`
export const epEventsArchive = `${serviceUrl}/main-service/api/find-archive-events-by-organizator`
export const epEventInSum = `${serviceUrl}/main-service/api/find-sum-by-event`
export const epEventInCount = `${serviceUrl}/main-service/api/find-count-by-event`
export const epEventDetailsTable = `${serviceUrl}/main-service/api/find-color-price-by-event`
export const epEventDetailsTableForDate = `${serviceUrl}/main-service/api/find-color-price-by-event-and-date`
export const epStatisticInEntryScreen = `${serviceUrl}/main-service/api/find-events-by-organizator-main-short-info`
export const epEventSoldShortInfo = `${serviceUrl}/main-service/api/find-events-by-organizator-sold-short-info`
EOF

echo ""
echo "${GREEN}✅ Build Complete!${NC}"
echo "=================================================="
echo "APK files are in the 'builds/' directory:"
ls -lh builds/*.apk 2>/dev/null || echo "No APK files found"
echo ""
echo "${BLUE}Note:${NC} These are unsigned debug APKs. For production release,"
echo "you need to sign them with your keystore."

