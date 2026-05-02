<script setup>
import { ref, inject } from 'vue'
import { supabase } from '@/lib/supabase'

// Inject GTM instance
const gtm = inject('gtm')

const form_data = ref({
  nama: '',
  email: '',
  telepon: '',
  perusahaan: '',
  pesan: ''
})

const is_loading = ref(false)
const is_success = ref(false)
const error_message = ref('')

const submitForm = async () => {
  is_loading.value = true
  is_success.value = false
  error_message.value = ''

  try {
    const { error } = await supabase
      .from('contacts')
      .insert([{
        nama: form_data.value.nama,
        email: form_data.value.email,
        telepon: form_data.value.telepon,
        perusahaan: form_data.value.perusahaan,
        pesan: form_data.value.pesan,
        status: 'new'
      }])

    if (error) throw error

    // Track successful form submission
    gtm.trackFormSubmission('contact_form', 'contact_inquiry')

    is_success.value = true
    form_data.value = {
      nama: '',
      email: '',
      telepon: '',
      perusahaan: '',
      pesan: ''
    }
  } catch (error) {
    error_message.value = error.message || 'Terjadi kesalahan. Silakan coba lagi.'
    console.error('Error submitting form:', error)
  } finally {
    is_loading.value = false
  }
}
</script>

<template>
  <form @submit.prevent="submitForm" class="space-y-6">
    <!-- Success Message -->
    <div v-if="is_success" class="bg-green-50 border border-green-200 text-green-800 rounded-lg p-4">
      <p class="font-medium">Terima kasih! Pesan Anda telah terkirim.</p>
      <p class="text-sm mt-1">Kami akan menghubungi Anda segera.</p>
    </div>

    <!-- Error Message -->
    <div v-if="error_message" class="bg-red-50 border border-red-200 text-red-800 rounded-lg p-4">
      <p class="font-medium">{{ error_message }}</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label for="nama" class="block text-sm font-medium text-gray-700 mb-2">
          Nama Lengkap <span class="text-red-500">*</span>
        </label>
        <input
          id="nama"
          v-model="form_data.nama"
          type="text"
          required
          class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
          placeholder="Nama Anda"
        >
      </div>

      <div>
        <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
          Email <span class="text-red-500">*</span>
        </label>
        <input
          id="email"
          v-model="form_data.email"
          type="email"
          required
          class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
          placeholder="email@example.com"
        >
      </div>

      <div>
        <label for="telepon" class="block text-sm font-medium text-gray-700 mb-2">
          Nomor Telepon
        </label>
        <input
          id="telepon"
          v-model="form_data.telepon"
          type="tel"
          class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
          placeholder="+62 812-3456-7890"
        >
      </div>

      <div>
        <label for="perusahaan" class="block text-sm font-medium text-gray-700 mb-2">
          Nama Perusahaan
        </label>
        <input
          id="perusahaan"
          v-model="form_data.perusahaan"
          type="text"
          class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
          placeholder="PT. Nama Perusahaan"
        >
      </div>
    </div>

    <div>
      <label for="pesan" class="block text-sm font-medium text-gray-700 mb-2">
        Pesan <span class="text-red-500">*</span>
      </label>
      <textarea
        id="pesan"
        v-model="form_data.pesan"
        required
        rows="5"
        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
        placeholder="Tulis pesan Anda di sini..."
      ></textarea>
    </div>

    <button
      type="submit"
      :disabled="is_loading"
      class="btn btn-primary w-full md:w-auto"
    >
      <span v-if="is_loading" class="flex items-center justify-center">
        <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        Mengirim...
      </span>
      <span v-else>Kirim Pesan</span>
    </button>
  </form>
</template>

