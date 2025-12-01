
const routes = [
  {
    path: '/',
    component: () => import('layouts/Index.vue'),
    children: [
      {
        path: '',
        component: () => import('pages/Login.vue')
      },
      {
        path: '/entry',
        component: () => import('pages/Entry.vue')
      },
      {
        path: '/list-of-events/:listId',
        component: () => import('pages/ListOfEvents.vue')
      },
      {
        path: '/event/:eventId/:title/:city/:concertHall/:date/:time/:organisator/:isGeneral?/:isToday?',
        component: () => import('pages/EventDetails.vue')
      },
      {
        path: '/profile',
        component: () => import('pages/Profile.vue')
      }
    ]
  }
]

// Always leave this as last one
if (process.env.MODE !== 'ssr') {
  routes.push({
    path: '*',
    component: () => import('pages/Error404.vue')
  })
}

export default routes
