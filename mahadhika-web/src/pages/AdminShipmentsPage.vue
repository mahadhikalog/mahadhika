<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { getSupabase } from '@/lib/supabaseClient'
import { profile_role_ref, session_ref } from '@/composables/useAdminAuth'

const shipments_ref = ref([])
const events_ref = ref([])
const loading_list_ref = ref(true)
const loading_events_ref = ref(false)
const loading_action_ref = ref(false)
const error_message_ref = ref('')
const selected_id_ref = ref(null)

const search_query_ref = ref('')
const status_filter_ref = ref('')

const can_manage_shipments = computed(() => {
  const role = profile_role_ref.value
  return role === 'admin' || role === 'operator'
})

const selected_shipment = computed(() => {
  const id = selected_id_ref.value
  if (!id) {
    return null
  }
  return shipments_ref.value.find((row) => row.id === id) || null
})

/** Nilai bawaan kota asal (harus selaras dengan default di database) */
const default_origin_city = 'Jakarta'

/** Salinan field untuk form detail (operator/admin) */
const edit_tracking_number_ref = ref('')
const edit_current_status_ref = ref('')
const edit_recipient_city_ref = ref('')
const edit_origin_city_ref = ref('')
const edit_estimated_date_ref = ref('')
const edit_internal_notes_ref = ref('')

const show_create_panel_ref = ref(false)
const new_tracking_number_ref = ref('')
const new_current_status_ref = ref('registered')
const new_recipient_city_ref = ref('')
const new_origin_city_ref = ref(default_origin_city)
const new_estimated_date_ref = ref('')
const new_internal_notes_ref = ref('')

const event_status_label_ref = ref('')
const event_location_ref = ref('')
const event_occurred_at_ref = ref('')
const event_sync_main_status_ref = ref(true)

const unique_statuses = computed(() => {
  const set = new Set()
  for (const row of shipments_ref.value) {
    if (row.current_status) {
      set.add(row.current_status)
    }
  }
  return Array.from(set).sort()
})

const filtered_shipments = computed(() => {
  const q = search_query_ref.value.trim().toLowerCase()
  const status_sel = status_filter_ref.value
  return shipments_ref.value.filter((row) => {
    if (status_sel && row.current_status !== status_sel) {
      return false
    }
    if (!q) {
      return true
    }
    const tn = String(row.tracking_number || '').toLowerCase()
    const origin = String(row.origin_city || default_origin_city).toLowerCase()
    const dest = String(row.recipient_city || '').toLowerCase()
    return tn.includes(q) || origin.includes(q) || dest.includes(q)
  })
})

function syncEditFormFromRow(row) {
  if (!row) {
    edit_tracking_number_ref.value = ''
    edit_current_status_ref.value = ''
    edit_recipient_city_ref.value = ''
    edit_origin_city_ref.value = ''
    edit_estimated_date_ref.value = ''
    edit_internal_notes_ref.value = ''
    return
  }
  edit_tracking_number_ref.value = row.tracking_number || ''
  edit_current_status_ref.value = row.current_status || ''
  edit_recipient_city_ref.value = row.recipient_city || ''
  edit_origin_city_ref.value = row.origin_city || default_origin_city
  edit_estimated_date_ref.value = row.estimated_delivery_date
    ? String(row.estimated_delivery_date).slice(0, 10)
    : ''
  edit_internal_notes_ref.value = row.internal_notes || ''
}

watch(
  selected_shipment,
  (row) => {
    syncEditFormFromRow(row)
  },
  { immediate: true }
)

watch(selected_id_ref, () => {
  void loadEventsForSelection()
})

function formatDateTime(iso_raw) {
  if (!iso_raw) {
    return '—'
  }
  try {
    return new Date(iso_raw).toLocaleString('id-ID', {
      dateStyle: 'medium',
      timeStyle: 'short'
    })
  } catch {
    return String(iso_raw)
  }
}

function formatDateOnly(iso_raw) {
  if (!iso_raw) {
    return '—'
  }
  try {
    return new Date(iso_raw).toLocaleDateString('id-ID', { dateStyle: 'medium' })
  } catch {
    return String(iso_raw)
  }
}

