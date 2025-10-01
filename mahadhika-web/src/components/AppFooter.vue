<script setup>
const current_year = new Date().getFullYear()

const quick_links = [
  { name: 'Beranda', path: '/' },
  { name: 'Tentang Kami', path: '/tentang' },
  { name: 'Layanan', path: '/layanan' },
  { name: 'Roadmap', path: '/roadmap' },
  { name: 'Kontak', path: '/kontak' }
]

const services = [
  'Retail & Distribusi',
  'Solusi Logistik',
  'Transportasi',
  'Pergudangan'
]
</script>

<template>
  <footer class="bg-primary-950 text-white">
    <div class="container-custom py-12">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
        <!-- Company Info -->
        <div>
          <h3 class="text-xl font-bold mb-4">Mahadhika Logistik</h3>
          <p class="text-gray-300 text-sm mb-4">
            Menyatukan Potensi, Membangun Negeri
          </p>
          <p class="text-gray-400 text-sm">
            Perusahaan logistik & rantai pasok nasional yang modern, inovatif, dan berdaya saing global.
          </p>
        </div>

        <!-- Quick Links -->
        <div>
          <h3 class="text-lg font-semibold mb-4">Navigasi</h3>
          <ul class="space-y-2">
            <li v-for="link in quick_links" :key="link.path">
              <router-link
                :to="link.path"
                class="text-gray-300 hover:text-white transition-colors duration-200 text-sm"
              >
                {{ link.name }}
              </router-link>
            </li>
          </ul>
        </div>

        <!-- Services -->
        <div>
          <h3 class="text-lg font-semibold mb-4">Layanan</h3>
          <ul class="space-y-2">
            <li v-for="service in services" :key="service">
              <span class="text-gray-300 text-sm">{{ service }}</span>
            </li>
          </ul>
        </div>

        <!-- Contact -->
        <div>
          <h3 class="text-lg font-semibold mb-4">Kontak</h3>
          <div class="space-y-3 text-sm">
            <div>
              <p class="text-gray-400 mb-1">Head Office</p>
              <p class="text-gray-300">
                Jalan Limo Raya No.108 A<br>
                Komplek Ruko Limo<br>
                Depok, Jawa Barat 16515
              </p>
            </div>
            <div>
              <p class="text-gray-400 mb-1">Email</p>
              <a 
                href="mailto:mahadhikalogistik@gmail.com" 
                class="text-gray-300 hover:text-white transition-colors duration-200"
              >
                mahadhikalogistik@gmail.com
              </a>
            </div>
            <div>
              <p class="text-gray-400 mb-1">Telepon</p>
              <a 
                href="tel:+6282163995688" 
                class="text-gray-300 hover:text-white transition-colors duration-200 block"
              >
                (+62) 821-6399-5688
              </a>
              <a 
                href="tel:+6281111801118" 
                class="text-gray-300 hover:text-white transition-colors duration-200 block"
              >
                (+62) 811-1180-1118
              </a>
            </div>
          </div>
        </div>
      </div>

      <!-- Copyright -->
      <div class="border-t border-gray-700 mt-12 pt-8 text-center">
        <p class="text-gray-400 text-sm">
          &copy; {{ current_year }} Mahadhika Logistik Indonesia. All rights reserved.
        </p>
      </div>
    </div>
  </footer>
</template>

