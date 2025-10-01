<script setup>
import ContactForm from '@/components/ContactForm.vue'

const contact_info = {
  address: 'Jalan Limo Raya No.108 A, Komplek Ruko Limo, Depok, Jawa Barat 16515',
  email: 'mahadhikalogistik@gmail.com',
  phones: [
    { name: 'Sos Hendra', number: '+62 821-6399-5688', link: 'tel:+6282163995688' },
    { name: 'Tareq', number: '+62 811-1180-1118', link: 'tel:+6281111801118' }
  ]
}
</script>

<template>
  <div>
    <!-- Hero -->
    <section class="bg-gradient-to-br from-primary-950 to-primary-800 text-white py-20">
      <div class="container-custom">
        <h1 class="text-4xl md:text-5xl font-bold mb-4">Hubungi Kami</h1>
        <p class="text-xl text-gray-200 max-w-3xl">
          Kami siap membantu kebutuhan logistik bisnis Anda
        </p>
      </div>
    </section>

    <!-- Contact Section -->
    <section class="section bg-white">
      <div class="container-custom">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
          <!-- Contact Info -->
          <div>
            <h2 class="text-3xl font-bold text-primary-950 mb-6">Informasi Kontak</h2>
            <div class="space-y-8">
              <!-- Address -->
              <div class="flex items-start">
                <div class="w-12 h-12 bg-primary-950 rounded-lg flex items-center justify-center mr-4 flex-shrink-0">
                  <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                  </svg>
                </div>
                <div>
                  <h3 class="font-semibold text-gray-900 mb-2">Head Office</h3>
                  <p class="text-gray-600">{{ contact_info.address }}</p>
                </div>
              </div>

              <!-- Email -->
              <div class="flex items-start">
                <div class="w-12 h-12 bg-primary-950 rounded-lg flex items-center justify-center mr-4 flex-shrink-0">
                  <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                  </svg>
                </div>
                <div>
                  <h3 class="font-semibold text-gray-900 mb-2">Email</h3>
                  <a 
                    :href="`mailto:${contact_info.email}`" 
                    class="text-primary-950 hover:text-primary-700 transition-colors duration-200"
                  >
                    {{ contact_info.email }}
                  </a>
                </div>
              </div>

              <!-- Phones -->
              <div class="flex items-start">
                <div class="w-12 h-12 bg-primary-950 rounded-lg flex items-center justify-center mr-4 flex-shrink-0">
                  <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                  </svg>
                </div>
                <div>
                  <h3 class="font-semibold text-gray-900 mb-2">Telepon</h3>
                  <div class="space-y-2">
                    <div v-for="phone in contact_info.phones" :key="phone.number">
                      <a 
                        :href="phone.link" 
                        class="text-primary-950 hover:text-primary-700 transition-colors duration-200 block"
                      >
                        {{ phone.number }}
                      </a>
                      <p class="text-sm text-gray-500">{{ phone.name }}</p>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Business Hours -->
              <div class="flex items-start">
                <div class="w-12 h-12 bg-primary-950 rounded-lg flex items-center justify-center mr-4 flex-shrink-0">
                  <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                  </svg>
                </div>
                <div>
                  <h3 class="font-semibold text-gray-900 mb-2">Jam Operasional</h3>
                  <p class="text-gray-600">Senin - Jumat: 08:00 - 17:00 WIB</p>
                  <p class="text-gray-600">Sabtu: 08:00 - 13:00 WIB</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Contact Form -->
          <div class="bg-gray-50 rounded-2xl p-8">
            <h2 class="text-3xl font-bold text-primary-950 mb-6">Kirim Pesan</h2>
            <ContactForm />
          </div>
        </div>
      </div>
    </section>

    <!-- Map Section -->
    <section class="section bg-gray-50">
      <div class="container-custom">
        <h2 class="section-title text-center mb-12">Lokasi Kami</h2>
        <div class="rounded-2xl overflow-hidden shadow-lg">
          <iframe
            src="https://www.google.com/maps?q=-6.363810,106.775627&hl=en&z=16&output=embed"
            width="100%"
            height="450"
            style="border:0;"
            allowfullscreen=""
            loading="lazy"
            referrerpolicy="no-referrer-when-downgrade"
            class="w-full"
          ></iframe>
        </div>
      </div>
    </section>
  </div>
</template>

