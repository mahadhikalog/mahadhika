<script setup>
import { ref } from 'vue'
import ServiceCard from '@/components/ServiceCard.vue'
import ValueCard from '@/components/ValueCard.vue'
import SectorCard from '@/components/SectorCard.vue'

const services = [
  {
    title: 'Retail & Distribusi',
    description: 'Pengiriman berbasis kilogram ke seluruh Indonesia dengan jaringan yang luas dan terpercaya.',
    icon: 'package'
  },
  {
    title: 'Solusi Logistik',
    description: 'Integrasi layanan logistik dan rantai pasok yang komprehensif untuk bisnis Anda.',
    icon: 'solution'
  },
  {
    title: 'Transportasi',
    description: 'Moda darat, laut, dan udara yang andal & terpercaya untuk berbagai kebutuhan.',
    icon: 'truck'
  },
  {
    title: 'Pergudangan',
    description: 'Penyimpanan & pengelolaan stok sesuai kebutuhan dengan standar keamanan tinggi.',
    icon: 'warehouse'
  }
]

const values = [
  {
    title: 'Harmonis',
    description: 'Menyatukan keberagaman potensi Indonesia',
    icon: 'users'
  },
  {
    title: 'Empati',
    description: 'Memahami kebutuhan pelanggan & mitra',
    icon: 'heart'
  },
  {
    title: 'Sinergi',
    description: 'Membangun kerja sama dengan semua pemangku kepentingan',
    icon: 'users'
  },
  {
    title: 'Adaptif',
    description: 'Fleksibel menghadapi dinamika bisnis',
    icon: 'refresh'
  },
  {
    title: 'Teknologi',
    description: 'Inovasi untuk efisiensi & transparansi',
    icon: 'chip'
  },
  {
    title: 'Integritas',
    description: 'Bisnis jujur, profesional, & konsisten',
    icon: 'shield'
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
    <section class="relative bg-gradient-to-br from-primary-950 via-primary-900 to-primary-800 text-white">
      <div class="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPjxnIGZpbGw9IiNmZmYiIGZpbGwtb3BhY2l0eT0iMC4wNSI+PHBhdGggZD0iTTM2IDE0YzMuMzE0IDAgNiAyLjY4NiA2IDZzLTIuNjg2IDYtNiA2LTYtMi42ODYtNi02IDIuNjg2LTYgNi02ek0yNCAzNmMzLjMxNCAwIDYgMi42ODYgNiA2cy0yLjY4NiA2LTYgNi02LTIuNjg2LTYtNiAyLjY4Ni02IDYtNnoiLz48L2c+PC9nPjwvc3ZnPg==')] opacity-50"></div>
      
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
            <router-link to="/kontak" class="btn btn-accent">
              Hubungi Kami
            </router-link>
            <router-link to="/layanan" class="btn bg-white text-primary-950 hover:bg-gray-100 focus:ring-white">
              Lihat Layanan
            </router-link>
          </div>
        </div>
      </div>
    </section>

    <!-- About Brief -->
    <section class="section bg-white">
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
    </section>

    <!-- Services -->
    <section class="section bg-gray-50">
      <div class="container-custom">
        <div class="text-center mb-12">
          <h2 class="section-title">Layanan Kami</h2>
          <p class="section-subtitle">
            Solusi logistik terpadu untuk mendukung kebutuhan bisnis Anda
          </p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <ServiceCard
            v-for="service in services"
            :key="service.title"
            :title="service.title"
            :description="service.description"
            :icon="service.icon"
          />
        </div>
      </div>
    </section>

    <!-- Values -->
    <section class="section bg-white">
      <div class="container-custom">
        <div class="text-center mb-12">
          <h2 class="section-title">Nilai Perusahaan</h2>
          <p class="section-subtitle">
            Nilai-nilai yang menjadi fondasi dalam setiap langkah kami
          </p>
        </div>
        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-8">
          <ValueCard
            v-for="value in values"
            :key="value.title"
            :title="value.title"
            :description="value.description"
            :icon="value.icon"
          />
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
          <router-link to="/kontak" class="btn btn-accent">
            Hubungi Kami Sekarang
          </router-link>
        </div>
      </div>
    </section>
  </div>
</template>