async function loadShipments() {
  loading_list_ref.value = true
  error_message_ref.value = ''
  const supabase = getSupabase()
  if (!supabase) {
    error_message_ref.value =
      'Supabase tidak dikonfigurasi. Periksa berkas .env Anda.'
    shipments_ref.value = []
    loading_list_ref.value = false
    return
  }

  const { data, error } = await supabase
    .from('shipments')
    .select('*, created_by_profile:profiles!created_by(full_name), updated_by_profile:profiles!updated_by(full_name)')
    .order('updated_at', { ascending: false })

  loading_list_ref.value = false

  if (error) {
    error_message_ref.value = error.message || 'Gagal memuat daftar pengiriman.'
    shipments_ref.value = []
    return
  }

  shipments_ref.value = data || []

  if (
    selected_id_ref.value &&
    !shipments_ref.value.some((r) => r.id === selected_id_ref.value)
  ) {
    selected_id_ref.value = null
  }
}

async function loadEventsForSelection() {
  const shipment_id = selected_id_ref.value
  events_ref.value = []
  if (!shipment_id) {
    return
  }

  const supabase = getSupabase()
  if (!supabase) {
    return
  }

  loading_events_ref.value = true
  const { data, error } = await supabase
    .from('shipment_events')
    .select('*, created_by_profile:profiles!created_by(full_name)')
    .eq('shipment_id', shipment_id)
    .order('occurred_at', { ascending: false })

  loading_events_ref.value = false

  if (error) {
    error_message_ref.value = error.message || 'Gagal memuat riwayat event.'
    return
  }

  events_ref.value = data || []
}

function selectShipment(row) {
  selected_id_ref.value = row.id
}

async function submitUpdateShipment() {
  if (!can_manage_shipments.value) {
    return
  }
  const row = selected_shipment.value
  if (!row) {
    return
  }

  const supabase = getSupabase()
  if (!supabase) {
    return
  }

  loading_action_ref.value = true
  error_message_ref.value = ''

  const estimated =
    edit_estimated_date_ref.value && edit_estimated_date_ref.value.length > 0
      ? edit_estimated_date_ref.value
      : null

  const { data, error } = await supabase
    .from('shipments')
    .update({
      current_status: edit_current_status_ref.value.trim() || 'registered',
      recipient_city: edit_recipient_city_ref.value.trim() || null,
      origin_city: edit_origin_city_ref.value.trim() || default_origin_city,
      estimated_delivery_date: estimated,
      internal_notes: edit_internal_notes_ref.value.trim() || null,
      updated_at: new Date().toISOString(),
      updated_by: session_ref.value?.user?.id ?? null
    })
    .eq('id', row.id)
    .select('*, created_by_profile:profiles!created_by(full_name), updated_by_profile:profiles!updated_by(full_name)')
    .single()

  loading_action_ref.value = false

  if (error) {
    error_message_ref.value = error.message || 'Gagal menyimpan pengiriman.'
    return
  }

  shipments_ref.value = shipments_ref.value.map((r) =>
    r.id === row.id ? data : r
  )
  syncEditFormFromRow(data)
}

async function submitCreateShipment() {
  if (!can_manage_shipments.value) {
    return
  }

  const tn = new_tracking_number_ref.value.trim()
  if (!tn) {
    error_message_ref.value = 'Nomor resi wajib diisi.'
    return
  }

  const supabase = getSupabase()
  if (!supabase) {
    return
  }

  loading_action_ref.value = true
  error_message_ref.value = ''

  const estimated =
    new_estimated_date_ref.value && new_estimated_date_ref.value.length > 0
      ? new_estimated_date_ref.value
      : null

  const current_user_id = session_ref.value?.user?.id ?? null

  const { data, error } = await supabase
    .from('shipments')
    .insert({
      tracking_number: tn,
      current_status:
        new_current_status_ref.value.trim() || 'registered',
      recipient_city: new_recipient_city_ref.value.trim() || null,
      origin_city: new_origin_city_ref.value.trim() || default_origin_city,
      estimated_delivery_date: estimated,
      internal_notes: new_internal_notes_ref.value.trim() || null,
      created_by: current_user_id,
      updated_by: current_user_id
    })
    .select('*, created_by_profile:profiles!created_by(full_name), updated_by_profile:profiles!updated_by(full_name)')
    .single()

  loading_action_ref.value = false

  if (error) {
    error_message_ref.value =
      error.message || 'Gagal menambah pengiriman (periksa nomor resi unik).'
    return
  }

  shipments_ref.value = [data, ...shipments_ref.value]
  selected_id_ref.value = data.id
  show_create_panel_ref.value = false
  new_tracking_number_ref.value = ''
  new_current_status_ref.value = 'registered'
  new_recipient_city_ref.value = ''
  new_origin_city_ref.value = default_origin_city
  new_estimated_date_ref.value = ''
  new_internal_notes_ref.value = ''
}

