import { createRouter, createWebHistory } from 'vue-router'
import { gtm } from '../plugins/gtm.js'
import {
  ensureAdminAuthInitialized,
  isSupabaseConfigured,
  requireDashboardSessionOrSignOut,
  session_ref,
  has_dashboard_access_ref,
  profile_role_ref
} from '@/composables/useAdminAuth'

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
  },
  {
    path: '/admin/login',
    name: 'admin-login',
    component: () => import('../pages/AdminLoginPage.vue'),
    meta: { title: 'Admin Dashboard' }
  },
  {
    path: '/admin/forgot-password',
    name: 'admin-forgot-password',
    component: () => import('../pages/AdminForgotPasswordPage.vue'),
    meta: { title: 'Lupa Kata Sandi' }
  },
  {
    path: '/admin/reset-password',
    name: 'admin-reset-password',
    component: () => import('../pages/AdminResetPasswordPage.vue'),
    meta: { title: 'Atur Ulang Kata Sandi' }
  },
  {
    path: '/admin',
    component: () => import('../layouts/AdminLayout.vue'),
    meta: { requiresAdminAuth: true, title: 'Admin' },
    children: [
      {
        path: '',
        name: 'admin-dashboard',
        component: () => import('../pages/AdminDashboardPage.vue'),
        meta: { title: 'Admin' }
      },
      {
        path: 'pengiriman',
        name: 'admin-shipments',
        component: () => import('../pages/AdminShipmentsPage.vue'),
        meta: { title: 'Pengiriman' }
      },
      {
        path: 'users',
        name: 'admin-users',
        component: () => import('../pages/AdminUsersPage.vue'),
        meta: { title: 'Pengguna', requiresRole: 'admin' }
      }
    ]
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

router.beforeEach(async (to, from, next) => {
  await ensureAdminAuthInitialized()

  const base_title = 'Mahadhika Logistik Indonesia'
  document.title = to.meta.title ? `${to.meta.title} - ${base_title}` : base_title

  const requires_admin_auth = to.matched.some((record) => record.meta.requiresAdminAuth === true)

  if (to.name === 'admin-login') {
    if (
      isSupabaseConfigured() &&
      session_ref.value &&
      has_dashboard_access_ref.value
    ) {
      next({ path: '/admin' })
      return
    }
    next()
    return
  }

  if (to.name === 'admin-forgot-password' || to.name === 'admin-reset-password') {
    next()
    return
  }

  if (requires_admin_auth) {
    if (!isSupabaseConfigured()) {
      next({ path: '/admin/login', query: { ...to.query, config: 'missing' } })
      return
    }
    if (!session_ref.value) {
      next({
        path: '/admin/login',
        ...(to.fullPath !== '/admin' ? { query: { redirect: to.fullPath } } : {})
      })
      return
    }
    const dashboard_guard = await requireDashboardSessionOrSignOut()
    if (dashboard_guard !== true) {
      const error_key =
        dashboard_guard === 'suspended' ? 'suspended' : 'no_dashboard'
      next({
        path: '/admin/login',
        query: {
          ...(to.fullPath !== '/admin' ? { redirect: to.fullPath } : {}),
          error: error_key
        }
      })
      return
    }
    const needs_admin_route = to.matched.some(
      (record) => record.meta.requiresRole === 'admin'
    )
    if (needs_admin_route && profile_role_ref.value !== 'admin') {
      next({
        path: '/admin',
        query: { error: 'admin_only' }
      })
      return
    }
  }

  next()
})

router.afterEach((to, from) => {
  const base_title = 'Mahadhika Logistik Indonesia'
  const pageTitle = to.meta.title ? `${to.meta.title} - ${base_title}` : base_title

  gtm.trackPageView(to.path, pageTitle)
})

export default router
