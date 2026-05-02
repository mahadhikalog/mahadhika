<script setup>
import { ref } from 'vue'

const nomor_resi = ref('')
const pesan_error = ref('')
const tampil_contoh = ref(false)
const memuat_resi = ref(false)
/** Data dari RPC get_public_tracking (jsonb); null = belum ada / tidak ditemukan */
const data_pelacakan = ref(null)

import { isSupabaseConfigured } from '@/lib/supabaseClient'

const supabase_siap = isSupabaseConfigured()

/** Selaras dengan default kolom shipments.origin_city */
const default_origin_city = 'Jakarta'

/**
 * Contoh pemanggilan RPC publik (non-blocking untuk dev tanpa .env):
 * await getSupabase().rpc('get_public_tracking', { p_tracking_number: nomor_resi_trim })
 */
const handleTrack = async () => {
  pesan_error.value = ''
  data_pelacakan.value = null
  const nomor_resi_trim = nomor_resi.value.trim()
  if (!nomor_resi_trim) {
    pesan_error.value = 'Masukkan nomor resi terlebih dahulu.'
    return
  }

  if (supabase_siap) {
    memuat_resi.value = true
    try {
      const { getSupabase } = await import('@/lib/supabaseClient')
      const supabase = getSupabase()
      if (!supabase) {
        pesan_error.value =
          'Konfigurasi Supabase belum lengkap. Isi VITE_SUPABASE_URL dan VITE_SUPABASE_PUBLISHABLE_KEY atau VITE_SUPABASE_ANON_KEY di .env.'
        tampil_contoh.value = false
        return
      }
      const { data, error } = await supabase.rpc('get_public_tracking', {
        p_tracking_number: nomor_resi_trim
      })
      if (error) {
        pesan_error.value = error.message || 'Gagal memuat data pelacakan.'
        tampil_contoh.value = false
        return
      }
      if (!data) {
        pesan_error.value = 'Nomor resi tidak ditemukan.'
        tampil_contoh.value = false
        return
      }
      data_pelacakan.value = data
      tampil_contoh.value = true
    } catch (err) {
      pesan_error.value =
        err instanceof Error ? err.message : 'Gagal menghubungkan ke layanan pelacakan.'
      tampil_contoh.value = false
    } finally {
      memuat_resi.value = false
    }
    return
  }

  // Tanpa konfigurasi Supabase: pratinjau UI lama (contoh statis).
  tampil_contoh.value = true
}

const resetContoh = () => {
  tampil_contoh.value = false
  pesan_error.value = ''
  data_pelacakan.value = null
}

/** @param {string | null | undefined} iso */
function formatEventTime(iso) {
  if (!iso) return ''
  try {
    return new Date(iso).toLocaleString('id-ID', { dateStyle: 'medium', timeStyle: 'short' })
  } catch {
    return String(iso)
  }
}
</script>

