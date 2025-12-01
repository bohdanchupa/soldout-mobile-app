#!/bin/bash

# Simple APK Build Script for Soldout App
# This builds locally (requires Android Studio/SDK)

set -e

echo "🚀 Soldout App - APK Builder"
echo "============================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check for required tools
echo "${BLUE}Checking prerequisites...${NC}"

if ! command -v java &> /dev/null; then
    echo "${RED}❌ Java not found. Please install JDK 8.${NC}"
    exit 1
fi

if [ -z "$ANDROID_HOME" ]; then
    echo "${YELLOW}⚠️  ANDROID_HOME not set. Trying default location...${NC}"
    export ANDROID_HOME=$HOME/Library/Android/sdk
fi

if [ ! -d "$ANDROID_HOME" ]; then
    echo "${RED}❌ Android SDK not found at $ANDROID_HOME${NC}"
    echo "Please install Android Studio and set ANDROID_HOME"
    exit 1
fi

echo "${GREEN}✓ Java found: $(java -version 2>&1 | head -1)${NC}"
echo "${GREEN}✓ Android SDK found: $ANDROID_HOME${NC}"
echo ""

# Create builds directory
mkdir -p builds

# Function to build APK
build_apk() {
    ENV_NAME=$1
    ENV_URL=$2
    OUTPUT_NAME=$3
    
    echo "${BLUE}Building $ENV_NAME environment APK...${NC}"
    echo "API URL: $ENV_URL"
    
    # Update endpoints.js
    cat > src/api/endpoints.js << EOF
// $ENV_NAME Environment
const serviceUrl = '$ENV_URL'

export const serviceURL = serviceUrl

export const epToken = \`\${serviceUrl}/main-service/oauth/token\`
export const epLogin = \`\${serviceUrl}/main-service/user/get\`
export const epAllOrders = \`\${serviceUrl}/main-service/api/find-orders-by-organizator\`
export const epAllTickets = \`\${serviceUrl}/main-service/api/find-tickets-by-organizator-short\`
export const epSummOfPeriod = \`\${serviceUrl}/main-service/api/find-sum-by-organizator\`
export const epEvents = \`\${serviceUrl}/main-service/api/find-bought-events-by-organizator\`
export const epEventsToday = \`\${serviceUrl}/main-service/api/find-bought-events-and-info-by-organizator\`
export const epEventsArchive = \`\${serviceUrl}/main-service/api/find-archive-events-by-organizator\`
export const epEventInSum = \`\${serviceUrl}/main-service/api/find-sum-by-event\`
export const epEventInCount = \`\${serviceUrl}/main-service/api/find-count-by-event\`
export const epEventDetailsTable = \`\${serviceUrl}/main-service/api/find-color-price-by-event\`
export const epEventDetailsTableForDate = \`\${serviceUrl}/main-service/api/find-color-price-by-event-and-date\`
export const epStatisticInEntryScreen = \`\${serviceUrl}/main-service/api/find-events-by-organizator-main-short-info\`
export const epEventSoldShortInfo = \`\${serviceUrl}/main-service/api/find-events-by-organizator-sold-short-info\`
EOF

    # Clean previous build
    echo "Cleaning previous build..."
    rm -rf src-cordova/platforms src-cordova/www dist
    
    # Build
    echo "Building..."
    npx quasar build -m cordova -T android --debug
    
    # Copy APK
    if [ -f "src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk" ]; then
        cp src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk "builds/$OUTPUT_NAME.apk"
        echo "${GREEN}✓ APK created: builds/$OUTPUT_NAME.apk${NC}"
        
        # Show file size
        SIZE=$(du -h "builds/$OUTPUT_NAME.apk" | cut -f1)
        echo "${GREEN}  Size: $SIZE${NC}"
    else
        echo "${RED}❌ APK build failed!${NC}"
        return 1
    fi
    
    echo ""
}

# Build TEST APK
build_apk "TEST" "https://z.test.soldout.com.ua" "soldout-test"

# Build PRODUCTION APK  
build_apk "PRODUCTION" "https://z.soldout.com.ua" "soldout-prod"

# Restore TEST configuration
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

echo "${GREEN}=============================${NC}"
echo "${GREEN}✅ Build Complete!${NC}"
echo "${GREEN}=============================${NC}"
echo ""
echo "APK files created in builds/ directory:"
ls -lh builds/*.apk
echo ""
echo "${YELLOW}📱 To install on Android device:${NC}"
echo "1. Enable 'Unknown sources' in Android settings"
echo "2. Copy APK to device"
echo "3. Tap APK file to install"
echo ""
echo "${BLUE}Note:${NC} These are debug APKs for testing."
echo "For Play Store, you need to create signed release APKs."

