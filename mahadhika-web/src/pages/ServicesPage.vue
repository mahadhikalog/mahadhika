<script setup>
import ServiceCard from '@/components/ServiceCard.vue'
import SectorCard from '@/components/SectorCard.vue'
import retailDistribusiImage from '@/assets/images/services/retail.png'
import solusiLogistikImage from '@/assets/images/services/solusi-logistik.png'
import transportasiImage from '@/assets/images/services/transportasi.png'
import pergudanganImage from '@/assets/images/services/pergudangan.png'

const services = [
  {
    title: 'Retail & Distribusi',
    description: 'Pengiriman berbasis kilogram ke seluruh Indonesia dengan jaringan yang luas dan terpercaya. Kami memastikan setiap paket tiba dengan aman dan tepat waktu.',
    image: retailDistribusiImage,
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
    image: solusiLogistikImage,
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
    image: transportasiImage,
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
    image: pergudanganImage,
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
              <div class="rounded-2xl h-80 overflow-hidden shadow-lg">
                <img 
                  :src="service.image" 
                  :alt="service.title"
                  class="w-full h-full object-cover"
                  loading="lazy"
                />
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

