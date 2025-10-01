<script setup>
const roadmap_phases = [
  {
    year: 'Tahun 0-1',
    title: 'Fondasi & Validasi',
    items: [
      'Trucking FTL & LTL berbasis light asset',
      'Kemitraan awal FMCG & BUMN',
      'Sistem digital internal & operasional',
      'Validasi profit model berkelanjutan'
    ]
  },
  {
    year: 'Tahun 1-3',
    title: 'Ekspansi Layanan',
    items: [
      'Diversifikasi layanan LTL & retail-logistics',
      'Penetrasi contract & project logistics',
      'Penetrasi layanan software logistik (SaaS)'
    ]
  },
  {
    year: 'Tahun 3-5',
    title: 'Ekspansi Area',
    items: [
      'Scale up mitra jaringan nasional',
      'Replikasi contract & project logistics',
      'Ekspansi SaaS logistik',
      'Branding sebagai top-tier logistics provider'
    ]
  },
  {
    year: 'Tahun 5+',
    title: 'Leverage Business',
    items: [
      'Penetrasi e-commerce & marketplace',
      'Masuk ke ekosistem IT rantai pasok',
      'Validasi model bisnis & revenue'
    ]
  }
]
</script>

<template>
  <div>
    <!-- Hero -->
    <section class="bg-gradient-to-br from-primary-950 to-primary-800 text-white py-20">
      <div class="container-custom">
        <h1 class="text-4xl md:text-5xl font-bold mb-4">Roadmap Perusahaan</h1>
        <p class="text-xl text-gray-200 max-w-3xl">
          Perjalanan strategis menuju logistik modern dan berdaya saing global
        </p>
      </div>
    </section>

    <!-- Roadmap Timeline -->
    <section class="section bg-white">
      <div class="container-custom">
        <div class="max-w-5xl mx-auto">
          <!-- Desktop Timeline -->
          <div class="hidden md:block relative">
            <!-- Timeline Line -->
            <div class="absolute left-1/2 transform -translate-x-1/2 h-full w-1 bg-primary-200"></div>

            <!-- Timeline Items -->
            <div class="space-y-24">
              <div 
                v-for="(phase, index) in roadmap_phases" 
                :key="phase.year"
                class="relative"
              >
                <!-- Timeline Dot -->
                <div class="absolute left-1/2 transform -translate-x-1/2 -translate-y-4">
                  <div class="w-12 h-12 bg-primary-950 rounded-full border-4 border-white shadow-lg flex items-center justify-center">
                    <span class="text-white font-bold text-sm">{{ index + 1 }}</span>
                  </div>
                </div>

                <!-- Content -->
                <div class="grid grid-cols-2 gap-8">
                  <div :class="index % 2 === 0 ? 'text-right pr-16' : 'col-start-2 pl-16'">
                    <div class="inline-block bg-accent-950 text-white px-4 py-2 rounded-full text-sm font-semibold mb-3">
                      {{ phase.year }}
                    </div>
                    <h3 class="text-2xl font-bold text-primary-950 mb-4">{{ phase.title }}</h3>
                    <ul class="space-y-3">
                      <li 
                        v-for="item in phase.items" 
                        :key="item"
                        class="text-gray-700 flex items-start"
                        :class="index % 2 === 0 ? 'justify-end' : ''"
                      >
                        <svg 
                          class="w-5 h-5 text-accent-950 flex-shrink-0" 
                          :class="index % 2 === 0 ? 'order-2 ml-2' : 'mr-2'"
                          fill="none" 
                          stroke="currentColor" 
                          viewBox="0 0 24 24"
                        >
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                        </svg>
                        <span :class="index % 2 === 0 ? 'text-right' : ''">{{ item }}</span>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Mobile Timeline -->
          <div class="md:hidden space-y-8">
            <div 
              v-for="(phase, index) in roadmap_phases" 
              :key="phase.year"
              class="bg-gray-50 rounded-xl p-6 border-l-4 border-primary-950"
            >
              <div class="flex items-center mb-4">
                <div class="w-10 h-10 bg-primary-950 rounded-full flex items-center justify-center mr-4">
                  <span class="text-white font-bold">{{ index + 1 }}</span>
                </div>
                <div>
                  <div class="bg-accent-950 text-white px-3 py-1 rounded-full text-xs font-semibold inline-block mb-2">
                    {{ phase.year }}
                  </div>
                  <h3 class="text-xl font-bold text-primary-950">{{ phase.title }}</h3>
                </div>
              </div>
              <ul class="space-y-2 ml-14">
                <li 
                  v-for="item in phase.items" 
                  :key="item"
                  class="text-gray-700 flex items-start text-sm"
                >
                  <svg class="w-5 h-5 text-accent-950 mr-2 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                  </svg>
                  <span>{{ item }}</span>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Vision Statement -->
    <section class="section bg-gray-50">
      <div class="container-custom">
        <div class="max-w-4xl mx-auto text-center">
          <h2 class="section-title">Visi Jangka Panjang</h2>
          <p class="text-lg text-gray-700 leading-relaxed mb-8">
            Menjadi perusahaan logistik & rantai pasok nasional yang modern, inovatif, dan berdaya saing global dengan mengutamakan kualitas pelayanan serta kolaborasi nasional demi memajukan kepentingan bangsa.
          </p>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mt-12">
            <div class="bg-white rounded-lg p-6 shadow-md">
              <div class="w-16 h-16 bg-primary-950 rounded-full flex items-center justify-center mx-auto mb-4">
                <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                </svg>
              </div>
              <h3 class="font-bold text-primary-950 mb-2">Inovasi</h3>
              <p class="text-gray-600 text-sm">Terus berinovasi dalam teknologi dan layanan logistik</p>
            </div>
            <div class="bg-white rounded-lg p-6 shadow-md">
              <div class="w-16 h-16 bg-primary-950 rounded-full flex items-center justify-center mx-auto mb-4">
                <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
              </div>
              <h3 class="font-bold text-primary-950 mb-2">Ekspansi</h3>
              <p class="text-gray-600 text-sm">Memperluas jangkauan ke seluruh Indonesia</p>
            </div>
            <div class="bg-white rounded-lg p-6 shadow-md">
              <div class="w-16 h-16 bg-primary-950 rounded-full flex items-center justify-center mx-auto mb-4">
                <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
                </svg>
              </div>
              <h3 class="font-bold text-primary-950 mb-2">Kualitas</h3>
              <p class="text-gray-600 text-sm">Mempertahankan standar kualitas tertinggi</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="section bg-primary-950 text-white">
      <div class="container-custom">
        <div class="max-w-4xl mx-auto text-center">
          <h2 class="text-3xl md:text-4xl font-bold mb-6">
            Bergabunglah dalam Perjalanan Kami
          </h2>
          <p class="text-xl text-gray-200 mb-8">
            Mari bersama membangun masa depan logistik Indonesia yang lebih baik
          </p>
          <router-link to="/kontak" class="btn btn-accent">
            Hubungi Kami
          </router-link>
        </div>
      </div>
    </section>
  </div>
</template>

