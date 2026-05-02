<script setup>
import { ref } from 'vue'
import { RouterLink } from 'vue-router'
import { getSupabase, isSupabaseConfigured } from '@/lib/supabaseClient'

const email_input = ref('')
const submitting_ref = ref(false)
const error_message_ref = ref('')
const success_ref = ref(false)

const handleSubmit = async () => {
  error_message_ref.value = ''
  const email_trim = email_input.value.trim()

  if (!email_trim) {
    error_message_ref.value = 'Email wajib diisi.'
    return
  }

  const supabase = getSupabase()
  if (!supabase) {
    error_message_ref.value =
      'Konfigurasi Supabase belum lengkap. Hubungi pengelola sistem.'
    return
  }

  submitting_ref.value = true
  try {
    const redirect_to = `${window.location.origin}/admin/reset-password`
    const { error } = await supabase.auth.resetPasswordForEmail(email_trim, {
      redirectTo: redirect_to
    })

    if (error) {
      error_message_ref.value =
        error.message || 'Gagal mengirim email. Coba lagi beberapa saat.'
      return
    }

    success_ref.value = true
  } catch (err) {
    error_message_ref.value =
      'Tidak dapat menjangkau server. Periksa koneksi internet Anda.'
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
          Lupa Kata Sandi
        </h1>
      </div>
      <p class="text-sm text-gray-200 text-center mb-8">
        Masukkan email akun Anda dan kami akan mengirimkan tautan untuk mengatur ulang kata sandi.
      </p>

      <div
        v-if="success_ref"
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
        <h2 class="text-lg font-semibold text-gray-900">Email terkirim!</h2>
        <p class="text-sm text-gray-600 leading-relaxed">
          Tautan pengaturan ulang kata sandi telah dikirim ke
          <span class="font-medium text-gray-800">{{ email_input }}</span>.
          Periksa kotak masuk Anda (termasuk folder spam).
        </p>
        <RouterLink
          to="/admin/login"
          class="btn btn-primary w-full justify-center py-3 inline-flex mt-2"
        >
          Kembali ke halaman masuk
        </RouterLink>
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
          <label for="forgot-email" class="block text-sm font-medium text-gray-800 mb-1.5">
            Email
          </label>
          <input
            id="forgot-email"
            v-model="email_input"
            type="email"
            name="email"
            autocomplete="username"
            required
            class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-primary-500 text-gray-900 placeholder:text-gray-400"
            placeholder="nama@perusahaan.com"
          />
          <p class="mt-1.5 text-xs text-gray-500">
            Gunakan email yang terdaftar di akun Anda.
          </p>
        </div>

        <button
          type="submit"
          class="btn btn-primary w-full justify-center py-3 disabled:opacity-60 disabled:cursor-not-allowed"
          :disabled="submitting_ref || !isSupabaseConfigured()"
        >
          {{ submitting_ref ? 'Mengirim…' : 'Kirim Tautan Reset' }}
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
