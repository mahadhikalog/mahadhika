<script setup>
import { ref } from 'vue'
import ServiceCard from '@/components/ServiceCard.vue'
import ValueCard from '@/components/ValueCard.vue'
import SectorCard from '@/components/SectorCard.vue'
import ShipmentTrackingSection from '@/components/ShipmentTrackingSection.vue'
import heroImage from '@/assets/images/hero.png'
import retailDistribusiImage from '@/assets/images/services/retail.png'
import solusiLogistikImage from '@/assets/images/services/solusi-logistik.png'
import transportasiImage from '@/assets/images/services/transportasi.png'
import pergudanganImage from '@/assets/images/services/pergudangan.png'
import keunggulanImage from '@/assets/images/services/keunggulan.png'

// WhatsApp Configuration
const whatsapp_number = '+628111926948' // +62 811-192-6948 without special characters
const whatsapp_penawaran_message = encodeURIComponent('Halo Mahadhika Logistik, saya ingin meminta penawaran untuk layanan logistik. Mohon informasi lebih lanjut.')

const whatsapp_penawaran_url = `https://wa.me/${whatsapp_number}?text=${whatsapp_penawaran_message}`

const services = [
  {
    title: 'Retail & Distribusi',
    description: 'Pengiriman berbasis kilogram ke seluruh Indonesia dengan jaringan yang luas dan terpercaya.',
    image: retailDistribusiImage,
    cta: 'Lihat Detail'
  },
  {
    title: 'Solusi Logistik',
    description: 'Integrasi layanan logistik dan rantai pasok yang komprehensif untuk bisnis Anda.',
    image: solusiLogistikImage,
    cta: 'Lihat Detail'
  },
  {
    title: 'Transportasi',
    description: 'Moda darat, laut, dan udara yang andal & terpercaya untuk berbagai kebutuhan.',
    image: transportasiImage,
    cta: 'Lihat Detail'
  },
  {
    title: 'Pergudangan',
    description: 'Penyimpanan & pengelolaan stok sesuai kebutuhan dengan standar keamanan tinggi.',
    image: pergudanganImage,
    cta: 'Lihat Detail'
  }
]

const advantages = [
  {
    title: 'Solusi Fleksibel & Disesuaikan',
    description: 'Mengakomodasi fluktuasi permintaan dengan solusi bersama atau khusus, memastikan inventori yang tepat di tempat yang tepat pada waktu yang tepat.',
    icon: 'warehouse'
  },
  {
    title: 'Inovasi Digital',
    description: 'Memanfaatkan teknologi dan solusi otomatis untuk throughput yang lebih tinggi, efisiensi yang optimal, dan manajemen gudang yang canggih.',
    icon: 'chip'
  },
  {
    title: 'SDM Terbaik',
    description: 'Spesialis gudang berpengalaman dan keahlian terdepan untuk memenuhi standar layanan yang tinggi dan profesional.',
    icon: 'users'
  },
  {
    title: 'Keunggulan Operasional',
    description: 'Kinerja kelas dunia dengan perbaikan berkelanjutan, kesehatan operasional, keselamatan, dan kualitas sesuai praktik terbaik industri.',
    icon: 'chart'
  }
]

const sectors = [
  {
    title: 'Teknologi & Telekomunikasi',
    description: 'Distribusi perangkat teknologi & infrastruktur telekomunikasi'
  },
  {
    title: 'Energi & Pertambangan',
    description: 'Transportasi material kritis & logistik proyek besar'
  },
  {
    title: 'Kesehatan & Farmasi',
    description: 'Distribusi sensitif dengan standar keamanan tinggi'
  },
  {
    title: 'FMCG & Barang Konsumsi',
    description: 'Distribusi produk kebutuhan sehari-hari'
  },
  {
    title: 'E-Commerce & Ritel',
    description: 'Distribusi fleksibel dengan layanan konsisten'
  },
  {
    title: 'Manufaktur & Industri',
    description: 'Dukungan dari bahan baku hingga produk akhir'
  }
]
</script>

