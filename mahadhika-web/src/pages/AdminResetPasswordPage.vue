<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { getSupabase, isSupabaseConfigured } from '@/lib/supabaseClient'

const router = useRouter()

const password_input = ref('')
const password_confirm_input = ref('')
const submitting_ref = ref(false)
const error_message_ref = ref('')
const success_ref = ref(false)
const session_ready_ref = ref(false)
const invalid_link_ref = ref(false)

const update_password_timeout_ms = 60_000

/** @param {Promise<T>} promise @param {number} timeout_ms @returns {Promise<T>} */
function raceWithTimeout(promise, timeout_ms) {
  return new Promise((resolve, reject) => {
    const t = setTimeout(() => {
      reject(new Error('TIMEOUT'))
    }, timeout_ms)
    promise.then(
      (value) => {
        clearTimeout(t)
        resolve(value)
      },
      (err) => {
        clearTimeout(t)
        reject(err)
      }
    )
  })
}

let auth_subscription = null

onMounted(() => {
  const supabase = getSupabase()
  if (!supabase) {
    invalid_link_ref.value = true
    return
  }

  const { data } = supabase.auth.onAuthStateChange((event, session) => {
    if (event === 'INITIAL_SESSION' && session) {
      session_ready_ref.value = true
    }
    if (event === 'PASSWORD_RECOVERY') {
      session_ready_ref.value = true
    }
    if (event === 'SIGNED_IN' && session) {
      session_ready_ref.value = true
    }
  })
  auth_subscription = data.subscription

  supabase.auth.getSession().then(({ data: { session } }) => {
    if (session) {
      session_ready_ref.value = true
    } else {
      setTimeout(() => {
        if (!session_ready_ref.value) {
          invalid_link_ref.value = true
        }
      }, 3000)
    }
  })
})

onUnmounted(() => {
  auth_subscription?.unsubscribe()
  auth_subscription = null
})

const handleSubmit = async () => {
  error_message_ref.value = ''

  if (!password_input.value || password_input.value.length < 8) {
    error_message_ref.value = 'Kata sandi minimal 8 karakter.'
    return
  }

  if (password_input.value !== password_confirm_input.value) {
    error_message_ref.value = 'Konfirmasi kata sandi tidak cocok.'
    return
  }

  const supabase = getSupabase()
  if (!supabase) {
    error_message_ref.value = 'Konfigurasi Supabase belum lengkap. Hubungi pengelola sistem.'
    return
  }

  submitting_ref.value = true
  try {
    const result = await raceWithTimeout(
      supabase.auth.updateUser({
        password: password_input.value
      }),
      update_password_timeout_ms
    )
    const { error } = result

    if (error) {
      error_message_ref.value = error.message || 'Gagal memperbarui kata sandi. Coba lagi.'
      return
    }

    await supabase.auth.signOut()

    success_ref.value = true
    setTimeout(() => {
      router.replace('/admin/login')
    }, 3000)
  } catch (err) {
    if (err?.message === 'TIMEOUT') {
      error_message_ref.value =
        'Permintaan memakan waktu terlalu lama. Periksa koneksi internet dan coba lagi.'
      return
    }
    error_message_ref.value = 'Tidak dapat menjangkau server. Periksa koneksi internet Anda.'
  } finally {
    submitting_ref.value = false
  }
}
</script>