<template>
  <section id="cek-resi" class="section bg-white border-t border-gray-100">
    <div class="container-custom">
      <div class="text-center mb-10 md:mb-12">
        <h2 class="section-title">Cek Resi Pengiriman</h2>
        <p class="section-subtitle !mb-0 max-w-3xl mx-auto">
          Lacak status kiriman Anda dengan nomor resi. Semua pengiriman dikelola oleh Mahadhika — tidak perlu memilih layanan ekspedisi.
        </p>
      </div>

      <div class="max-w-4xl mx-auto">
        <div class="bg-gray-50 rounded-2xl border border-gray-200 p-6 md:p-8 shadow-lg">
          <div class="flex flex-col sm:flex-row gap-4 sm:gap-6 sm:items-end">
            <div class="flex-1 space-y-2">
              <label for="nomor-resi" class="block text-sm font-medium text-gray-700">
                Nomor resi <span class="text-red-500">*</span>
              </label>
              <input
                id="nomor-resi"
                v-model="nomor_resi"
                type="text"
                name="nomor_resi"
                autocomplete="off"
                placeholder="Contoh: JO1234567890"
                class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-primary-500 text-gray-900 placeholder:text-gray-400"
                @keyup.enter="handleTrack"
              />
            </div>
            <div class="flex flex-col sm:flex-row gap-3 sm:flex-shrink-0">
              <button
                type="button"
                class="btn btn-primary whitespace-nowrap"
                :disabled="memuat_resi"
                @click="handleTrack"
              >
                {{ memuat_resi ? 'Memuat…' : 'Lacak' }}
              </button>
              <button
                v-if="tampil_contoh"
                type="button"
                class="btn btn-outline whitespace-nowrap"
                @click="resetContoh"
              >
                Sembunyikan pratinjau
              </button>
            </div>
          </div>

          <p v-if="pesan_error" class="mt-4 text-sm text-red-600 font-medium">
            {{ pesan_error }}
          </p>

          <p class="mt-4 text-sm text-gray-500 leading-relaxed">
            Nomor resi biasanya tertera di label paket, email konfirmasi pengiriman, atau halaman pesanan toko online Anda.
          </p>
        </div>

        <div class="mt-8 rounded-2xl border-2 border-dashed border-gray-300 bg-white p-6 md:p-8">
          <h3 class="text-lg font-bold text-primary-950 mb-2">
            Informasi pelacakan
          </h3>
          <p v-if="!tampil_contoh" class="text-sm text-gray-600 mb-6 leading-relaxed">
            Setelah integrasi ke sistem pelacakan, di sini akan ditampilkan
            <strong class="font-medium text-gray-800">status saat ini</strong>,
            <strong class="font-medium text-gray-800">kota asal dan tujuan</strong>,
            <strong class="font-medium text-gray-800">riwayat dan lokasi</strong>, serta
            <strong class="font-medium text-gray-800">estimasi tiba</strong> (jika tersedia).
            Klik <strong class="font-medium">Lacak</strong> untuk melihat contoh susunan tampilan.
          </p>
          <p
            v-else-if="tampil_contoh && !supabase_siap"
            class="text-xs text-amber-800 bg-amber-50 border border-amber-200 rounded-lg px-3 py-2 mb-6"
          >
            Contoh tampilan saja — bukan data pengiriman nyata.
          </p>

          <div class="grid gap-6 md:grid-cols-3 md:gap-4">
            <div class="rounded-xl bg-gray-50 border border-gray-200 p-4">
              <p class="text-xs font-semibold uppercase tracking-wide text-gray-500 mb-2">
                Status saat ini
              </p>
              <p v-if="!tampil_contoh" class="text-gray-400 text-sm italic">
                Akan tampil setelah pelacakan berhasil
              </p>
              <template v-else>
                <template v-if="supabase_siap && data_pelacakan">
                  <p class="text-gray-900 font-semibold">{{ data_pelacakan.current_status }}</p>
                  <p class="text-xs text-gray-500 mt-1">
                    Asal: {{ data_pelacakan.origin_city || default_origin_city }}<template v-if="data_pelacakan.recipient_city">
                      · Tujuan: {{ data_pelacakan.recipient_city }}
                    </template>
                  </p>
                  <p class="text-xs text-gray-500 mt-1">Nomor resi: {{ data_pelacakan.tracking_number }}</p>
                </template>
                <template v-else>
                  <p class="text-gray-900 font-semibold">Dalam perjalanan ke kota tujuan</p>
                  <p class="text-xs text-gray-500 mt-1">
                    Contoh — Asal: Jakarta · Tujuan: Surabaya
                  </p>
                  <p class="text-xs text-gray-500 mt-1">Nomor resi: {{ nomor_resi.trim() }}</p>
                </template>
              </template>
            </div>
            <div class="rounded-xl bg-gray-50 border border-gray-200 p-4 md:col-span-2">
              <p class="text-xs font-semibold uppercase tracking-wide text-gray-500 mb-2">
                Estimasi tiba
              </p>
              <p v-if="!tampil_contoh" class="text-gray-400 text-sm italic">
                Diperkirakan setelah paket diproses oleh pengiriman Mahadhika
              </p>
              <p v-else-if="supabase_siap && data_pelacakan?.estimated_delivery_date" class="text-gray-900 font-medium">
                {{ data_pelacakan.estimated_delivery_date }}
              </p>
              <p v-else-if="tampil_contoh" class="text-gray-900 font-medium">
                <template v-if="supabase_siap && data_pelacakan && !data_pelacakan.estimated_delivery_date">
                  Belum tersedia
                </template>
                <template v-else>
                  Contoh: 2–4 hari kerja (tergantung rute)
                </template>
              </p>
            </div>
          </div>

          <div class="mt-6">
            <p class="text-xs font-semibold uppercase tracking-wide text-gray-500 mb-4">
              Riwayat &amp; lokasi
            </p>
            <ul class="space-y-0 border-l-2 border-primary-200 ml-2 pl-6">
              <li v-if="!tampil_contoh" class="relative pb-8">
                <span class="absolute -left-[1.125rem] top-1.5 w-3 h-3 rounded-full border-2 border-gray-300 bg-white" />
                <p class="text-sm text-gray-400 italic">Riwayat scan dan lokasi hub akan muncul di sini</p>
              </li>
              <template v-else-if="supabase_siap && data_pelacakan">
                <li v-if="!data_pelacakan.events?.length" class="relative pb-8 last:pb-0">
                  <span class="absolute -left-[1.125rem] top-1.5 w-3 h-3 rounded-full border-2 border-gray-300 bg-white" />
                  <p class="text-sm text-gray-600">Belum ada riwayat lokasi untuk resi ini.</p>
                </li>
                <template v-else>
                  <li
                    v-for="(ev, idx) in data_pelacakan.events"
                    :key="`${ev.status_label}-${ev.occurred_at}-${idx}`"
                    class="relative pb-8 last:pb-0"
                  >
                    <span
                      class="absolute -left-[1.125rem] top-1.5 w-3 h-3 rounded-full ring-4"
                      :class="idx === 0 ? 'bg-primary-600 ring-primary-100' : 'bg-gray-300 ring-gray-100'"
                    />
                    <p class="text-sm font-medium text-gray-900">{{ ev.status_label }}</p>
                    <p class="text-xs text-gray-500 mt-1">
                      <span v-if="ev.location">{{ ev.location }} · </span>{{ formatEventTime(ev.occurred_at) }}
                    </p>
                  </li>
                </template>
              </template>
              <template v-else>
                <li class="relative pb-8 last:pb-0">
                  <span class="absolute -left-[1.125rem] top-1.5 w-3 h-3 rounded-full bg-primary-600 ring-4 ring-primary-100" />
                  <p class="text-sm font-medium text-gray-900">Paket tiba di hub distribusi utama</p>
                  <p class="text-xs text-gray-500 mt-1">Contoh — Jakarta, 29 Apr 2026 · 08:20</p>
                </li>
                <li class="relative pb-8 last:pb-0">
                  <span class="absolute -left-[1.125rem] top-1.5 w-3 h-3 rounded-full bg-gray-300 ring-4 ring-gray-100" />
                  <p class="text-sm font-medium text-gray-800">Paket sedang transit antar kota</p>
                  <p class="text-xs text-gray-500 mt-1">Contoh — 28 Apr 2026 · 21:05</p>
                </li>
                <li class="relative pb-0">
                  <span class="absolute -left-[1.125rem] top-1.5 w-3 h-3 rounded-full bg-gray-300 ring-4 ring-gray-100" />
                  <p class="text-sm font-medium text-gray-800">Paket diterima di gerai asal</p>
                  <p class="text-xs text-gray-500 mt-1">Contoh — 27 Apr 2026 · 14:40</p>
                </li>
              </template>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
