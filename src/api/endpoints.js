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