async function submitAddEvent() {
  if (!can_manage_shipments.value) {
    return
  }
  const row = selected_shipment.value
  if (!row) {
    return
  }

  const label = event_status_label_ref.value.trim()
  if (!label) {
    error_message_ref.value = 'Label status event wajib diisi.'
    return
  }

  const supabase = getSupabase()
  if (!supabase) {
    return
  }

  let occurred_iso = new Date().toISOString()
  const raw_local = event_occurred_at_ref.value.trim()
  if (raw_local) {
    const parsed = new Date(raw_local)
    if (!Number.isNaN(parsed.getTime())) {
      occurred_iso = parsed.toISOString()
    }
  }

  loading_action_ref.value = true
  error_message_ref.value = ''

  const { error: err_insert } = await supabase.from('shipment_events').insert({
    shipment_id: row.id,
    status_label: label,
    location: event_location_ref.value.trim() || null,
    occurred_at: occurred_iso,
    created_by: session_ref.value?.user?.id ?? null
  })

  if (err_insert) {
    loading_action_ref.value = false
    error_message_ref.value = err_insert.message || 'Gagal menambah event.'
    return
  }

  if (event_sync_main_status_ref.value) {
    const { data: updated, error: err_upd } = await supabase
      .from('shipments')
      .update({
        current_status: label,
        updated_at: new Date().toISOString(),
        updated_by: session_ref.value?.user?.id ?? null
      })
      .eq('id', row.id)
      .select('*, created_by_profile:profiles!created_by(full_name), updated_by_profile:profiles!updated_by(full_name)')
      .single()

    if (err_upd) {
      loading_action_ref.value = false
      error_message_ref.value = err_upd.message || 'Event tersimpan namun status utama gagal diperbarui.'
      await loadShipments()
      await loadEventsForSelection()
      return
    }

    shipments_ref.value = shipments_ref.value.map((r) =>
      r.id === row.id ? updated : r
    )
    syncEditFormFromRow(updated)
  } else {
    await loadShipments()
  }

  await loadEventsForSelection()

  event_status_label_ref.value = ''
  event_location_ref.value = ''
  event_occurred_at_ref.value = ''
  event_sync_main_status_ref.value = true

  loading_action_ref.value = false
}

async function confirmDeleteEvent(ev, event_idx) {
  if (!can_manage_shipments.value) {
    return
  }
  const row = selected_shipment.value
  if (!row || ev.shipment_id !== row.id) {
    return
  }

  const ok = window.confirm(
    `Hapus event "${ev.status_label}" (${formatDateTime(ev.occurred_at)})?`
  )
  if (!ok) {
    return
  }

  const supabase = getSupabase()
  if (!supabase) {
    return
  }

  loading_action_ref.value = true
  error_message_ref.value = ''

  const { error } = await supabase
    .from('shipment_events')
    .delete()
    .eq('id', ev.id)
    .eq('shipment_id', row.id)

  loading_action_ref.value = false

  if (error) {
    error_message_ref.value = error.message || 'Gagal menghapus event.'
    return
  }

  await loadEventsForSelection()

  const deleted_was_newest = event_idx === 0
  if (deleted_was_newest && events_ref.value.length > 0) {
    const next_label = events_ref.value[0].status_label
    if (row.current_status !== next_label) {
      loading_action_ref.value = true
      const { data: updated, error: err_upd } = await supabase
        .from('shipments')
        .update({
          current_status: next_label,
          updated_at: new Date().toISOString()
        })
        .eq('id', row.id)
        .select('*')
        .single()
      loading_action_ref.value = false

      if (err_upd) {
        error_message_ref.value =
          err_upd.message ||
          'Event terhapus namun status utama gagal diselaraskan.'
        await loadShipments()
        return
      }

      shipments_ref.value = shipments_ref.value.map((r) =>
        r.id === row.id ? updated : r
      )
      syncEditFormFromRow(updated)
    }
  }
}

