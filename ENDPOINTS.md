# API Endpoints Documentation

## Base URL
- **TEST**: `https://z.test.soldout.com.ua`
- **PROD**: `https://z.soldout.com.ua`
- **Path prefix**: `/main-service`

---

## All Endpoints

### 1. Authentication Endpoints

#### `epToken`
- **URL**: `/main-service/oauth/token`
- **Method**: POST
- **Used in**: `src/store/module/actions.js`
- **Purpose**: OAuth 2.0 token authentication
- **Returns**: Access token
- **Price related**: ❌ No

#### `epLogin`
- **URL**: `/main-service/user/get`
- **Method**: GET
- **Used in**: `src/store/module/actions.js`
- **Purpose**: Get user information after authentication
- **Returns**: User data (firstName, lastName, mail, phone, logined)
- **Price related**: ❌ No

---

### 2. Dashboard (Entry Screen) Endpoints

#### `epSummOfPeriod`
- **URL**: `/main-service/api/find-sum-by-organizator`
- **Method**: GET
- **Used in**: `src/pages/Entry.vue`
- **Purpose**: Get total sum statistics for organizer for a period
- **Params**: `dateFrom`, `dateTo`
- **Returns**: Sum data for dashboard
- **Price related**: ✅ Yes (sums/money)

#### `epAllOrders`
- **URL**: `/main-service/api/find-orders-by-organizator`
- **Method**: GET
- **Used in**: `src/pages/Entry.vue`
- **Purpose**: Get all orders count for organizer
- **Params**: `dateFrom`, `dateTo`
- **Returns**: `{ allOrderCount: number }`
- **Price related**: ❌ No

#### `epAllTickets`
- **URL**: `/main-service/api/find-tickets-by-organizator-short`
- **Method**: GET
- **Used in**: `src/pages/Entry.vue`
- **Purpose**: Get all tickets count for organizer
- **Params**: `dateFrom`, `dateTo`
- **Returns**: `{ allTicketCount: number }`
- **Price related**: ❌ No

#### `epStatisticInEntryScreen`
- **URL**: `/main-service/api/find-events-by-organizator-main-short-info`
- **Method**: GET
- **Used in**: `src/pages/Entry.vue`
- **Purpose**: Get statistics for entry screen charts
- **Params**: `dateFrom`
- **Returns**: Event statistics data for charts
- **Price related**: ✅ Yes (may contain price/sum data)

---

### 3. Events List Endpoints

#### `epEvents`
- **URL**: `/main-service/api/find-bought-events-by-organizator`
- **Method**: GET
- **Used in**: `src/pages/ListOfEvents.vue`
- **Purpose**: Get list of events for organizer
- **Params**: `dateFrom`, `dateTo`
- **Returns**: Array of events
- **Price related**: ⚠️ Possibly (events may contain price info)

#### `epEventsToday`
- **URL**: `/main-service/api/find-bought-events-and-info-by-organizator`
- **Method**: GET
- **Used in**: `src/pages/ListOfEvents.vue`
- **Purpose**: Get today's events with info
- **Params**: `dateFrom`, `dateTo`
- **Returns**: Array of today's events
- **Price related**: ⚠️ Possibly (events may contain price info)

#### `epEventsArchive`
- **URL**: `/main-service/api/find-archive-events-by-organizator`
- **Method**: GET
- **Used in**: `src/pages/ListOfEvents.vue`
- **Purpose**: Get archived events for organizer
- **Params**: `dateFrom`, `dateTo` (optional, with calendar filter)
- **Returns**: Array of archived events
- **Price related**: ⚠️ Possibly (events may contain price info)

---

### 4. Event Details Endpoints

#### `epEventInSum` ⭐ **PRICE RELATED**
- **URL**: `/main-service/api/find-sum-by-event`
- **Method**: GET
- **Used in**: `src/pages/EventDetails.vue` (multiple times)
- **Purpose**: Get sum/money statistics for a specific event
- **Params**: 
  - `eventId` (in URL path)
  - Optional: `dateFrom`, `dateTo` (for date filtering)
