<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import {
  ensureAdminAuthInitialized,
  isSupabaseConfigured,
  signInAdmin
} from '@/composables/useAdminAuth'

const router = useRouter()
const route = useRoute()

const email_input = ref('')
const password_input = ref('')
const submitting_ref = ref(false)
const error_message_ref = ref('')
const config_missing_ref = ref(false)

const redirect_safe = computed(() => {
  const raw = route.query.redirect
  if (typeof raw !== 'string' || !raw.startsWith('/') || raw.startsWith('//')) {
    return '/admin'
  }
  return raw
})

function syncQueryMessages() {
  if (route.query.config === 'missing') {
    config_missing_ref.value = true
    error_message_ref.value = ''
    return
  }
  config_missing_ref.value = false
  if (route.query.error === 'no_dashboard' || route.query.error === 'not_admin') {
    error_message_ref.value =
      'Akses ditolak: akun Anda tidak memiliki peran dashboard yang diizinkan (admin, operator, atau viewer). Hubungi pengelola sistem.'
    return
  }
  if (route.query.error === 'suspended') {
    error_message_ref.value =
      'Akun Anda ditangguhkan. Hubungi administrator jika Anda yakin ini kesalahan.'
    return
  }
  if (route.query.error === 'session') {
    error_message_ref.value = 'Sesi Anda telah berakhir. Silakan masuk kembali.'
    return
  }
  error_message_ref.value = ''
}

onMounted(async () => {
  await ensureAdminAuthInitialized()
  syncQueryMessages()
  if (!isSupabaseConfigured()) {
    config_missing_ref.value = true
  }
})

watch(
  () => route.query,
  () => {
    syncQueryMessages()
  }
)

const handleSubmit = async () => {
  error_message_ref.value = ''
  config_missing_ref.value = !isSupabaseConfigured()
  if (config_missing_ref.value) {
    return
  }

  const email_trim = email_input.value.trim()
  if (!email_trim || !password_input.value) {
    error_message_ref.value = 'Email dan kata sandi wajib diisi.'
    return
  }

  submitting_ref.value = true
  try {
    const result = await signInAdmin(email_trim, password_input.value)
    if (!result.ok) {
      error_message_ref.value = result.error_message || 'Gagal masuk.'
      return
    }
    await router.replace(redirect_safe.value)
  } finally {
    submitting_ref.value = false
  }
}
</script>

<template>
  <div class="min-h-screen bg-gradient-to-br from-primary-950 to-primary-800 flex flex-col items-center justify-center px-4 py-12">
    <div class="w-full max-w-md">
      <div class="flex flex-col items-center mb-6">
        <img
          src="/logo.png"
          alt="Mahadhika Logistik"
          class="h-16 md:h-20 w-auto object-contain drop-shadow-md"
          @error="(e) => { e.target.style.display = 'none' }"
        />
        <h1 class="mt-5 text-2xl md:text-3xl font-bold text-white text-center">
          Admin Dashboard
        </h1>
      </div>
      <p class="text-sm text-gray-200 text-center mb-8">
        Masuk dengan akun pengguna panel (viewer, operator, atau admin — sesuai penugasan).
      </p>

      <div
        v-if="config_missing_ref || !isSupabaseConfigured()"
        class="mb-6 rounded-xl border border-amber-300/80 bg-amber-50 px-4 py-3 text-sm text-amber-950"
        role="alert"
      >
        <p class="font-medium">
          Konfigurasi Supabase diperlukan
        </p>
        <p class="mt-1 leading-relaxed">
          Isi <code class="rounded bg-amber-100/80 px-1">VITE_SUPABASE_URL</code> dan
          <code class="rounded bg-amber-100/80 px-1">VITE_SUPABASE_PUBLISHABLE_KEY</code>
          (atau <code class="rounded bg-amber-100/80 px-1">VITE_SUPABASE_ANON_KEY</code> untuk kunci legacy), lalu mulai ulang server pengembangan.
        </p>
      </div>

      <form
        class="rounded-2xl bg-white shadow-xl border border-gray-100 p-6 md:p-8 space-y-5"
        @submit.prevent="handleSubmit"
      >
        <div v-if="error_message_ref" class="rounded-lg bg-red-50 border border-red-200 px-3 py-2 text-sm text-red-800" role="alert">
          {{ error_message_ref }}
        </div>

        <div>
          <label for="admin-email" class="block text-sm font-medium text-gray-800 mb-1.5">
            Email
          </label>
          <input
            id="admin-email"
            v-model="email_input"
            type="email"
            name="email"
            autocomplete="username"
            required
            class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-primary-500 text-gray-900 placeholder:text-gray-400"
            placeholder="nama@perusahaan.com"
          />
          <p class="mt-1.5 text-xs text-gray-500">
            Gunakan email yang terdaftar di Supabase Auth.
          </p>
        </div>

        <div>
          <div class="flex items-center justify-between mb-1.5">
            <label for="admin-password" class="block text-sm font-medium text-gray-800">
              Kata sandi
            </label>
            <RouterLink
              to="/admin/forgot-password"
              class="text-xs text-primary-600 hover:text-primary-700 hover:underline"
            >
              Lupa kata sandi?
            </RouterLink>
          </div>
          <input
            id="admin-password"
            v-model="password_input"
            type="password"
            name="password"
            autocomplete="current-password"
            required
            class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-primary-500 text-gray-900 placeholder:text-gray-400"
            placeholder="••••••••"
          />
          <p class="mt-1.5 text-xs text-gray-500">
            Kata sandi tidak dibagikan; pastikan koneksi Anda aman.
          </p>
        </div>

        <button
          type="submit"
          class="btn btn-primary w-full justify-center py-3 disabled:opacity-60 disabled:cursor-not-allowed"
          :disabled="submitting_ref || !isSupabaseConfigured()"
        >
          {{ submitting_ref ? 'Memproses…' : 'Masuk' }}
        </button>
      </form>

      <p class="mt-6 text-center text-sm text-gray-200">
        <RouterLink to="/" class="underline hover:text-white">
          Kembali ke beranda
        </RouterLink>
      </p>
    </div>
  </div>
</template>