async function confirmDeleteShipment() {
  if (!can_manage_shipments.value) {
    return
  }
  const row = selected_shipment.value
  if (!row) {
    return
  }
  const ok = window.confirm(
    `Hapus pengiriman ${row.tracking_number}? Riwayat event ikut terhapus.`
  )
  if (!ok) {
    return
  }

  const supabase = getSupabase()
  if (!supabase) {
    return
  }

  loading_action_ref.value = true
  error_message_ref.value = ''

  const { error } = await supabase.from('shipments').delete().eq('id', row.id)

  loading_action_ref.value = false

  if (error) {
    error_message_ref.value = error.message || 'Gagal menghapus pengiriman.'
    return
  }

  shipments_ref.value = shipments_ref.value.filter((r) => r.id !== row.id)
  selected_id_ref.value = null
  events_ref.value = []
}

onMounted(() => {
  event_occurred_at_ref.value = ''
  void loadShipments()
})
</script>

<template>
  <div class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
    <div class="mb-8 flex flex-wrap items-end justify-between gap-4">
      <div>
        <h1 class="text-2xl font-semibold text-gray-900">
          Manajemen pengiriman
        </h1>
        <p class="mt-2 max-w-2xl text-sm text-gray-600">
          Kelola kiriman dan riwayat status yang tampil di Cek Resi publik. Peran
          <strong class="font-medium text-gray-800">viewer</strong> hanya dapat
          membaca.
        </p>
      </div>
      <button
        v-if="can_manage_shipments"
        type="button"
        class="rounded-xl border border-primary-200 bg-primary-50 px-4 py-2.5 text-sm font-semibold text-primary-950 transition hover:bg-primary-100"
        @click="show_create_panel_ref = !show_create_panel_ref"
      >
        {{
          show_create_panel_ref ? 'Tutup formulir tambah' : 'Tambah pengiriman'
        }}
      </button>
    </div>

    <div
      v-if="error_message_ref"
      class="mb-6 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800"
      role="alert"
    >
      {{ error_message_ref }}
    </div>

    <div
      v-if="can_manage_shipments && show_create_panel_ref"
      class="mb-8 rounded-xl border border-gray-200 bg-white p-5 shadow-sm"
    >
      <h2 class="text-lg font-semibold text-gray-900">
        Kiriman baru
      </h2>
      <p class="mt-1 text-sm text-gray-600">
        Nomor resi harus unik di seluruh sistem.
      </p>
      <form
        class="mt-5 grid gap-4 sm:grid-cols-2 lg:grid-cols-3"
        @submit.prevent="submitCreateShipment"
      >
        <div>
          <label
            class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
            for="new-tracking"
          >Nomor resi</label>
          <input
            id="new-tracking"
            v-model="new_tracking_number_ref"
            type="text"
            autocomplete="off"
            required
            class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
            placeholder="Contoh: JO1234567890"
          >
        </div>
        <div>
          <label
            class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
            for="new-status"
          >Status saat ini</label>
          <input
            id="new-status"
            v-model="new_current_status_ref"
            type="text"
            class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
            placeholder="registered"
          >
        </div>
        <div>
          <label
            class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
            for="new-origin-city"
          >Kota asal</label>
          <input
            id="new-origin-city"
            v-model="new_origin_city_ref"
            type="text"
            autocomplete="off"
            required
            class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
            placeholder="Jakarta"
          >
        </div>
        <div>
          <label
            class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
            for="new-city"
          >Kota tujuan</label>
          <input
            id="new-city"
            v-model="new_recipient_city_ref"
            type="text"
            autocomplete="off"
            class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
          >
        </div>
        <div>
          <label
            class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
            for="new-eta"
          >Estimasi tiba (tanggal)</label>
          <input
            id="new-eta"
            v-model="new_estimated_date_ref"
            type="date"
            class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
          >
        </div>
        <div class="sm:col-span-2 lg:col-span-3">
          <label
            class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
            for="new-notes"
          >Catatan internal</label>
          <textarea
            id="new-notes"
            v-model="new_internal_notes_ref"
            rows="2"
            class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
          />
        </div>
        <div class="sm:col-span-2 lg:col-span-3">
          <button
            type="submit"
            class="btn btn-primary px-5 py-2.5 disabled:cursor-not-allowed disabled:opacity-60"
            :disabled="loading_action_ref"
          >
            {{ loading_action_ref ? 'Menyimpan…' : 'Simpan kiriman baru' }}
          </button>
        </div>
      </form>
    </div>

    <div class="mb-5 flex flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-end">
      <div class="flex-1 min-w-[12rem]">
        <label
          class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
          for="filter-search"
        >Cari nomor resi</label>
        <input
          id="filter-search"
          v-model="search_query_ref"
          type="search"
          autocomplete="off"
          class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
          placeholder="Nomor resi, kota asal, atau kota tujuan…"
        >
      </div>
      <div class="w-full sm:w-56">
        <label
          class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
          for="filter-status"
        >Status (dari data)</label>
        <select
          id="filter-status"
          v-model="status_filter_ref"
          class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
        >
          <option value="">
            Semua
          </option>
          <option
            v-for="st in unique_statuses"
            :key="st"
            :value="st"
          >
            {{ st }}
          </option>
        </select>
      </div>
    </div>

    <div class="grid gap-6 lg:grid-cols-[minmax(0,1fr)_minmax(0,1.1fr)]">
      <section class="rounded-xl border border-gray-200 bg-white shadow-sm overflow-hidden">
        <div
          v-if="loading_list_ref"
          class="px-4 py-10 text-center text-sm text-gray-500"
        >
          Memuat pengiriman…
        </div>
        <div
          v-else-if="!shipments_ref.length"
          class="px-4 py-10 text-center text-sm text-gray-500"
        >
          Belum ada data pengiriman.
        </div>
        <div v-else-if="!filtered_shipments.length" class="px-4 py-10 text-center text-sm text-gray-500">
          Tidak ada hasil untuk filter ini.
        </div>
        <div v-else class="max-h-[70vh] overflow-y-auto">
          <table class="min-w-full divide-y divide-gray-200 text-sm">
            <thead class="sticky top-0 bg-gray-50 z-10">
              <tr>
                <th class="text-left px-4 py-3 font-semibold text-gray-700">
                  Resi
                </th>
                <th class="text-left px-4 py-3 font-semibold text-gray-700">
                  Status
                </th>
                <th class="hidden sm:table-cell text-left px-4 py-3 font-semibold text-gray-700">
                  Diperbarui
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr
                v-for="row in filtered_shipments"
                :key="row.id"
                class="cursor-pointer hover:bg-gray-50/80"
                :class="selected_id_ref === row.id ? 'bg-primary-50/80' : ''"
                @click="selectShipment(row)"
              >
                <td class="px-4 py-3 text-gray-900">
                  <span class="font-mono text-xs">{{ row.tracking_number }}</span>
                  <p class="mt-0.5 text-xs font-normal text-gray-500">
                    <span>{{ row.origin_city || default_origin_city }}</span>
                    <template v-if="row.recipient_city">
                      → {{ row.recipient_city }}
                    </template>
                  </p>
                </td>
                <td class="px-4 py-3 text-gray-800">
                  {{ row.current_status }}
                </td>
                <td class="hidden sm:table-cell px-4 py-3 text-gray-600 whitespace-nowrap">
                  {{ formatDateTime(row.updated_at) }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>

      <section class="rounded-xl border border-gray-200 bg-white p-5 shadow-sm min-h-[280px]">
        <template v-if="!selected_shipment">
          <p class="text-sm text-gray-500">
            Pilih sebuah baris di daftar untuk melihat detail dan riwayat.
          </p>
        </template>
        <template v-else>
          <div class="flex flex-wrap items-start justify-between gap-3">
            <div>
              <p class="text-xs font-semibold uppercase tracking-wide text-primary-700">
                Detail kiriman
              </p>
              <h2 class="mt-1 text-xl font-bold text-gray-900 font-mono">
                {{ selected_shipment.tracking_number }}
              </h2>
              <p class="mt-1 text-xs text-gray-500">
                Dibuat {{ formatDateTime(selected_shipment.created_at) }}
                <template v-if="selected_shipment.created_by_profile?.full_name">
                  oleh <span class="font-medium text-gray-700">{{ selected_shipment.created_by_profile.full_name }}</span>
                </template>
                · Diperbarui {{ formatDateTime(selected_shipment.updated_at) }}
                <template v-if="selected_shipment.updated_by_profile?.full_name">
                  oleh <span class="font-medium text-gray-700">{{ selected_shipment.updated_by_profile.full_name }}</span>
                </template>
              </p>
            </div>
            <button
              v-if="can_manage_shipments"
              type="button"
              class="text-sm font-semibold text-red-700 underline hover:text-red-900"
              :disabled="loading_action_ref"
              @click="confirmDeleteShipment"
            >
              Hapus kiriman
            </button>
          </div>

          <div
            v-if="can_manage_shipments"
            class="mt-6 grid gap-4 sm:grid-cols-2"
          >
            <div class="sm:col-span-2">
              <label
                class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
              >Nomor resi</label>
              <input
                type="text"
                :value="edit_tracking_number_ref"
                disabled
                class="mt-1 w-full cursor-not-allowed rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-gray-600"
              >
            </div>
            <div>
              <label
                class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
              >Status saat ini</label>
              <input
                v-model="edit_current_status_ref"
                type="text"
                class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
              >
            </div>
            <div>
              <label
                class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
              >Kota asal</label>
              <input
                v-model="edit_origin_city_ref"
                type="text"
                required
                class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
                placeholder="Jakarta"
              >
            </div>
            <div>
              <label
                class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
              >Kota tujuan</label>
              <input
                v-model="edit_recipient_city_ref"
                type="text"
                class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
              >
            </div>
            <div>
              <label
                class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
              >Estimasi tiba</label>
              <input
                v-model="edit_estimated_date_ref"
                type="date"
                class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
              >
            </div>
            <div class="sm:col-span-2">
              <label
                class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
              >Catatan internal</label>
              <textarea
                v-model="edit_internal_notes_ref"
                rows="2"
                class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
              />
            </div>
            <div class="sm:col-span-2">
              <button
                type="button"
                class="btn btn-primary px-5 py-2.5 disabled:cursor-not-allowed disabled:opacity-60"
                :disabled="loading_action_ref"
                @click="submitUpdateShipment"
              >
                {{ loading_action_ref ? 'Menyimpan…' : 'Simpan perubahan' }}
              </button>
            </div>
          </div>

          <dl
            v-else
            class="mt-6 grid gap-3 sm:grid-cols-2 text-sm"
          >
            <div>
              <dt class="text-xs font-semibold uppercase tracking-wide text-gray-500">
                Status
              </dt>
              <dd class="mt-1 font-medium text-gray-900">
                {{ selected_shipment.current_status }}
              </dd>
            </div>
            <div>
              <dt class="text-xs font-semibold uppercase tracking-wide text-gray-500">
                Kota asal
              </dt>
              <dd class="mt-1 text-gray-800">
                {{ selected_shipment.origin_city || default_origin_city }}
              </dd>
            </div>
            <div>
              <dt class="text-xs font-semibold uppercase tracking-wide text-gray-500">
                Kota tujuan
              </dt>
              <dd class="mt-1 text-gray-800">
                {{ selected_shipment.recipient_city || '—' }}
              </dd>
            </div>
            <div>
              <dt class="text-xs font-semibold uppercase tracking-wide text-gray-500">
                Estimasi tiba
              </dt>
              <dd class="mt-1 text-gray-800">
                {{
                  selected_shipment.estimated_delivery_date
                    ? formatDateOnly(selected_shipment.estimated_delivery_date)
                    : '—'
                }}
              </dd>
            </div>
            <div class="sm:col-span-2">
              <dt class="text-xs font-semibold uppercase tracking-wide text-gray-500">
                Catatan internal
              </dt>
              <dd class="mt-1 text-gray-800 whitespace-pre-wrap">
                {{ selected_shipment.internal_notes || '—' }}
              </dd>
            </div>
          </dl>

          <div class="mt-8 border-t border-gray-100 pt-6">
            <p class="text-xs font-semibold uppercase tracking-wide text-gray-600">
              Riwayat event
            </p>
            <div
              v-if="loading_events_ref"
              class="mt-3 text-sm text-gray-500"
            >
              Memuat riwayat…
            </div>
            <ul
              v-else-if="events_ref.length"
              class="mt-4 space-y-0 border-l-2 border-primary-200 ml-2 pl-5"
            >
              <li
                v-for="(ev, idx) in events_ref"
                :key="ev.id"
                class="relative pb-6 last:pb-0"
              >
                <span
                  class="absolute -left-[1.125rem] top-1.5 h-3 w-3 rounded-full ring-4"
                  :class="idx === 0 ? 'bg-primary-600 ring-primary-100' : 'bg-gray-300 ring-gray-100'"
                />
                <div
                  class="flex flex-wrap items-start justify-between gap-2"
                >
                  <p class="text-sm font-medium text-gray-900">
                    {{ ev.status_label }}
                  </p>
                  <button
                    v-if="can_manage_shipments"
                    type="button"
                    class="shrink-0 text-xs font-semibold text-red-700 underline-offset-2 hover:text-red-900 hover:underline disabled:cursor-not-allowed disabled:opacity-60"
                    :disabled="loading_action_ref"
                    @click="confirmDeleteEvent(ev, idx)"
                  >
                    Hapus
                  </button>
                </div>
                <p class="text-xs text-gray-500 mt-1">
                  <span v-if="ev.location">{{ ev.location }} · </span>{{ formatDateTime(ev.occurred_at) }}
                  <template v-if="ev.created_by_profile?.full_name">
                    · oleh <span class="font-medium">{{ ev.created_by_profile.full_name }}</span>
                  </template>
                </p>
              </li>
            </ul>
            <p
              v-else
              class="mt-3 text-sm text-gray-500"
            >
              Belum ada event untuk kiriman ini.
            </p>
          </div>

          <div
            v-if="can_manage_shipments"
            class="mt-8 rounded-xl border border-dashed border-gray-200 bg-gray-50/80 p-4"
          >
            <p class="text-sm font-semibold text-gray-900">
              Tambah event
            </p>
            <p class="mt-1 text-xs text-gray-600">
              Event baru akan muncul di timeline Cek Resi. Waktu kosong = sekarang.
            </p>
            <form
              class="mt-4 grid gap-3 sm:grid-cols-2"
              @submit.prevent="submitAddEvent"
            >
              <div class="sm:col-span-2">
                <label
                  class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
                >Label status</label>
                <input
                  v-model="event_status_label_ref"
                  type="text"
                  required
                  class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
                  placeholder="Contoh: Tiba di hub Jakarta"
                >
              </div>
              <div>
                <label
                  class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
                >Lokasi</label>
                <input
                  v-model="event_location_ref"
                  type="text"
                  class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
                  placeholder="Opsional"
                >
              </div>
              <div>
                <label
                  class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
                >Waktu kejadian</label>
                <input
                  v-model="event_occurred_at_ref"
                  type="datetime-local"
                  class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
                >
              </div>
              <div class="sm:col-span-2 flex items-center gap-2">
                <input
                  id="sync-main"
                  v-model="event_sync_main_status_ref"
                  type="checkbox"
                  class="h-4 w-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                >
                <label
                  for="sync-main"
                  class="text-sm text-gray-700"
                >Samakan ke status utama kiriman</label>
              </div>
              <div class="sm:col-span-2">
                <button
                  type="submit"
                  class="btn btn-outline px-5 py-2.5 disabled:cursor-not-allowed disabled:opacity-60"
                  :disabled="loading_action_ref"
                >
                  {{ loading_action_ref ? 'Menyimpan…' : 'Tambah event' }}
                </button>
              </div>
            </form>
          </div>
        </template>
      </section>
    </div>
  </div>
</template>
