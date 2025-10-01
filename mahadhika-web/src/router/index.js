import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('../pages/HomePage.vue'),
    meta: { title: 'Beranda' }
  },
  {
    path: '/tentang',
    name: 'about',
    component: () => import('../pages/AboutPage.vue'),
    meta: { title: 'Tentang Kami' }
  },
  {
    path: '/layanan',
    name: 'services',
    component: () => import('../pages/ServicesPage.vue'),
    meta: { title: 'Layanan' }
  },
  {
    path: '/roadmap',
    name: 'roadmap',
    component: () => import('../pages/RoadmapPage.vue'),
    meta: { title: 'Roadmap' }
  },
  {
    path: '/kontak',
    name: 'contact',
    component: () => import('../pages/ContactPage.vue'),
    meta: { title: 'Kontak' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0 }
    }
  }
})

router.beforeEach((to, from, next) => {
  const base_title = 'Mahadhika Logistik Indonesia'
  document.title = to.meta.title 
    ? `${to.meta.title} - ${base_title}` 
    : base_title
  next()
})

export default router

