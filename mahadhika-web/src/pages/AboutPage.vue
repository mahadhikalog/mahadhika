<script setup>
import ValueCard from '@/components/ValueCard.vue'
import TeamCard from '@/components/TeamCard.vue'

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

const team = [
  {
    name: 'M. Faza Alrasyid',
    position: 'Direktur Eksekusi & Kemitraan',
    role: 'Direktur Eksekusi & Kemitraan'
  },
  {
    name: 'Tareq Busnia',
    position: 'Direktur Utama',
    role: 'Strategi & Inovasi Bisnis'
  },
  {
    name: 'Eri Anshori Nurhadi',
    position: 'Komisaris',
    role: 'Digitalisasi & Teknologi'
  },
  {
    name: 'Sos Hendra',
    position: 'Komisaris Utama',
    role: 'Relasi Eksekutif & Strategis'
  }
]

const advantages = [
  {
    title: 'Komitmen Kualitas',
    description: 'Fokus pada kualitas layanan & profesionalisme dalam setiap pengiriman'
  },
  {
    title: 'Fleksibilitas & Adaptif',
    description: 'Solusi sesuai kebutuhan & dinamika bisnis Anda'
  },
  {
    title: 'Jaringan Luas & Kolaborasi',
    description: 'Mitra tersebar di seluruh Indonesia untuk jangkauan maksimal'
  },
  {
    title: 'Inovasi & Pengalaman',
    description: 'Perpaduan pengalaman & semangat pembaruan untuk hasil optimal'
  },
  {
    title: 'Teknologi dengan Sentuhan Manusia',
    description: 'Digitalisasi transparan & layanan empatik untuk kepuasan pelanggan'
  }
]
</script>

<template>
  <div>
    <!-- Hero -->
    <section class="bg-gradient-to-br from-primary-950 to-primary-800 text-white py-20">
      <div class="container-custom">
        <h1 class="text-4xl md:text-5xl font-bold mb-4">Tentang Kami</h1>
        <p class="text-xl text-gray-200 max-w-3xl">
          Menyatukan Potensi Indonesia Melalui Logistik yang Kuat
        </p>
      </div>
    </section>

    <!-- About Content -->
    <section class="section bg-white">
      <div class="container-custom">
        <div class="max-w-4xl mx-auto">
          <h2 class="section-title text-center">Profil Perusahaan</h2>
          <div class="prose prose-lg max-w-none text-gray-700">
            <p class="mb-6">
              Indonesia menyimpan potensi ekonomi dan budaya dari Sabang hingga Merauke. 
              Mahadhika Logistik lahir dari keyakinan bahwa keberagaman bangsa hanya bermakna bila terhubung lewat sistem logistik yang kuat—hadir untuk mendukung kepentingan nasional dengan distribusi efisien, inklusif, dan menyeluruh.
            </p>
            <p class="mb-6">
              Profesionalisme dan integritas menjadi fondasi kami, dengan budaya kerja transparan, berkomitmen, dan kolaboratif. 
              Kualitas layanan adalah prioritas utama agar mitra dan pelanggan memperoleh nilai tambah berkelanjutan.
            </p>
            <p>
              Sejalan perkembangan zaman, kami mengedepankan inovasi dan digitalisasi demi efisiensi, transparansi, dan ketepatan layanan. 
              Kolaborasi nasional adalah inti perjalanan kami untuk menyatukan potensi bangsa menuju logistik modern dan berdaya saing global.
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- Vision & Mission -->
    <section class="section bg-gray-50">
      <div class="container-custom">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
          <div class="bg-white rounded-2xl shadow-lg p-8">
            <h2 class="text-3xl font-bold text-primary-950 mb-6">Visi</h2>
            <p class="text-gray-700 leading-relaxed text-lg">
              Menjadi perusahaan logistik & rantai pasok nasional yang modern, inovatif, dan berdaya saing global dengan mengutamakan kualitas pelayanan serta kolaborasi nasional demi memajukan kepentingan bangsa.
            </p>
          </div>
          <div class="bg-white rounded-2xl shadow-lg p-8">
            <h2 class="text-3xl font-bold text-primary-950 mb-6">Misi</h2>
            <ul class="space-y-4 text-gray-700">
              <li class="flex items-start">
                <svg class="w-6 h-6 text-accent-950 mr-3 mt-1 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                </svg>
                <span>Menghubungkan potensi Indonesia lewat distribusi efisien, inklusif, & berkelanjutan</span>
              </li>
              <li class="flex items-start">
                <svg class="w-6 h-6 text-accent-950 mr-3 mt-1 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                </svg>
                <span>Menjunjung profesionalisme, integritas, dan layanan berkualitas</span>
              </li>
              <li class="flex items-start">
                <svg class="w-6 h-6 text-accent-950 mr-3 mt-1 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                </svg>
                <span>Mengakselerasi inovasi dan digitalisasi logistik yang tepat sasaran</span>
              </li>
              <li class="flex items-start">
                <svg class="w-6 h-6 text-accent-950 mr-3 mt-1 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                </svg>
                <span>Memperkuat kolaborasi nasional lintas pemangku kepentingan</span>
              </li>
            </ul>
          </div>
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

    <!-- Advantages -->
    <section class="section bg-gray-50">
      <div class="container-custom">
        <div class="text-center mb-12">
          <h2 class="section-title">Keunggulan Kami</h2>
          <p class="section-subtitle">
            Yang membedakan kami dari yang lain
          </p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 max-w-5xl mx-auto">
          <div 
            v-for="(advantage, index) in advantages" 
            :key="advantage.title"
            class="bg-white rounded-lg p-6 shadow-md hover:shadow-lg transition-shadow duration-300"
          >
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-primary-950 text-white rounded-full flex items-center justify-center font-bold mr-3">
                {{ index + 1 }}
              </div>
              <h3 class="text-lg font-bold text-primary-950">{{ advantage.title }}</h3>
            </div>
            <p class="text-gray-600 text-sm">{{ advantage.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Team -->
    <!-- <section class="section bg-white">
      <div class="container-custom">
        <div class="text-center mb-12">
          <h2 class="section-title">Tim Pendiri</h2>
          <p class="section-subtitle">
            Dipimpin oleh para profesional berpengalaman
          </p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <TeamCard
            v-for="member in team"
            :key="member.name"
            :name="member.name"
            :position="member.position"
            :role="member.role"
          />
        </div>
      </div>
    </section> -->
  </div>
</template>

