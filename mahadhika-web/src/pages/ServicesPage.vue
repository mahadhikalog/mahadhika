<script setup>
import ServiceCard from '@/components/ServiceCard.vue'
import SectorCard from '@/components/SectorCard.vue'

const services = [
  {
    title: 'Retail & Distribusi',
    description: 'Pengiriman berbasis kilogram ke seluruh Indonesia dengan jaringan yang luas dan terpercaya. Kami memastikan setiap paket tiba dengan aman dan tepat waktu.',
    icon: 'package',
    features: [
      'Pengiriman door-to-door',
      'Tracking real-time',
      'Jangkauan seluruh Indonesia',
      'Asuransi pengiriman'
    ]
  },
  {
    title: 'Solusi Logistik',
    description: 'Integrasi layanan logistik dan rantai pasok yang komprehensif untuk mendukung efisiensi operasional bisnis Anda.',
    icon: 'solution',
    features: [
      'Supply chain management',
      'Inventory optimization',
      'Last-mile delivery',
      'Konsultasi logistik'
    ]
  },
  {
    title: 'Transportasi',
    description: 'Moda transportasi darat, laut, dan udara yang andal & terpercaya untuk berbagai kebutuhan pengiriman Anda.',
    icon: 'truck',
    features: [
      'FTL & LTL trucking',
      'Pengiriman via laut',
      'Cargo udara',
      'Multi-modal transport'
    ]
  },
  {
    title: 'Pergudangan',
    description: 'Penyimpanan & pengelolaan stok sesuai kebutuhan dengan sistem manajemen gudang modern dan standar keamanan tinggi.',
    icon: 'warehouse',
    features: [
      'Warehouse management system',
      'Cold storage',
      'Pick & pack service',
      'Inventory management'
    ]
  }
]

const sectors = [
  {
    title: 'Teknologi & Telekomunikasi',
    description: 'Distribusi perangkat teknologi & infrastruktur telekomunikasi dengan handling khusus untuk barang elektronik'
  },
  {
    title: 'Energi & Pertambangan',
    description: 'Transportasi material kritis & logistik proyek besar dengan standar keselamatan tertinggi'
  },
  {
    title: 'Kesehatan & Farmasi',
    description: 'Distribusi sensitif dengan standar keamanan tinggi dan temperature controlled untuk produk medis'
  },
  {
    title: 'FMCG & Barang Konsumsi',
    description: 'Distribusi produk kebutuhan sehari-hari dengan jaringan distribusi yang efisien'
  },
  {
    title: 'E-Commerce & Ritel',
    description: 'Distribusi fleksibel dengan layanan konsisten untuk memenuhi kebutuhan e-commerce modern'
  },
  {
    title: 'Manufaktur & Industri',
    description: 'Dukungan logistik dari bahan baku hingga produk akhir untuk industri manufaktur'
  }
]
</script>

<template>
  <div>
    <!-- Hero -->
    <section class="bg-gradient-to-br from-primary-950 to-primary-800 text-white py-20">
      <div class="container-custom">
        <h1 class="text-4xl md:text-5xl font-bold mb-4">Layanan Kami</h1>
        <p class="text-xl text-gray-200 max-w-3xl">
          Solusi logistik terpadu untuk mendukung pertumbuhan bisnis Anda
        </p>
      </div>
    </section>

    <!-- Services Detail -->
    <section class="section bg-white">
      <div class="container-custom">
        <div class="space-y-16">
          <div 
            v-for="(service, index) in services" 
            :key="service.title"
            class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center"
            :class="index % 2 === 1 ? 'lg:flex-row-reverse' : ''"
          >
            <div :class="index % 2 === 1 ? 'lg:order-2' : ''">
              <h2 class="text-3xl font-bold text-primary-950 mb-4">{{ service.title }}</h2>
              <p class="text-gray-700 mb-6">{{ service.description }}</p>
              <ul class="space-y-3">
                <li 
                  v-for="feature in service.features" 
                  :key="feature"
                  class="flex items-center text-gray-700"
                >
                  <svg class="w-5 h-5 text-accent-950 mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                  </svg>
                  <span>{{ feature }}</span>
                </li>
              </ul>
            </div>
            <div :class="index % 2 === 1 ? 'lg:order-1' : ''">
              <div class="bg-gradient-to-br from-primary-950 to-primary-700 rounded-2xl h-80 flex items-center justify-center">
                <svg v-if="service.icon === 'truck'" class="w-32 h-32 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M13 16V6a1 1 0 00-1-1H4a1 1 0 00-1 1v10a1 1 0 001 1h1m8-1a1 1 0 01-1 1H9m4-1V8a1 1 0 011-1h2.586a1 1 0 01.707.293l3.414 3.414a1 1 0 01.293.707V16a1 1 0 01-1 1h-1m-6-1a1 1 0 001 1h1M5 17a2 2 0 104 0m-4 0a2 2 0 114 0m6 0a2 2 0 104 0m-4 0a2 2 0 114 0"/>
                </svg>
                <svg v-else-if="service.icon === 'package'" class="w-32 h-32 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
                </svg>
                <svg v-else-if="service.icon === 'warehouse'" class="w-32 h-32 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                </svg>
                <svg v-else class="w-32 h-32 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
                </svg>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Sectors -->
    <section class="section bg-gray-50">
      <div class="container-custom">
        <div class="text-center mb-12">
          <h2 class="section-title">Sektor Industri yang Kami Layani</h2>
          <p class="section-subtitle">
            Pengalaman melayani berbagai sektor industri dengan standar kualitas tertinggi
          </p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <SectorCard
            v-for="sector in sectors"
            :key="sector.title"
            :title="sector.title"
            :description="sector.description"
          />
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="section bg-primary-950 text-white">
      <div class="container-custom">
        <div class="max-w-4xl mx-auto text-center">
          <h2 class="text-3xl md:text-4xl font-bold mb-6">
            Tertarik dengan Layanan Kami?
          </h2>
          <p class="text-xl text-gray-200 mb-8">
            Hubungi kami untuk konsultasi gratis dan dapatkan solusi logistik terbaik untuk bisnis Anda
          </p>
          <router-link to="/kontak" class="btn btn-accent">
            Konsultasi Gratis
          </router-link>
        </div>
      </div>
    </section>
  </div>
</template>

