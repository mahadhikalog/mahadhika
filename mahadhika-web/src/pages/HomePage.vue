<script setup>
import { ref } from 'vue'
import ServiceCard from '@/components/ServiceCard.vue'
import ValueCard from '@/components/ValueCard.vue'
import SectorCard from '@/components/SectorCard.vue'
import heroImage from '@/assets/images/hero.png'

// WhatsApp Configuration
const whatsapp_number = '6281380176755' // +62 813-8017-6755 without special characters
const whatsapp_konsultasi_message = encodeURIComponent('Halo Mahadhika Logistik, saya ingin berkonsultasi gratis tentang layanan logistik untuk bisnis saya.')
const whatsapp_penawaran_message = encodeURIComponent('Halo Mahadhika Logistik, saya ingin meminta penawaran untuk layanan logistik. Mohon informasi lebih lanjut.')

const whatsapp_konsultasi_url = `https://wa.me/${whatsapp_number}?text=${whatsapp_konsultasi_message}`
const whatsapp_penawaran_url = `https://wa.me/${whatsapp_number}?text=${whatsapp_penawaran_message}`

const services = [
  {
    title: 'Retail & Distribusi',
    description: 'Pengiriman berbasis kilogram ke seluruh Indonesia dengan jaringan yang luas dan terpercaya.',
    image: '/images/services/retail-distribusi.jpg',
    cta: 'Lihat Detail'
  },
  {
    title: 'Solusi Logistik',
    description: 'Integrasi layanan logistik dan rantai pasok yang komprehensif untuk bisnis Anda.',
    image: '/images/services/solusi-logistik.jpg',
    cta: 'Lihat Detail'
  },
  {
    title: 'Transportasi',
    description: 'Moda darat, laut, dan udara yang andal & terpercaya untuk berbagai kebutuhan.',
    image: '/images/services/transportasi.jpg',
    cta: 'Lihat Detail'
  },
  {
    title: 'Pergudangan',
    description: 'Penyimpanan & pengelolaan stok sesuai kebutuhan dengan standar keamanan tinggi.',
    image: '/images/services/pergudangan.jpg',
    cta: 'Lihat Detail'
  }
]

const advantages = [
  {
    title: 'Komitmen Kualitas',
    description: 'Fokus pada kualitas pelayanan & profesionalisme untuk hubungan kemitraan jangka panjang yang terpercaya & berkelanjutan.',
    icon: 'shield'
  },
  {
    title: 'Fleksibilitas & Pendekatan Adaptif',
    description: 'Solusi logistik yang disesuaikan dengan kebutuhan Anda dan dikembangkan untuk menghadapi dinamika bisnis masa kini.',
    icon: 'refresh'
  },
  {
    title: 'Jaringan Luas & Kolaborasi yang Inklusif',
    description: 'Didukung oleh mitra yang tersebar di seluruh wilayah Indonesia, kami percaya kemajuan logistik adalah melalui kerja kolektif.',
    icon: 'users'
  },
  {
    title: 'Inovasi & Pengalaman',
    description: 'Perpaduan antara semangat pembaharuan dengan kredibilitas pengalaman tim pendiri kami dalam mengelola logistik.',
    icon: 'chip'
  },
  {
    title: 'Teknologi dengan Sentuhan Manusia',
    description: 'Digitalisasi tepat guna & transparan untuk sistem yang terpercaya. Kami menggabungkan teknologi dengan pelayanan yang empatik.',
    icon: 'lightbulb'
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
            <a :href="whatsapp_konsultasi_url" target="_blank" rel="noopener noreferrer" class="btn btn-accent">
              Konsultasi Gratis
            </a>
            <a :href="whatsapp_penawaran_url" target="_blank" rel="noopener noreferrer" class="btn bg-white text-primary-950 hover:bg-gray-100 focus:ring-white">
              Minta Penawaran
            </a>
          </div>
        </div>
      </div>
    </section>

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
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
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
              <a 
                :href="whatsapp_konsultasi_url" 
                target="_blank" 
                rel="noopener noreferrer"
                class="inline-flex items-center text-primary-600 hover:text-primary-700 font-medium text-sm transition-colors"
              >
                <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd"></path>
                </svg>
                {{ service.cta }}
              </a>
            </div>
          </div>
        </div>
        <div class="flex flex-col sm:flex-row gap-4 justify-center mt-12">
          <a :href="whatsapp_konsultasi_url" target="_blank" rel="noopener noreferrer" class="btn btn-primary">
            Konsultasi Gratis
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
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <ValueCard
            v-for="advantage in advantages"
            :key="advantage.title"
            :title="advantage.title"
            :description="advantage.description"
            :icon="advantage.icon"
          />
        </div>
        <div class="flex flex-col sm:flex-row gap-4 justify-center mt-12">
          <a :href="whatsapp_konsultasi_url" target="_blank" rel="noopener noreferrer" class="btn btn-primary">
            Konsultasi Gratis
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
          <a :href="whatsapp_konsultasi_url" target="_blank" rel="noopener noreferrer" class="btn btn-primary">
            Konsultasi Gratis
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
          <a :href="whatsapp_konsultasi_url" target="_blank" rel="noopener noreferrer" class="btn btn-accent">
            Konsultasi Gratis Sekarang
          </a>
        </div>
      </div>
    </section>
  </div>
</template>

