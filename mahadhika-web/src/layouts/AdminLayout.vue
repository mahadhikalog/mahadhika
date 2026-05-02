<script setup>
import { ref, watch, onMounted, onBeforeUnmount } from 'vue'
import { RouterLink, RouterView, useRouter, useRoute } from 'vue-router'
import {
  signOutAdmin,
  is_admin_role_ref,
  profile_role_ref
} from '@/composables/useAdminAuth'

const router = useRouter()
const route = useRoute()

const is_desktop_collapsed = ref(false)
const is_mobile_drawer_open = ref(false)

async function handleLogout() {
  is_mobile_drawer_open.value = false
  await signOutAdmin()
  router.push({ path: '/admin/login' })
}

function onKeydown(e) {
  if (e.key === 'Escape') is_mobile_drawer_open.value = false
}

onMounted(() => document.addEventListener('keydown', onKeydown))
onBeforeUnmount(() => document.removeEventListener('keydown', onKeydown))

watch(() => route.path, () => {
  is_mobile_drawer_open.value = false
})
</script>

<template>
  <div class="min-h-screen bg-slate-50 text-slate-900 lg:flex">

    <!-- ─── Desktop: sidebar re-open tab ─── -->
    <button
      v-show="is_desktop_collapsed"
      type="button"
      class="fixed left-0 top-1/2 z-50 hidden -translate-y-1/2 items-center justify-center rounded-r-xl border border-l-0 border-slate-200 bg-white px-1.5 py-4 shadow-md transition hover:bg-primary-50 lg:flex"
      aria-label="Buka sidebar"
      @click="is_desktop_collapsed = false"
    >
      <svg class="h-4 w-4 text-slate-500" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
      </svg>
    </button>

    <!-- ─── Desktop Sidebar ─── -->
    <aside
      :class="[
        'fixed inset-y-0 left-0 z-40 hidden w-72 flex-col border-r border-slate-200 bg-white px-5 py-6 shadow-sm transition-transform duration-300 ease-in-out lg:flex',
        is_desktop_collapsed ? '-translate-x-full' : 'translate-x-0'
      ]"
    >
      <div class="flex items-start justify-between gap-2">
        <RouterLink to="/admin" class="group flex items-center gap-3" aria-label="Beranda">
          <span class="grid h-11 w-11 shrink-0 place-items-center rounded-2xl bg-primary-950 text-sm font-bold text-white shadow-sm shadow-primary-950/20">ML</span>
          <span>
            <span class="block text-xs font-semibold uppercase tracking-[0.22em] text-slate-500">Mahadhika</span>
            <span class="block text-lg font-bold text-primary-950 group-hover:text-primary-800">Panel Operasional</span>
          </span>
        </RouterLink>
        <button
          type="button"
          class="mt-0.5 shrink-0 rounded-xl p-1.5 text-slate-400 transition hover:bg-slate-100 hover:text-slate-700 focus:outline-none focus-visible:ring-2 focus-visible:ring-primary-500"
          aria-label="Sembunyikan sidebar"
          @click="is_desktop_collapsed = true"
        >
          <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
          </svg>
        </button>
      </div>

      <div class="mt-8 rounded-3xl border border-primary-100 bg-primary-50 p-4">
        <p class="text-xs font-semibold uppercase tracking-[0.18em] text-primary-700">Sesi aktif</p>
        <div class="mt-3 flex items-center justify-between gap-3">
          <div>
            <p class="text-sm font-semibold text-primary-950">Dashboard Internal</p>
            <p class="mt-0.5 text-xs text-primary-700">Akses operasional Mahadhika</p>
          </div>
          <span class="rounded-full bg-emerald-100 px-3 py-1 text-xs font-bold uppercase tracking-wide text-emerald-700">
            {{ profile_role_ref || 'user' }}
          </span>
        </div>
      </div>

      <nav class="mt-8 space-y-1" aria-label="Navigasi admin">
        <RouterLink
          to="/admin"
          class="group flex items-center gap-3 rounded-2xl px-4 py-3 text-sm font-semibold text-slate-900 transition hover:bg-primary-100 hover:!text-primary-950"
          exact-active-class="bg-primary-950 !text-white shadow-sm shadow-primary-950/20 hover:!bg-primary-800 hover:!text-white"
        >
          <span class="flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-slate-100 text-slate-700 transition group-hover:bg-primary-200 group-hover:text-primary-950 group-[.router-link-exact-active]:bg-white/20 group-[.router-link-exact-active]:text-white">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6A2.25 2.25 0 0 1 6 3.75h2.25A2.25 2.25 0 0 1 10.5 6v2.25a2.25 2.25 0 0 1-2.25 2.25H6a2.25 2.25 0 0 1-2.25-2.25V6ZM3.75 15.75A2.25 2.25 0 0 1 6 13.5h2.25a2.25 2.25 0 0 1 2.25 2.25V18a2.25 2.25 0 0 1-2.25 2.25H6A2.25 2.25 0 0 1 3.75 18v-2.25ZM13.5 6a2.25 2.25 0 0 1 2.25-2.25H18A2.25 2.25 0 0 1 20.25 6v2.25A2.25 2.25 0 0 1 18 10.5h-2.25a2.25 2.25 0 0 1-2.25-2.25V6ZM13.5 15.75a2.25 2.25 0 0 1 2.25-2.25H18a2.25 2.25 0 0 1 2.25 2.25V18A2.25 2.25 0 0 1 18 20.25h-2.25A2.25 2.25 0 0 1 13.5 18v-2.25Z" />
            </svg>
          </span>
          <div class="flex-1 min-w-0">
            <span class="block">Beranda</span>
            <span class="block truncate text-xs font-normal text-slate-500 group-[.router-link-exact-active]:text-white/60">Ringkasan & monitoring</span>
          </div>
        </RouterLink>

        <RouterLink
          to="/admin/pengiriman"
          class="group flex items-center gap-3 rounded-2xl px-4 py-3 text-sm font-semibold text-slate-900 transition hover:bg-primary-100 hover:!text-primary-950"
          active-class="bg-primary-950 !text-white shadow-sm shadow-primary-950/20 hover:!bg-primary-800 hover:!text-white"
        >
          <span class="flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-slate-100 text-slate-700 transition group-hover:bg-primary-200 group-hover:text-primary-950 group-[.router-link-active]:bg-white/20 group-[.router-link-active]:text-white">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 18.75a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 0 1-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 0 0-3.213-9.193 2.056 2.056 0 0 0-1.58-.86H14.25M16.5 18.75h-2.25m0-11.177v-.958c0-.568-.422-1.048-.987-1.106a48.554 48.554 0 0 0-10.026 0 1.106 1.106 0 0 0-.987 1.106v7.635m12-6.677v6.677m0 4.5v-4.5m0 0h-12" />
            </svg>
          </span>
          <div class="flex-1 min-w-0">
            <span class="block">Pengiriman</span>
            <span class="block truncate text-xs font-normal text-slate-500 group-[.router-link-active]:text-white/60">Kelola resi & status kiriman</span>
          </div>
        </RouterLink>

        <RouterLink
          v-if="is_admin_role_ref"
          to="/admin/users"
          class="group flex items-center gap-3 rounded-2xl px-4 py-3 text-sm font-semibold text-slate-900 transition hover:bg-primary-100 hover:!text-primary-950"
          active-class="bg-primary-950 !text-white shadow-sm shadow-primary-950/20 hover:!bg-primary-800 hover:!text-white"
        >
          <span class="flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-slate-100 text-slate-700 transition group-hover:bg-primary-200 group-hover:text-primary-950 group-[.router-link-active]:bg-white/20 group-[.router-link-active]:text-white">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15 19.128a9.38 9.38 0 0 0 2.625.372 9.337 9.337 0 0 0 4.121-.952 4.125 4.125 0 0 0-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 0 1 8.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0 1 11.964-3.07M12 6.375a3.375 3.375 0 1 1-6.75 0 3.375 3.375 0 0 1 6.75 0Zm8.25 2.25a2.625 2.625 0 1 1-5.25 0 2.625 2.625 0 0 1 5.25 0Z" />
            </svg>
          </span>
          <div class="flex-1 min-w-0">
            <span class="block">Pengguna</span>
            <span class="block truncate text-xs font-normal text-slate-500 group-[.router-link-active]:text-white/60">Atur akun & hak akses</span>
          </div>
        </RouterLink>
      </nav>

      <div class="mt-auto space-y-2">
        <RouterLink
          to="/"
          class="flex items-center gap-3 rounded-2xl border border-slate-200 px-4 py-3 text-sm font-semibold text-slate-700 transition hover:border-primary-200 hover:bg-primary-50 hover:text-primary-950"
        >
          <svg class="h-4 w-4 shrink-0 text-slate-400" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 6H5.25A2.25 2.25 0 0 0 3 8.25v10.5A2.25 2.25 0 0 0 5.25 21h10.5A2.25 2.25 0 0 0 18 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25" />
          </svg>
          Lihat situs publik
        </RouterLink>
        <button
          type="button"
          class="flex w-full items-center gap-3 rounded-2xl border border-slate-300 px-4 py-3 text-sm font-semibold text-slate-700 transition hover:border-primary-950 hover:bg-primary-950 hover:text-white focus:outline-none focus-visible:ring-2 focus-visible:ring-primary-500 focus-visible:ring-offset-2"
          @click="handleLogout"
        >
          <svg class="h-4 w-4 shrink-0" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 9V5.25A2.25 2.25 0 0 1 10.5 3h6a2.25 2.25 0 0 1 2.25 2.25v13.5A2.25 2.25 0 0 1 16.5 21h-6a2.25 2.25 0 0 1-2.25-2.25V15m-3 0-3-3m0 0 3-3m-3 3H15" />
          </svg>
          Keluar
        </button>
      </div>
    </aside>

    <!-- ─── Mobile: drawer backdrop ─── -->
    <Transition
      enter-active-class="transition-opacity duration-200"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition-opacity duration-200"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="is_mobile_drawer_open"
        class="fixed inset-0 z-40 bg-slate-950/40 backdrop-blur-sm lg:hidden"
        aria-hidden="true"
        @click="is_mobile_drawer_open = false"
      />
    </Transition>

    <!-- ─── Mobile: slide-in drawer ─── -->
    <Transition
      enter-active-class="transition-transform duration-300 ease-out"
      enter-from-class="-translate-x-full"
      enter-to-class="translate-x-0"
      leave-active-class="transition-transform duration-250 ease-in"
      leave-from-class="translate-x-0"
      leave-to-class="-translate-x-full"
    >
      <aside
        v-if="is_mobile_drawer_open"
        class="fixed inset-y-0 left-0 z-50 flex w-72 flex-col border-r border-slate-200 bg-white px-5 py-6 shadow-xl lg:hidden"
        aria-label="Menu navigasi"
      >
        <!-- Drawer header -->
        <div class="flex items-center justify-between">
          <RouterLink to="/admin" class="group flex items-center gap-3">
            <span class="grid h-10 w-10 shrink-0 place-items-center rounded-2xl bg-primary-950 text-sm font-bold text-white shadow-sm">ML</span>
            <span>
              <span class="block text-xs font-semibold uppercase tracking-[0.22em] text-slate-500">Mahadhika</span>
              <span class="block text-base font-bold text-primary-950 group-hover:text-primary-800">Panel Operasional</span>
            </span>
          </RouterLink>
          <button
            type="button"
            class="rounded-xl p-2 text-slate-400 transition hover:bg-slate-100 hover:text-slate-700 focus:outline-none focus-visible:ring-2 focus-visible:ring-primary-500"
            aria-label="Tutup menu"
            @click="is_mobile_drawer_open = false"
          >
            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <!-- Role chip -->
        <div class="mt-5 flex items-center gap-2 rounded-2xl bg-slate-50 px-4 py-3">
          <span class="h-2 w-2 rounded-full bg-emerald-500" />
          <span class="text-xs font-semibold text-slate-600">Masuk sebagai</span>
          <span class="ml-auto rounded-full bg-emerald-100 px-2.5 py-0.5 text-xs font-bold uppercase tracking-wide text-emerald-700">
            {{ profile_role_ref || 'user' }}
          </span>
        </div>

        <!-- Drawer nav -->
        <nav class="mt-6 space-y-1" aria-label="Navigasi mobile">
          <RouterLink
            to="/admin"
            class="group flex items-center gap-3 rounded-2xl px-4 py-3 text-sm font-semibold text-slate-900 transition hover:bg-primary-50"
            exact-active-class="bg-primary-950 !text-white shadow-sm hover:!bg-primary-800"
          >
            <span class="flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-slate-100 text-slate-600 group-[.router-link-exact-active]:bg-white/20 group-[.router-link-exact-active]:text-white">
              <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6A2.25 2.25 0 0 1 6 3.75h2.25A2.25 2.25 0 0 1 10.5 6v2.25a2.25 2.25 0 0 1-2.25 2.25H6a2.25 2.25 0 0 1-2.25-2.25V6ZM3.75 15.75A2.25 2.25 0 0 1 6 13.5h2.25a2.25 2.25 0 0 1 2.25 2.25V18a2.25 2.25 0 0 1-2.25 2.25H6A2.25 2.25 0 0 1 3.75 18v-2.25ZM13.5 6a2.25 2.25 0 0 1 2.25-2.25H18A2.25 2.25 0 0 1 20.25 6v2.25A2.25 2.25 0 0 1 18 10.5h-2.25a2.25 2.25 0 0 1-2.25-2.25V6ZM13.5 15.75a2.25 2.25 0 0 1 2.25-2.25H18a2.25 2.25 0 0 1 2.25 2.25V18A2.25 2.25 0 0 1 18 20.25h-2.25A2.25 2.25 0 0 1 13.5 18v-2.25Z" />
              </svg>
            </span>
            <div class="min-w-0 flex-1">
              <span class="block">Beranda</span>
              <span class="block text-xs font-normal text-slate-400 group-[.router-link-exact-active]:text-white/60">Ringkasan & monitoring</span>
            </div>
          </RouterLink>

          <RouterLink
            to="/admin/pengiriman"
            class="group flex items-center gap-3 rounded-2xl px-4 py-3 text-sm font-semibold text-slate-900 transition hover:bg-primary-50"
            active-class="bg-primary-950 !text-white shadow-sm hover:!bg-primary-800"
          >
            <span class="flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-slate-100 text-slate-600 group-[.router-link-active]:bg-white/20 group-[.router-link-active]:text-white">
              <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 18.75a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 0 1-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 0 0-3.213-9.193 2.056 2.056 0 0 0-1.58-.86H14.25M16.5 18.75h-2.25m0-11.177v-.958c0-.568-.422-1.048-.987-1.106a48.554 48.554 0 0 0-10.026 0 1.106 1.106 0 0 0-.987 1.106v7.635m12-6.677v6.677m0 4.5v-4.5m0 0h-12" />
              </svg>
            </span>
            <div class="min-w-0 flex-1">
              <span class="block">Pengiriman</span>
              <span class="block text-xs font-normal text-slate-400 group-[.router-link-active]:text-white/60">Kelola resi & status kiriman</span>
            </div>
          </RouterLink>

          <RouterLink
            v-if="is_admin_role_ref"
            to="/admin/users"
            class="group flex items-center gap-3 rounded-2xl px-4 py-3 text-sm font-semibold text-slate-900 transition hover:bg-primary-50"
            active-class="bg-primary-950 !text-white shadow-sm hover:!bg-primary-800"
          >
            <span class="flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-slate-100 text-slate-600 group-[.router-link-active]:bg-white/20 group-[.router-link-active]:text-white">
              <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15 19.128a9.38 9.38 0 0 0 2.625.372 9.337 9.337 0 0 0 4.121-.952 4.125 4.125 0 0 0-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 0 1 8.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0 1 11.964-3.07M12 6.375a3.375 3.375 0 1 1-6.75 0 3.375 3.375 0 0 1 6.75 0Zm8.25 2.25a2.625 2.625 0 1 1-5.25 0 2.625 2.625 0 0 1 5.25 0Z" />
              </svg>
            </span>
            <div class="min-w-0 flex-1">
              <span class="block">Pengguna</span>
              <span class="block text-xs font-normal text-slate-400 group-[.router-link-active]:text-white/60">Atur akun & hak akses</span>
            </div>
          </RouterLink>
        </nav>

        <!-- Drawer footer -->
        <div class="mt-auto space-y-2 border-t border-slate-100 pt-5">
          <RouterLink
            to="/"
            class="flex items-center gap-3 rounded-2xl border border-slate-200 px-4 py-3 text-sm font-semibold text-slate-700 transition hover:border-primary-200 hover:bg-primary-50 hover:text-primary-950"
          >
            <svg class="h-4 w-4 shrink-0 text-slate-400" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 6H5.25A2.25 2.25 0 0 0 3 8.25v10.5A2.25 2.25 0 0 0 5.25 21h10.5A2.25 2.25 0 0 0 18 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25" />
            </svg>
            Lihat situs publik
          </RouterLink>
          <button
            type="button"
            class="flex w-full items-center gap-3 rounded-2xl border border-slate-300 px-4 py-3 text-sm font-semibold text-slate-700 transition hover:border-primary-950 hover:bg-primary-950 hover:text-white focus:outline-none"
            @click="handleLogout"
          >
            <svg class="h-4 w-4 shrink-0" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 9V5.25A2.25 2.25 0 0 1 10.5 3h6a2.25 2.25 0 0 1 2.25 2.25v13.5A2.25 2.25 0 0 1 16.5 21h-6a2.25 2.25 0 0 1-2.25-2.25V15m-3 0-3-3m0 0 3-3m-3 3H15" />
            </svg>
            Keluar
          </button>
        </div>
      </aside>
    </Transition>

    <!-- ─── Main Content ─── -->
    <div
      :class="[
        'min-w-0 flex-1 transition-[padding] duration-300 ease-in-out',
        is_desktop_collapsed ? 'lg:pl-0' : 'lg:pl-72'
      ]"
    >
      <!-- Mobile Header — single compact bar -->
      <header class="sticky top-0 z-30 flex h-14 items-center border-b border-slate-200/80 bg-white/95 px-4 shadow-sm backdrop-blur lg:hidden">
        <!-- Hamburger -->
        <button
          type="button"
          class="mr-3 flex h-9 w-9 shrink-0 items-center justify-center rounded-xl text-slate-600 transition hover:bg-slate-100 focus:outline-none focus-visible:ring-2 focus-visible:ring-primary-500"
          aria-label="Buka menu navigasi"
          @click="is_mobile_drawer_open = true"
        >
          <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>

        <!-- Brand -->
        <RouterLink to="/admin" class="flex items-center gap-2.5">
          <span class="grid h-8 w-8 shrink-0 place-items-center rounded-xl bg-primary-950 text-xs font-bold text-white">ML</span>
          <span class="text-sm font-bold text-primary-950">Panel Operasional</span>
        </RouterLink>

        <!-- Right: role pill + (optional) current page indicator -->
        <div class="ml-auto flex items-center gap-2">
          <span class="rounded-full bg-slate-100 px-2.5 py-1 text-xs font-semibold capitalize text-slate-600">
            {{ profile_role_ref || 'user' }}
          </span>
        </div>
      </header>

      <main class="w-full">
        <RouterView />
      </main>
    </div>
  </div>
</template>
