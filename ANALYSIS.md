# Soldout App - Architecture & Development Guide

## 📋 Table of Contents
1. [Application Overview](#application-overview)
2. [Architecture Analysis](#architecture-analysis)
3. [Code Implementation Patterns](#code-implementation-patterns)
4. [Local Development Setup](#local-development-setup)
5. [Building & Testing](#building--testing)
6. [Key Features Analysis](#key-features-analysis)
7. [Recommendations](#recommendations)

---

## Application Overview

**Name:** Soldout Event
**Type:** Statistics Mobile Application
**Purpose:** Event management and ticket sales statistics tracking
**Version:** 0.0.3
**Target Platforms:** Android, iOS, Browser

### Tech Stack
- **Framework:** Quasar Framework v1.x (Vue.js 2)
- **State Management:** Vuex
- **HTTP Client:** Axios
- **Mobile Platform:** Apache Cordova
- **Language:** JavaScript (Vue.js 2 Options API)
- **Styling:** SCSS with custom Gotham Pro fonts
- **Charts:** ApexCharts & vue-trend-chart
- **API:** RESTful API (Soldout backend)

---

## Architecture Analysis

### 1. Project Structure

```
org-mobile-app/
├── src/                          # Application source code
│   ├── api/                      # API configuration
│   │   └── endpoints.js          # All API endpoints
│   ├── assets/                   # SVG images and graphics
│   ├── boot/                     # Quasar boot files
│   │   └── axios.js              # Axios configuration
│   ├── components/               # Reusable Vue components
│   │   ├── GeneralSineChart.vue  # Chart component
│   │   ├── Preloader.vue         # Loading component
│   │   ├── SineCharts.vue        # Multiple charts component
│   │   └── TotalSoulds.vue       # Statistics display component
│   ├── css/                      # Global styles
│   │   ├── app.scss              # Main styles
│   │   ├── fonts.scss            # Font definitions
│   │   ├── general.scss          # General styles
│   │   ├── page.scss             # Page-specific styles
│   │   └── quasar.variables.scss # Quasar variables
│   ├── fonts/                    # Gotham Pro font files
│   ├── layouts/                  # Layout components
│   │   └── Index.vue             # Main layout wrapper
│   ├── pages/                    # Route pages
│   │   ├── Entry.vue             # Main dashboard
│   │   ├── Error404.vue          # 404 error page
│   │   ├── EventDetails.vue      # Event details page
│   │   ├── ListOfEvents.vue      # Events listing
│   │   ├── Login.vue             # Authentication page
│   │   └── Profile.vue           # User profile
│   ├── router/                   # Vue Router configuration
│   │   ├── index.js              # Router initialization
│   │   └── routes.js             # Route definitions
│   ├── store/                    # Vuex store
│   │   ├── index.js              # Store initialization
│   │   └── module/               # Store modules
│   │       ├── actions.js        # Async actions
│   │       ├── getters.js        # State getters
│   │       ├── mutations.js      # State mutations
│   │       ├── state.js          # State definition
│   │       └── index.js          # Module export
│   ├── statics/                  # Static assets (icons)
│   └── App.vue                   # Root component
├── src-cordova/                  # Cordova configuration
│   ├── config.xml                # Cordova config
│   ├── res/                      # Mobile resources (icons, splash)
│   └── package.json              # Cordova dependencies
├── package.json                  # Main dependencies
├── quasar.conf.js               # Quasar configuration
└── README.md                     # Basic documentation
```

### 2. Application Flow

```
┌─────────────┐
│   Login     │ ──────────────────┐
│   Page      │                   │
└─────────────┘                   │
      │                           │
      │ (OAuth authentication)    │
      ▼                           │
┌─────────────────────────────────┴──┐
│   Vuex Store                       │
│   - accessToken                    │
│   - user data                      │
│   - app state                      │
└────────────────────┬───────────────┘
                     │
      ┌──────────────┼──────────────┐
      │              │              │
      ▼              ▼              ▼
┌──────────┐  ┌──────────┐  ┌──────────┐
│  Entry   │  │  Events  │  │ Profile  │
│  (Main)  │  │  List    │  │   Page   │
└──────────┘  └──────────┘  └──────────┘
      │
      ▼
┌──────────────┐
│Event Details │
└──────────────┘
```

### 3. State Management Architecture

**Vuex Store Structure:**

```javascript
State:
- user: { firstName, lastName, mail, phone, logined }
- accessToken: string (JWT token)
- error: any
- showDetailsOnEntryScreen: boolean
- showDetailsOnEntryScreenForDate: date
- fetchingData: boolean

Getters:
- getUser
- getAccessToken
- isDetailsShow
- getError
- isFetchingData

Actions:
- login({ login, password })
- logout()
- showDetails({ show })
- setDateForDetails({ date })
- fetchingData({ isFetching })

Mutations:
- login
- logout
- showDetails
- setError
- setDateForDetails
- fetchingData
```

---

## Code Implementation Patterns

### 1. Authentication Flow

**Location:** `src/pages/Login.vue` + `src/store/module/actions.js`

```
1. User enters credentials
2. Component dispatches 'login' action
3. Action makes OAuth token request to API
4. On success, fetches user data
5. Stores data in LocalStorage for persistence
6. Commits to Vuex store
7. Router redirects to /entry page
```

**Key Features:**
- Auto-login from LocalStorage on app start
- OAuth 2.0 password grant flow
- Bearer token authentication
- Custom API access header

### 2. API Communication Pattern

**Configuration:** `src/api/endpoints.js`

```javascript
// All endpoints are centrally defined
const serviceUrl = 'https://z.test.soldout.com.ua'  // Test environment
// const serviceUrl = 'https://z.soldout.com.ua'    // Production

export const epLogin = `${serviceUrl}/main-service/user/get`
export const epEvents = `${serviceUrl}/main-service/api/...`
```

**Usage Pattern:**
```javascript
this.$axios({
  method: 'get',
  url: epSummOfPeriod,
  params: { dateFrom, dateTo },
  headers: {
    'Authorization': 'Bearer ' + this.$store.getters.getAccessToken,
    'X-SOLDOUT-STATISTIC-APP-ACCESS': 'b9011a8e5cdb1b62ec5513e2303c2b78'
  }
})
```

### 3. Component Architecture

**Pages vs Components:**
- **Pages:** Route-level components with data fetching logic
- **Components:** Reusable UI components (charts, preloader, statistics display)

**Example: Entry.vue (Main Dashboard)**
```
1. Mounted lifecycle hook
2. Calculates today's date range
3. Makes parallel API calls:
   - Summary statistics
   - Order count
   - Ticket count
   - Historical data for charts
4. Processes data for visualization
5. Renders TotalSoulds and SineCharts components
```

### 4. Routing Configuration

**Location:** `src/router/routes.js`

```javascript
Routes:
/ ──────────────────────> Login page
/entry ──────────────────> Main dashboard (statistics)
/list-of-events/:listId ─> Events listing
/event/:eventId/... ─────> Event details
/profile ────────────────> User profile

All routes use lazy loading: () => import('pages/...')
```

### 5. Styling Approach

**Multi-layer SCSS organization:**
1. `quasar.variables.scss` - Variables and mixins
2. `fonts.scss` - Gotham Pro font-face definitions
3. `general.scss` - Global styles
4. `page.scss` - Page-specific styles
5. Component scoped styles - In `.vue` files

**Custom Features:**
- Linear gradients for backgrounds
- Custom SVG dividers and decorations
- Mobile-first responsive design
- Ukrainian language UI

---

## Local Development Setup

### Prerequisites

```bash
Node.js: >= 8.9.0
NPM: >= 5.6.0
Yarn: >= 1.6.0 (optional)
```

### Step 1: Install Dependencies

```bash
cd /Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток\ орга/org-mobile-app

# Install main dependencies
npm install

# Install Cordova dependencies (for mobile builds)
cd src-cordova
npm install
cd ..
```

### Step 2: Install Quasar CLI (if not installed globally)

```bash
npm install -g @quasar/cli
```

### Step 3: Development Server

```bash
# Start development server with hot-reload
quasar dev

# Server will open automatically in browser at http://localhost:8080
```

### Step 4: Configure API Environment

**Edit:** `src/api/endpoints.js`

```javascript
// For local testing, ensure you're using the correct API endpoint
const serviceUrl = 'https://z.test.soldout.com.ua'  // Test API
// const serviceUrl = 'https://z.soldout.com.ua'    // Production API
```

---

## Building & Testing

### 1. Web Browser Testing

```bash
# Development mode (hot-reload)
quasar dev

# Production build for web
quasar build

# Output: dist/spa/ directory
```

### 2. Mobile Testing (Android)

**Requirements:**
- Android Studio
- Android SDK
- Java JDK 8

```bash
# Add Android platform (first time only)
cd src-cordova
cordova platform add android
cd ..

# Run on Android device/emulator
quasar dev -m cordova -T android

# Build APK for testing
quasar build -m cordova -T android

# Output: src-cordova/platforms/android/app/build/outputs/apk/
```

### 3. Mobile Testing (iOS)

**Requirements:**
- macOS
- Xcode
- iOS SDK

```bash
# Add iOS platform (first time only)
cd src-cordova
cordova platform add ios
cd ..

# Run on iOS device/simulator
quasar dev -m cordova -T ios

# Build for iOS
quasar build -m cordova -T ios

# Open in Xcode for signing and deployment
open src-cordova/platforms/ios/*.xcworkspace
```

### 4. Code Quality

```bash
# Run ESLint
npm run lint

# ESLint will check:
# - .js files
# - .vue files
# - Following Standard JS style guide
```

### 5. Testing Checklist

**Browser Testing:**
- [ ] Login functionality
- [ ] Dashboard statistics display
- [ ] Chart rendering
- [ ] Event list navigation
- [ ] Event details page
- [ ] Profile page
- [ ] Logout functionality
- [ ] Responsive design (mobile viewport)

**Mobile Testing:**
- [ ] App launches correctly
- [ ] Splash screen displays
- [ ] Login persists after app close
- [ ] Back button behavior
- [ ] Portrait orientation lock
- [ ] Network requests work
- [ ] Touch interactions
- [ ] Performance on lower-end devices

---

## Key Features Analysis

### 1. Dashboard (Entry.vue)

**Features:**
- Current date statistics
- Total sales amount (with expandable details)
- 7-day trend charts (tickets, orders, revenue)
- Interactive chart markers (click to see specific date details)
- Real-time data fetching

**API Calls:**
```javascript
epSummOfPeriod      // Summary statistics for date range
epAllOrders         // Total orders count
epAllTickets        // Total tickets count
epStatisticInEntryScreen // Historical data for charts
```

### 2. Authentication (Login.vue)

**Features:**
- Email/password login
- OAuth 2.0 token-based authentication
- Persistent login (LocalStorage)
- Auto-login on app restart
- Error handling and user feedback

**Security:**
- Bearer token authentication
- Custom API access header
- Tokens stored in LocalStorage and Vuex

### 3. Data Visualization

**Components:**
- `TotalSoulds.vue` - Sales statistics with expandable details
- `SineCharts.vue` - Trend charts container
- `GeneralSineChart.vue` - Individual chart rendering

**Libraries:**
- ApexCharts - Advanced charting
- vue-trend-chart - Trend line charts

### 4. State Persistence

**LocalStorage Usage:**
```javascript
// Stored data
{
  userData: {
    login: 'user@email.com',
    pass: 'password'
  }
}
```

**Vuex Store:**
- User information
- Authentication token
- UI state (loading, detail visibility)

---

## Recommendations

### 1. Security Improvements

**Current Issues:**
- ⚠️ Passwords stored in LocalStorage (plain text)
- ⚠️ API access key hardcoded in source code
- ⚠️ Test credentials in comments

**Recommendations:**
```javascript
// 1. Remove password from LocalStorage - only store token
LocalStorage.set('authToken', accessToken)

// 2. Move API keys to environment variables
const API_ACCESS_KEY = process.env.API_ACCESS_KEY

// 3. Remove test credentials from source code
// Delete comments with actual user credentials
```

### 2. Code Quality Improvements

**Add Testing:**
```bash
# Install testing frameworks
npm install --save-dev @vue/test-utils jest

# Create test files
src/components/__tests__/
src/pages/__tests__/
```

**Error Handling:**
```javascript
// Improve error handling in API calls
try {
  const response = await axios.get(endpoint)
  return response.data
} catch (error) {
  // Show user-friendly error message
  this.$q.notify({
    type: 'negative',
    message: 'Помилка завантаження даних'
  })
  // Log for debugging
  console.error('API Error:', error)
}
```

### 3. Performance Optimizations

**Lazy Loading:**
```javascript
// Already implemented for routes ✓
// Consider for large components
const HeavyComponent = () => import('./components/HeavyComponent')
```

**API Call Optimization:**
```javascript
// Use Promise.all for parallel requests
const [summary, orders, tickets] = await Promise.all([
  axios.get(epSummOfPeriod, params),
  axios.get(epAllOrders, params),
  axios.get(epAllTickets, params)
])
```

### 4. Development Workflow

**Add Scripts to package.json:**
```json
{
  "scripts": {
    "dev": "quasar dev",
    "build": "quasar build",
    "lint": "eslint --ext .js,.vue src",
    "lint:fix": "eslint --ext .js,.vue src --fix",
    "android": "quasar dev -m cordova -T android",
    "ios": "quasar dev -m cordova -T ios",
    "build:android": "quasar build -m cordova -T android",
    "build:ios": "quasar build -m cordova -T ios"
  }
}
```

### 5. Documentation

**Add JSDoc Comments:**
```javascript
/**
 * Fetches user statistics for a given date range
 * @param {string} dateFrom - Start date in ISO format
 * @param {string} dateTo - End date in ISO format
 * @returns {Promise<Object>} Statistics data
 */
async function fetchStatistics(dateFrom, dateTo) {
  // ...
}
```

### 6. Upgrade Path

**Future Considerations:**
- Upgrade to Quasar v2 (Vue 3)
- Migrate to Capacitor (more modern than Cordova)
- Add TypeScript for better type safety
- Implement PWA features
- Add offline support with service workers

---

## Quick Start Commands

```bash
# 1. Clone and setup
cd "/Users/Bohdan_Chupa/Desktop/Personal/FORK/Додаток орга/org-mobile-app"
npm install

# 2. Start development server
quasar dev

# 3. Test login with credentials (if available)
# Navigate to http://localhost:8080
# Use credentials provided by backend team

# 4. Build for production
quasar build

# 5. Test on Android
quasar dev -m cordova -T android

# 6. Build Android APK
quasar build -m cordova -T android
```

---

## Environment Notes

**Current Configuration:**
- API: Test environment (z.test.soldout.com.ua)
- Language: Ukrainian (UK)
- App ID: com.soldoutstatistics.app
- Version: 0.0.3
- Orientation: Portrait (locked)

**To switch to production:**
1. Edit `src/api/endpoints.js`
2. Uncomment production URL
3. Comment test URL
4. Rebuild app

---

## Support & Resources

**Quasar Framework:**
- Docs: https://quasar.dev
- CLI: https://quasar.dev/quasar-cli/installation

**Cordova:**
- Docs: https://cordova.apache.org/docs/en/latest/

**Vue.js 2:**
- Docs: https://v2.vuejs.org

**Vuex:**
- Docs: https://v3.vuex.vuejs.org

---

*Document generated: December 2025*
*Last updated: Analysis of current codebase structure*

