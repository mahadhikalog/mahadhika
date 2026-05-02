<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, RouterLink } from 'vue-router'
import { getSupabase } from '@/lib/supabaseClient'
import { profile_role_ref } from '@/composables/useAdminAuth'

const route = useRoute()

const shipments_ref = ref([])
const loading_ref = ref(true)
const last_refreshed_ref = ref(null)

const ACTIVE_STATUSES = ['registered', 'processing', 'in_transit', 'on_delivery', 'picked_up']
const DONE_STATUSES = ['delivered', 'selesai', 'terkirim', 'completed']
const STALE_THRESHOLD_HOURS = 48
/** Selaras dengan default kolom shipments.origin_city */
const default_origin_city = 'Jakarta'

async function loadData() {
  loading_ref.value = true
  const supabase = getSupabase()
  if (!supabase) {
    loading_ref.value = false
    return
  }
  const { data } = await supabase
    .from('shipments')
    .select('id, tracking_number, current_status, origin_city, recipient_city, estimated_delivery_date, created_at, updated_at')
    .order('updated_at', { ascending: false })

  shipments_ref.value = data || []
  last_refreshed_ref.value = new Date()
  loading_ref.value = false
}

const total_count = computed(() => shipments_ref.value.length)

const active_count = computed(() =>
  shipments_ref.value.filter((s) => {
    const st = (s.current_status || '').toLowerCase()
    return !DONE_STATUSES.includes(st)
  }).length
)

const done_this_month_count = computed(() => {
  const now = new Date()
  return shipments_ref.value.filter((s) => {
    const st = (s.current_status || '').toLowerCase()
    if (!DONE_STATUSES.includes(st)) return false
    const updated = new Date(s.updated_at)
    return updated.getFullYear() === now.getFullYear() && updated.getMonth() === now.getMonth()
  }).length
})

const needs_action_count = computed(() => {
  const now = Date.now()
  return shipments_ref.value.filter((s) => {
    const st = (s.current_status || '').toLowerCase()
    if (DONE_STATUSES.includes(st)) return false
    const ms_diff = now - new Date(s.updated_at).getTime()
    const hours_diff = ms_diff / (1000 * 60 * 60)
    return hours_diff >= STALE_THRESHOLD_HOURS
  }).length
})

const status_distribution = computed(() => {
  if (!shipments_ref.value.length) return []
  const counts = {}
  for (const s of shipments_ref.value) {
    const st = s.current_status || 'unknown'
    counts[st] = (counts[st] || 0) + 1
  }
  const total = shipments_ref.value.length
  return Object.entries(counts)
    .sort((a, b) => b[1] - a[1])
    .map(([status, count]) => ({
      status,
      count,
      pct: Math.round((count / total) * 100)
    }))
})

const recent_shipments = computed(() => shipments_ref.value.slice(0, 8))

const status_color_map = {
  registered: 'bg-slate-400',
  processing: 'bg-blue-400',
  in_transit: 'bg-indigo-500',
  on_delivery: 'bg-amber-400',
  picked_up: 'bg-cyan-400',
  delivered: 'bg-emerald-500',
  selesai: 'bg-emerald-500',
  terkirim: 'bg-emerald-500',
  completed: 'bg-emerald-500',
}

function getStatusDot(status) {
  return status_color_map[(status || '').toLowerCase()] || 'bg-slate-300'
}

function getStatusBadgeClass(status) {
  const st = (status || '').toLowerCase()
  if (DONE_STATUSES.includes(st)) return 'bg-emerald-100 text-emerald-800'
  if (st === 'on_delivery') return 'bg-amber-100 text-amber-800'
  if (st === 'in_transit') return 'bg-indigo-100 text-indigo-800'
  if (st === 'processing') return 'bg-blue-100 text-blue-800'
  return 'bg-slate-100 text-slate-700'
}

function formatRelative(iso_raw) {
  if (!iso_raw) return '—'
  const diff_ms = Date.now() - new Date(iso_raw).getTime()
  const mins = Math.floor(diff_ms / 60000)
  if (mins < 1) return 'Baru saja'
  if (mins < 60) return `${mins} menit lalu`
  const hours = Math.floor(mins / 60)
  if (hours < 24) return `${hours} jam lalu`
  const days = Math.floor(hours / 24)
  return `${days} hari lalu`
}

function formatLastRefreshed(date) {
  if (!date) return '—'
  return date.toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })
}