<template>
  <div>
    <!-- Hero Section -->
    <section class="relative text-white overflow-hidden">
      <!-- Hero Background Image -->
      <div 
        class="absolute inset-0 bg-cover bg-center bg-no-repeat"
        :style="{ backgroundImage: `url(${heroImage})` }"
      ></div>
      <!-- Dark Overlay for Text Readability -->
      <div class="absolute inset-0 bg-gradient-to-r from-black/70 via-black/50 to-black/30"></div>
      <!-- Pattern Overlay -->
      <div class="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPjxnIGZpbGw9IiNmZmYiIGZpbGwtb3BhY2l0eT0iMC4xIj48cGF0aCBkPSJNMzYgMTRjMy4zMTQgMCA2IDIuNjg2IDYgNnMtMi42ODYgNi02IDYtNi0yLjY4Ni02LTYgMi42ODYtNiA2LTZ6TTI0IDM2YzMuMzE0IDAgNiAyLjY4NiA2IDZzLTIuNjg2IDYtNiA2LTYtMi42ODYtNi02IDIuNjg2LTYgNi02eiIvPjwvZz48L2c+PC9zdmc+')] opacity-30"></div>
      
      <div class="container-custom relative py-24 md:py-32">
        <div class="max-w-4xl">
          <h1 class="text-4xl md:text-6xl font-bold mb-6">
            Mahadhika Logistik Indonesia
          </h1>
          <p class="text-xl md:text-2xl text-gray-200 mb-4">
            Menyatukan Potensi, Membangun Negeri
          </p>
          <p class="text-lg text-gray-300 mb-8 max-w-2xl">
            Perusahaan logistik & rantai pasok nasional yang modern, inovatif, dan berdaya saing global dengan mengutamakan kualitas pelayanan.
          </p>
          <div class="flex flex-col sm:flex-row gap-4">
            <a href="#cek-resi" class="btn btn-accent">
              Cek Resi Pengiriman
            </a>
            <a :href="whatsapp_penawaran_url" target="_blank" rel="noopener noreferrer" class="btn bg-white text-primary-950 hover:bg-gray-100 focus:ring-white">
              Minta Penawaran
            </a>
          </div>
        </div>
      </div>
    </section>

    <ShipmentTrackingSection />

    <!-- About Brief -->
    <!-- <section class="section bg-white">
      <div class="container-custom">
        <div class="max-w-4xl mx-auto text-center">
          <h2 class="section-title">Tentang Kami</h2>
          <p class="text-gray-700 leading-relaxed mb-8">
            Indonesia menyimpan potensi ekonomi dan budaya dari Sabang hingga Merauke. 
            Mahadhika Logistik lahir dari keyakinan bahwa keberagaman bangsa hanya bermakna bila terhubung lewat sistem logistik yang kuat—hadir untuk mendukung kepentingan nasional dengan distribusi efisien, inklusif, dan menyeluruh.
          </p>
          <router-link to="/tentang" class="btn btn-outline">
            Selengkapnya
          </router-link>
        </div>
      </div>
    </section> -->

    <!-- Services -->
    <section class="section bg-gray-50">
      <div class="container-custom">
        <div class="text-center mb-12">
          <h2 class="section-title">Layanan Kami</h2>
          <p class="section-subtitle">
            Solusi logistik terpadu untuk mendukung kebutuhan bisnis Anda
          </p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-8">
          <div 
            v-for="service in services"
            :key="service.title"
            class="group relative bg-white rounded-2xl overflow-hidden shadow-lg hover:shadow-xl transition-all duration-300 hover:-translate-y-2"
          >
            <!-- Service Image -->
            <div class="relative h-64 bg-gray-200 overflow-hidden">
              <img 
                :src="service.image" 
                :alt="service.title"
                class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                loading="lazy"
              />
              <!-- Dark overlay for text readability -->
              <div class="absolute inset-0 bg-gradient-to-t from-black/70 via-transparent to-transparent"></div>
            </div>
            
            <!-- Service Content -->
            <div class="p-6">
              <h3 class="text-xl font-bold text-gray-900 mb-3 group-hover:text-primary-600 transition-colors">
                {{ service.title }}
              </h3>
              <p class="text-gray-600 text-sm leading-relaxed mb-4">
                {{ service.description }}
              </p>
              <router-link 
                to="/layanan"
                class="inline-flex items-center text-primary-600 hover:text-primary-700 font-medium text-sm transition-colors"
              >
                <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd"></path>
                </svg>
                {{ service.cta }}
              </router-link>
            </div>
          </div>
        </div>
        <div class="flex flex-col sm:flex-row gap-4 justify-center mt-12">
          <a href="#cek-resi" class="btn btn-primary">
            Cek Resi Pengiriman
          </a>
          <a :href="whatsapp_penawaran_url" target="_blank" rel="noopener noreferrer" class="btn btn-outline">
            Minta Penawaran
          </a>
        </div>
      </div>
    </section>

    <!-- Advantages -->
    <section class="section bg-white">
      <div class="container-custom">
        <div class="text-center mb-12">
          <h2 class="section-title">Keunggulan Kami</h2>
          <p class="section-subtitle">
            Keunggulan yang membedakan kami dalam memberikan layanan logistik terbaik
          </p>
        </div>
        
        <!-- Two Column Layout: Advantages Cards + Warehouse Image -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <!-- Left Column: Advantages Cards -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div 
              v-for="advantage in advantages"
              :key="advantage.title"
              class="bg-white rounded-xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 hover:-translate-y-1 border border-gray-100"
            >
              <!-- Icon -->
              <div class="w-12 h-12 bg-red-600 rounded-lg flex items-center justify-center mb-4">
                <svg v-if="advantage.icon === 'warehouse'" class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                </svg>
                <svg v-else-if="advantage.icon === 'chip'" class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z"/>
                </svg>
                <svg v-else-if="advantage.icon === 'users'" class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                </svg>
                <svg v-else-if="advantage.icon === 'chart'" class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                </svg>
              </div>
              
              <!-- Content -->
              <h3 class="text-lg font-bold text-gray-900 mb-3">{{ advantage.title }}</h3>
              <p class="text-gray-600 text-sm leading-relaxed">{{ advantage.description }}</p>
            </div>
          </div>
          
          <!-- Right Column: Warehouse Image -->
          <div class="relative">
            <div class="relative rounded-2xl overflow-hidden shadow-2xl">
              <img 
                :src="keunggulanImage" 
                alt="Keunggulan Mahadhika Logistik Indonesia"
                class="w-full h-96 object-cover"
                loading="lazy"
              />
              <!-- Overlay for better text contrast if needed -->
              <div class="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent"></div>
            </div>
            <!-- Decorative elements -->
            <div class="absolute -top-4 -right-4 w-24 h-24 bg-red-600 rounded-full opacity-20"></div>
            <div class="absolute -bottom-4 -left-4 w-16 h-16 bg-primary-600 rounded-full opacity-20"></div>
          </div>
        </div>
        
        <div class="flex flex-col sm:flex-row gap-4 justify-center mt-12">
          <a href="#cek-resi" class="btn btn-primary">
            Cek Resi Pengiriman
          </a>
          <a :href="whatsapp_penawaran_url" target="_blank" rel="noopener noreferrer" class="btn btn-outline">
            Minta Penawaran
          </a>
        </div>
      </div>
    </section>

    <!-- Sectors -->
    <section class="section bg-gray-50">
      <div class="container-custom">
        <div class="text-center mb-12">
          <h2 class="section-title">Sektor Industri</h2>
          <p class="section-subtitle">
            Kami melayani berbagai sektor industri dengan pengalaman dan dedikasi tinggi
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
        <div class="flex flex-col sm:flex-row gap-4 justify-center mt-12">
          <a href="#cek-resi" class="btn btn-primary">
            Cek Resi Pengiriman
          </a>
          <a :href="whatsapp_penawaran_url" target="_blank" rel="noopener noreferrer" class="btn btn-outline">
            Minta Penawaran
          </a>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="section bg-primary-950 text-white">
      <div class="container-custom">
        <div class="max-w-4xl mx-auto text-center">
          <h2 class="text-3xl md:text-4xl font-bold mb-6">
            Siap Bekerja Sama dengan Kami?
          </h2>
          <p class="text-xl text-gray-200 mb-8">
            Hubungi kami untuk mendiskusikan kebutuhan logistik bisnis Anda
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <a :href="whatsapp_penawaran_url" target="_blank" rel="noopener noreferrer" class="btn btn-accent">
              Minta Penawaran
            </a>
            <a href="#cek-resi" class="btn border-2 border-white text-white hover:bg-white hover:text-primary-950 focus:ring-white">
              Cek Resi Pengiriman
            </a>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