<template>
  <div
    class="min-h-screen bg-gradient-to-br from-primary-950 to-primary-800 flex flex-col items-center justify-center px-4 py-12"
  >
    <div class="w-full max-w-md">
      <div class="flex flex-col items-center mb-6">
        <img
          src="/logo.png"
          alt="Mahadhika Logistik"
          class="h-16 md:h-20 w-auto object-contain drop-shadow-md"
          @error="(e) => { e.target.style.display = 'none' }"
        />
        <h1 class="mt-5 text-2xl md:text-3xl font-bold text-white text-center">
          Atur Ulang Kata Sandi
        </h1>
      </div>
      <p class="text-sm text-gray-200 text-center mb-8">
        Buat kata sandi baru yang kuat untuk akun Anda.
      </p>

      <div
        v-if="invalid_link_ref"
        class="rounded-2xl bg-white shadow-xl border border-gray-100 p-6 md:p-8 text-center space-y-4"
      >
        <div class="flex justify-center">
          <div class="w-14 h-14 rounded-full bg-red-100 flex items-center justify-center">
            <svg
              class="w-7 h-7 text-red-600"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              viewBox="0 0 24 24"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </div>
        </div>
        <h2 class="text-lg font-semibold text-gray-900">Tautan tidak valid atau kedaluwarsa</h2>
        <p class="text-sm text-gray-600 leading-relaxed">
          Tautan reset kata sandi ini tidak valid atau sudah kedaluwarsa. Silakan minta tautan baru.
        </p>
        <RouterLink
          to="/admin/forgot-password"
          class="btn btn-primary w-full justify-center py-3 inline-flex mt-2"
        >
          Minta tautan baru
        </RouterLink>
      </div>

      <div
        v-else-if="success_ref"
        class="rounded-2xl bg-white shadow-xl border border-gray-100 p-6 md:p-8 text-center space-y-4"
      >
        <div class="flex justify-center">
          <div class="w-14 h-14 rounded-full bg-green-100 flex items-center justify-center">
            <svg
              class="w-7 h-7 text-green-600"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              viewBox="0 0 24 24"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
            </svg>
          </div>
        </div>
        <h2 class="text-lg font-semibold text-gray-900">Kata sandi berhasil diperbarui!</h2>
        <p class="text-sm text-gray-600 leading-relaxed">
          Kata sandi Anda telah diperbarui. Anda akan diarahkan ke halaman masuk dalam beberapa detik.
        </p>
        <RouterLink
          to="/admin/login"
          class="btn btn-primary w-full justify-center py-3 inline-flex mt-2"
        >
          Masuk sekarang
        </RouterLink>
      </div>

      <div
        v-else-if="!session_ready_ref"
        class="rounded-2xl bg-white shadow-xl border border-gray-100 p-6 md:p-8 text-center"
      >
        <div class="flex justify-center mb-4">
          <svg
            class="w-8 h-8 text-primary-500 animate-spin"
            fill="none"
            viewBox="0 0 24 24"
          >
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
            <path
              class="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
            />
          </svg>
        </div>
        <p class="text-sm text-gray-600">Memverifikasi tautan reset…</p>
      </div>

      <form
        v-else
        class="rounded-2xl bg-white shadow-xl border border-gray-100 p-6 md:p-8 space-y-5"
        @submit.prevent="handleSubmit"
      >
        <div
          v-if="error_message_ref"
          class="rounded-lg bg-red-50 border border-red-200 px-3 py-2 text-sm text-red-800"
          role="alert"
        >
          {{ error_message_ref }}
        </div>

        <div>
          <label for="new-password" class="block text-sm font-medium text-gray-800 mb-1.5">
            Kata sandi baru
          </label>
          <input
            id="new-password"
            v-model="password_input"
            type="password"
            name="new-password"
            autocomplete="new-password"
            required
            minlength="8"
            class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-primary-500 text-gray-900 placeholder:text-gray-400"
            placeholder="••••••••"
          />
          <p class="mt-1.5 text-xs text-gray-500">Minimal 8 karakter.</p>
        </div>

        <div>
          <label for="confirm-password" class="block text-sm font-medium text-gray-800 mb-1.5">
            Konfirmasi kata sandi
          </label>
          <input
            id="confirm-password"
            v-model="password_confirm_input"
            type="password"
            name="confirm-password"
            autocomplete="new-password"
            required
            class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-primary-500 text-gray-900 placeholder:text-gray-400"
            placeholder="••••••••"
          />
        </div>

        <button
          type="submit"
          class="btn btn-primary w-full justify-center py-3 disabled:opacity-60 disabled:cursor-not-allowed"
          :disabled="submitting_ref || !isSupabaseConfigured()"
        >
          {{ submitting_ref ? 'Menyimpan…' : 'Simpan Kata Sandi Baru' }}
        </button>
      </form>

      <p class="mt-6 text-center text-sm text-gray-200">
        <RouterLink to="/admin/login" class="underline hover:text-white">
          Kembali ke halaman masuk
        </RouterLink>
      </p>
    </div>
  </div>
</template>