onMounted(() => void loadData())
</script>

<template>
  <div class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8 lg:py-10">

    <!-- Access denied banner -->
    <div
      v-if="route.query.error === 'admin_only'"
      class="mb-6 rounded-2xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-950 shadow-sm"
      role="status"
    >
      Anda tidak memiliki izin akses administrator untuk halaman itu.
    </div>

    <!-- Page Header -->
    <div class="mb-7 flex flex-wrap items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold tracking-tight text-slate-950">
          Ringkasan Operasional
        </h1>
        <p class="mt-1 text-sm text-slate-500">
          <span class="capitalize">{{ profile_role_ref || 'user' }}</span>
          · Diperbarui
          <span v-if="loading_ref" class="text-slate-400">memuat…</span>
          <span v-else>{{ formatLastRefreshed(last_refreshed_ref) }}</span>
        </p>
      </div>
      <div class="flex items-center gap-3">
        <button
          type="button"
          class="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 shadow-sm transition hover:border-primary-200 hover:bg-primary-50 hover:text-primary-950 disabled:opacity-50"
          :disabled="loading_ref"
          @click="loadData"
        >
          <svg
            class="h-4 w-4 transition-transform"
            :class="{ 'animate-spin': loading_ref }"
            fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0 3.181 3.183a8.25 8.25 0 0 0 13.803-3.7M4.031 9.865a8.25 8.25 0 0 1 13.803-3.7l3.181 3.182m0-4.991v4.99" />
          </svg>
          Refresh
        </button>
        <RouterLink
          to="/admin/pengiriman"
          class="inline-flex items-center gap-2 rounded-xl bg-primary-950 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-primary-800"
        >
          <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 18.75a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 0 1-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 0 0-3.213-9.193 2.056 2.056 0 0 0-1.58-.86H14.25M16.5 18.75h-2.25m0-11.177v-.958c0-.568-.422-1.048-.987-1.106a48.554 48.554 0 0 0-10.026 0 1.106 1.106 0 0 0-.987 1.106v7.635m12-6.677v6.677m0 4.5v-4.5m0 0h-12" />
          </svg>
          Kelola Pengiriman
        </RouterLink>
      </div>
    </div>

    <!-- Metric Cards -->
    <section class="grid grid-cols-2 gap-4 lg:grid-cols-4">
      <!-- Total -->
      <article class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
        <div class="flex items-start justify-between gap-3">
          <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Total Kiriman</p>
          <span class="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-slate-100">
            <svg class="h-4 w-4 text-slate-600" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 12h16.5m-16.5 3.75h16.5M3.75 19.5h16.5M5.625 4.5h12.75a1.875 1.875 0 0 1 0 3.75H5.625a1.875 1.875 0 0 1 0-3.75Z" />
            </svg>
          </span>
        </div>
        <p class="mt-4 text-3xl font-bold tabular-nums text-slate-950">
          <span v-if="loading_ref" class="inline-block h-8 w-12 animate-pulse rounded-lg bg-slate-100" />
          <span v-else>{{ total_count }}</span>
        </p>
        <p class="mt-1 text-xs text-slate-400">Semua waktu</p>
      </article>

      <!-- Aktif -->
      <article class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
        <div class="flex items-start justify-between gap-3">
          <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Sedang Berjalan</p>
          <span class="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-blue-100">
            <svg class="h-4 w-4 text-blue-700" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 18.75a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 0 1-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 0 0-3.213-9.193 2.056 2.056 0 0 0-1.58-.86H14.25M16.5 18.75h-2.25m0-11.177v-.958c0-.568-.422-1.048-.987-1.106a48.554 48.554 0 0 0-10.026 0 1.106 1.106 0 0 0-.987 1.106v7.635m12-6.677v6.677m0 4.5v-4.5m0 0h-12" />
            </svg>
          </span>
        </div>
        <p class="mt-4 text-3xl font-bold tabular-nums text-slate-950">
          <span v-if="loading_ref" class="inline-block h-8 w-12 animate-pulse rounded-lg bg-slate-100" />
          <span v-else>{{ active_count }}</span>
        </p>
        <p class="mt-1 text-xs text-slate-400">Belum selesai</p>
      </article>

      <!-- Perlu Tindakan -->
      <article
        class="rounded-2xl border p-5 shadow-sm"
        :class="!loading_ref && needs_action_count > 0
          ? 'border-amber-200 bg-amber-50'
          : 'border-slate-200 bg-white'"
      >
        <div class="flex items-start justify-between gap-3">
          <p class="text-xs font-semibold uppercase tracking-wide"
            :class="!loading_ref && needs_action_count > 0 ? 'text-amber-700' : 'text-slate-500'">
            Perlu Tindakan
          </p>
          <span class="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl"
            :class="!loading_ref && needs_action_count > 0 ? 'bg-amber-100' : 'bg-slate-100'">
            <svg class="h-4 w-4"
              :class="!loading_ref && needs_action_count > 0 ? 'text-amber-700' : 'text-slate-500'"
              fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" />
            </svg>
          </span>
        </div>
        <p class="mt-4 text-3xl font-bold tabular-nums"
          :class="!loading_ref && needs_action_count > 0 ? 'text-amber-900' : 'text-slate-950'">
          <span v-if="loading_ref" class="inline-block h-8 w-12 animate-pulse rounded-lg bg-slate-100" />
          <span v-else>{{ needs_action_count }}</span>
        </p>
        <p class="mt-1 text-xs" :class="!loading_ref && needs_action_count > 0 ? 'text-amber-600' : 'text-slate-400'">
          Tidak update &gt;48 jam
        </p>
      </article>

      <!-- Selesai Bulan Ini -->
      <article class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
        <div class="flex items-start justify-between gap-3">
          <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Selesai Bulan Ini</p>
          <span class="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-emerald-100">
            <svg class="h-4 w-4 text-emerald-700" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
            </svg>
          </span>
        </div>
        <p class="mt-4 text-3xl font-bold tabular-nums text-slate-950">
          <span v-if="loading_ref" class="inline-block h-8 w-12 animate-pulse rounded-lg bg-slate-100" />
          <span v-else>{{ done_this_month_count }}</span>
        </p>
        <p class="mt-1 text-xs text-slate-400">Terkirim bulan berjalan</p>
      </article>
    </section>

    <!-- Body Grid -->
    <div class="mt-6 grid gap-6 lg:grid-cols-[1fr_1.4fr]">

      <!-- Status Distribution -->
      <section class="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
        <h2 class="text-sm font-semibold text-slate-950">Distribusi Status</h2>
        <p class="mt-0.5 text-xs text-slate-400">Berdasarkan status terakhir</p>

        <!-- Loading skeleton -->
        <div v-if="loading_ref" class="mt-5 space-y-4">
          <div v-for="i in 4" :key="i" class="space-y-1.5">
            <div class="h-3 w-1/2 animate-pulse rounded bg-slate-100" />
            <div class="h-2.5 w-full animate-pulse rounded-full bg-slate-100" />
          </div>
        </div>

        <!-- Empty state -->
        <div v-else-if="!status_distribution.length" class="mt-8 text-center text-sm text-slate-400">
          Belum ada data pengiriman.
        </div>

        <!-- Distribution bars -->
        <ul v-else class="mt-5 space-y-4">
          <li
            v-for="item in status_distribution"
            :key="item.status"
            class="space-y-1.5"
          >
            <div class="flex items-center justify-between gap-2">
              <div class="flex items-center gap-2 min-w-0">
                <span class="h-2 w-2 shrink-0 rounded-full" :class="getStatusDot(item.status)" />
                <span class="truncate text-sm font-medium text-slate-700">{{ item.status }}</span>
              </div>
              <span class="shrink-0 text-xs tabular-nums text-slate-500">
                {{ item.count }} <span class="text-slate-300">({{ item.pct }}%)</span>
              </span>
            </div>
            <div class="h-1.5 w-full overflow-hidden rounded-full bg-slate-100">
              <div
                class="h-full rounded-full transition-all duration-500"
                :class="getStatusDot(item.status)"
                :style="{ width: item.pct + '%' }"
              />
            </div>
          </li>
        </ul>

        <!-- Completion rate -->
        <div
          v-if="!loading_ref && total_count > 0"
          class="mt-6 rounded-xl bg-slate-50 px-4 py-3"
        >
          <div class="flex items-center justify-between">
            <span class="text-xs font-semibold text-slate-600">Tingkat Penyelesaian</span>
            <span class="text-sm font-bold text-slate-950">
              {{ Math.round((done_this_month_count / total_count) * 100) }}%
            </span>
          </div>
          <div class="mt-2 h-2 w-full overflow-hidden rounded-full bg-slate-200">
            <div
              class="h-full rounded-full bg-emerald-500 transition-all duration-700"
              :style="{ width: Math.round((done_this_month_count / total_count) * 100) + '%' }"
            />
          </div>
          <p class="mt-1.5 text-xs text-slate-400">{{ done_this_month_count }} dari {{ total_count }} kiriman selesai bulan ini</p>
        </div>
      </section>

      <!-- Recent Shipments -->
      <section class="rounded-2xl border border-slate-200 bg-white shadow-sm overflow-hidden">
        <div class="flex items-center justify-between border-b border-slate-100 px-6 py-4">
          <div>
            <h2 class="text-sm font-semibold text-slate-950">Aktivitas Terbaru</h2>
            <p class="mt-0.5 text-xs text-slate-400">8 kiriman terakhir diperbarui</p>
          </div>
          <RouterLink
            to="/admin/pengiriman"
            class="text-xs font-semibold text-primary-700 hover:text-primary-950"
          >
            Lihat semua →
          </RouterLink>
        </div>

        <!-- Loading -->
        <div v-if="loading_ref" class="divide-y divide-slate-100">
          <div
            v-for="i in 5"
            :key="i"
            class="flex items-center gap-4 px-6 py-4"
          >
            <div class="h-8 w-8 animate-pulse rounded-xl bg-slate-100 shrink-0" />
            <div class="flex-1 space-y-1.5">
              <div class="h-3 w-1/3 animate-pulse rounded bg-slate-100" />
              <div class="h-2.5 w-1/2 animate-pulse rounded bg-slate-50" />
            </div>
          </div>
        </div>

        <!-- Empty -->
        <div v-else-if="!recent_shipments.length" class="px-6 py-12 text-center text-sm text-slate-400">
          Belum ada data pengiriman.
        </div>

        <!-- Table -->
        <div v-else class="divide-y divide-slate-100">
          <RouterLink
            v-for="row in recent_shipments"
            :key="row.id"
            to="/admin/pengiriman"
            class="flex items-center gap-4 px-6 py-3.5 transition hover:bg-slate-50"
          >
            <span
              class="flex h-8 w-8 shrink-0 items-center justify-center rounded-xl text-xs font-bold"
              :class="DONE_STATUSES.includes((row.current_status || '').toLowerCase())
                ? 'bg-emerald-100 text-emerald-700'
                : needs_action_count > 0 && (Date.now() - new Date(row.updated_at).getTime()) > STALE_THRESHOLD_HOURS * 3600000 && !DONE_STATUSES.includes((row.current_status || '').toLowerCase())
                  ? 'bg-amber-100 text-amber-700'
                  : 'bg-slate-100 text-slate-600'"
            >
              <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
                <path
                  v-if="DONE_STATUSES.includes((row.current_status || '').toLowerCase())"
                  stroke-linecap="round" stroke-linejoin="round"
                  d="m4.5 12.75 6 6 9-13.5"
                />
                <path
                  v-else
                  stroke-linecap="round" stroke-linejoin="round"
                  d="M8.25 18.75a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 0 1-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 0 0-3.213-9.193 2.056 2.056 0 0 0-1.58-.86H14.25M16.5 18.75h-2.25m0-11.177v-.958c0-.568-.422-1.048-.987-1.106a48.554 48.554 0 0 0-10.026 0 1.106 1.106 0 0 0-.987 1.106v7.635m12-6.677v6.677m0 4.5v-4.5m0 0h-12"
                />
              </svg>
            </span>

            <div class="min-w-0 flex-1">
              <p class="truncate text-sm font-semibold text-slate-900 font-mono">
                {{ row.tracking_number }}
              </p>
              <p class="mt-0.5 text-xs text-slate-400">
                {{ row.origin_city || default_origin_city }}
                <template v-if="row.recipient_city">
                  → {{ row.recipient_city }}
                </template>
                <span> · </span>{{ formatRelative(row.updated_at) }}
              </p>
            </div>

            <span
              class="shrink-0 rounded-full px-2.5 py-1 text-xs font-semibold"
              :class="getStatusBadgeClass(row.current_status)"
            >
              {{ row.current_status || '—' }}
            </span>
          </RouterLink>
        </div>
      </section>
    </div>

  </div>
</template>
