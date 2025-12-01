#!/bin/bash

set -e

echo "📦 Preparing VoltBuilder packages..."

# Build web assets
echo "Building web assets..."
docker run --rm -v "$(pwd)":/app -w /app soldout-app sh -c "npx quasar build"

# Create www directory structure for TEST
echo "Creating TEST package..."
mkdir -p src-cordova-test/www
cp -r dist/spa/* src-cordova-test/www/
cp -r src-cordova/* src-cordova-test/ 2>/dev/null || true

# Create zip for TEST
cd src-cordova-test
zip -r ../builds/soldout-test-voltbuilder.zip . -q
cd ..
rm -rf src-cordova-test

echo "✓ TEST package created: builds/soldout-test-voltbuilder.zip"

# Build PROD version
echo "Switching to PROD environment..."
cp src/api/endpoints.js src/api/endpoints.backup
cat > src/api/endpoints.js << 'EOF'
// Production
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

# Build web assets for PROD
echo "Building PROD web assets..."
docker run --rm -v "$(pwd)":/app -w /app soldout-app sh -c "npx quasar build"

# Create www directory structure for PROD
echo "Creating PROD package..."
mkdir -p src-cordova-prod/www
cp -r dist/spa/* src-cordova-prod/www/
cp -r src-cordova/* src-cordova-prod/ 2>/dev/null || true

# Create zip for PROD
cd src-cordova-prod
zip -r ../builds/soldout-prod-voltbuilder.zip . -q
cd ..
rm -rf src-cordova-prod

echo "✓ PROD package created: builds/soldout-prod-voltbuilder.zip"

# Restore TEST config
mv src/api/endpoints.backup src/api/endpoints.js

echo ""
echo "✅ Both VoltBuilder packages ready!"
echo "   - builds/soldout-test-voltbuilder.zip"
echo "   - builds/soldout-prod-voltbuilder.zip"