- **Returns**: 
  ```javascript
  {
    allTicketSum: number,           // Total sold tickets sum
    notSoldTicketSum: number,       // Not sold tickets sum
    offlineTicketSum: number,       // Offline sales sum
    onlineTicketSum: number,         // Online sales sum
    inviteTicketSum: number,         // Invitations sum
    bookedTicketSum: number,         // Reserved tickets sum
    hardLockedTicketSum: number      // Cash register sum
  }
  ```
- **Price related**: ✅ **YES** - All values are in money/sum format
- **Usage**: 
  - Main chart data (currentCurrency, totalCurrency)
  - Detail breakdown (offline, online, invitations, reserved, cash_register)
  - Chart points for "soldTicketsMoney"

#### `epEventInCount`
- **URL**: `/main-service/api/find-count-by-event`
- **Method**: GET
- **Used in**: `src/pages/EventDetails.vue`
- **Purpose**: Get ticket count statistics for a specific event
- **Params**: 
  - `eventId` (in URL path)
  - Optional: `dateFrom`, `dateTo` (for date filtering)
- **Returns**: 
  ```javascript
  {
    allTicketCount: number,         // Total tickets
    notSoldTicketCount: number,     // Not sold tickets
    allBoughtTicketCount: number,   // All bought tickets (for today)
    offlineTicketCount: number,     // Offline sales count
    onlineTicketCount: number,      // Online sales count
    inviteTicketCount: number,      // Invitations count
    bookedTicketCount: number,     // Reserved tickets count
    hardLockedTicketCount: number   // Cash register count
  }
  ```
- **Price related**: ❌ No (counts only)

#### `epEventDetailsTable` ⭐ **PRICE RELATED**
- **URL**: `/main-service/api/find-color-price-by-event`
- **Method**: GET
- **Used in**: `src/pages/EventDetails.vue`
- **Purpose**: Get ticket quota data with prices by color for event
- **Params**: `eventId` (in URL path)
- **Returns**: Array of objects with:
  ```javascript
  [
    {
      color: string,                // Color code (e.g., "#218b82") or "All_Tickets"
      price: number,                // ⭐ Ticket price
      availableTickets: number,      // Available tickets (quota)
      availableTicketsSum: number   // ⭐ Quota sum (availableTickets * price)
      // ... other fields
    }
  ]
  ```
- **Price related**: ✅ **YES** - Contains `price` and `availableTicketsSum`
- **Usage**: 
  - Fills quota data in "Додаткова інформація1" table
  - Maps prices by color: `quotaMap[color].price`
  - Calculates `quantityOfSum = availableTickets * price`

#### `epEventDetailsTableForDate` ⭐ **PRICE RELATED**
- **URL**: `/main-service/api/find-color-price-by-event-and-date`
- **Method**: GET
- **Used in**: `src/pages/EventDetails.vue`
- **Purpose**: Get ticket statistics with prices by color for event with date filter
- **Params**: 
  - `eventId` (in URL path)
  - Optional: `dateFrom`, `dateTo` (for date filtering)
- **Returns**: Array of objects with:
  ```javascript
  [
    {
      color: string,                // Color code or "All_Tickets"
      price: number,                // ⭐ Ticket price
      createdTickets: number,       // ⭐ QUOTA - Total created tickets (quota)
      createdTicketsSum: number,    // ⭐ QUOTA SUM - Total quota sum (createdTickets * price)
      availableTickets: number,     // ⭐ AVAILABLE - Available tickets for sale
      availableTicketsSum: number,  // ⭐ AVAILABLE SUM - Available tickets sum (availableTickets * price)
      inviteTickets: number,         // Invitations count
      inviteTicketsSum: number,      // ⭐ Invitations sum
      soldTickets: number,           // Sold tickets count
      soldTicketsSum: number,        // ⭐ Sold tickets sum
      bookedTickets: number,         // Reserved tickets count
      bookedTicketsSum: number       // ⭐ Reserved tickets sum
      // ... other fields (nominalTickets, returnedTickets, etc.)
    }
  ]
  ```
- **Price related**: ✅ **YES** - Contains multiple price/sum fields:
  - `price` - Ticket price
  - `createdTickets` - ⭐ **QUOTA** (total created tickets)
  - `createdTicketsSum` - ⭐ **QUOTA SUM** (quota in money)
  - `availableTickets` - ⭐ **AVAILABLE** (tickets available for sale)
  - `availableTicketsSum` - ⭐ **AVAILABLE SUM** (available tickets in money)
  - `inviteTicketsSum` - Invitations sum
  - `soldTicketsSum` - Sold tickets sum
  - `bookedTicketsSum` - Reserved tickets sum
- **Usage**: 
  - **Main source for "Додаткова інформація1" table**
  - Extracts `All_Tickets` element for "Всього" column
  - **"Квота"** row: uses `createdTickets` and `createdTicketsSum`
  - **"Доступно"** row: uses `availableTickets` and `availableTicketsSum`
  - **"Запрошення"** row: uses `inviteTickets` and `inviteTicketsSum`
  - **"Продано"** row: uses `soldTickets` and `soldTicketsSum`
  - **"Заброньовано"** row: uses `bookedTickets` and `bookedTicketsSum`

#### `epEventSoldShortInfo`
- **URL**: `/main-service/api/find-events-by-organizator-sold-short-info`
- **Method**: GET
- **Used in**: `src/pages/EventDetails.vue` (only for general events)
- **Purpose**: Get sold tickets info for chart (general events only)
- **Params**: `eventId` (in URL path)
- **Returns**: Array of objects with:
  ```javascript
  [
    {
      soldTicketsMoney: number  // ⭐ Money from sold tickets
    }
  ]
  ```
- **Price related**: ✅ Yes - Contains `soldTicketsMoney`
- **Usage**: Creates chart points for "Детально по днях" chart

---

## Summary: Price-Related Endpoints

### Primary Price Endpoints (used for displaying prices):

1. **`epEventDetailsTableForDate`** ⭐⭐⭐
   - **Main endpoint for "Додаткова інформація1" table**
   - Contains: `price`, `createdTickets`, `createdTicketsSum`, `availableTickets`, `availableTicketsSum`, `inviteTicketsSum`, `soldTicketsSum`, `bookedTicketsSum`
   - Used for: "Всього" column (from `All_Tickets` element) and individual ticket type columns
   - **"Квота"**: `createdTickets` / `createdTicketsSum`
   - **"Доступно"**: `availableTickets` / `availableTicketsSum`

2. **`epEventDetailsTable`** ⭐⭐
   - Contains: `price`, `availableTicketsSum`
   - Used for: Quota data (quantity and sum) in table

3. **`epEventInSum`** ⭐⭐
   - Contains: `allTicketSum`, `offlineTicketSum`, `onlineTicketSum`, `inviteTicketSum`, `bookedTicketSum`, `hardLockedTicketSum`
   - Used for: Main chart and detail breakdown (sums in money)

4. **`epEventSoldShortInfo`** ⭐
   - Contains: `soldTicketsMoney`
   - Used for: Chart points (general events only)

5. **`epSummOfPeriod`** ⭐
   - Used for: Dashboard statistics (sums)

6. **`epStatisticInEntryScreen`** ⚠️
   - May contain price/sum data for charts

---

## Endpoint Usage by Page

### Login Page
- `epToken` - Authentication
- `epLogin` - Get user info

### Entry (Dashboard) Page
- `epSummOfPeriod` - Total sum
- `epAllOrders` - Orders count
- `epAllTickets` - Tickets count
- `epStatisticInEntryScreen` - Chart statistics

### List of Events Page
- `epEvents` - General events list
- `epEventsToday` - Today's events
- `epEventsArchive` - Archived events

### Event Details Page
- `epEventInSum` - Sum statistics (multiple calls)
- `epEventInCount` - Count statistics
- `epEventDetailsTable` - Quota with prices
- `epEventDetailsTableForDate` - **Main table data with prices**
- `epEventSoldShortInfo` - Chart data (general events only)

---

## Notes

- All endpoints require Bearer token authentication: `Authorization: Bearer <token>`
- Date format: `YYYY-MM-DDTHH:mm:ss` (e.g., `2024-01-15T00:00:00`)
- `epEventDetailsTableForDate` is the **primary endpoint** for price display in "Додаткова інформація1" table
- The `All_Tickets` element from `epEventDetailsTableForDate` response is used for "Всього" column instead of calculating `totalOf()`

