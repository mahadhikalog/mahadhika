<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()
const is_mobile_menu_open = ref(false)

const navigation = [
  { name: 'Beranda', path: '/' },
  { name: 'Tentang', path: '/tentang' },
  { name: 'Layanan', path: '/layanan' },
  { name: 'Roadmap', path: '/roadmap' },
  { name: 'Kontak', path: '/kontak' }
]

const toggleMobileMenu = () => {
  is_mobile_menu_open.value = !is_mobile_menu_open.value
}

const closeMobileMenu = () => {
  is_mobile_menu_open.value = false
}

const isActive = (path) => {
  return route.path === path
}
</script>

<template>
  <header class="bg-white shadow-md sticky top-0 z-50">
    <nav class="container-custom">
      <div class="flex items-center justify-between h-20">
        <!-- Logo -->
        <router-link to="/" class="flex items-center space-x-3">
          <img 
            src="/logo.png" 
            alt="Mahadhika Logistik" 
            class="h-12 w-auto"
            @error="(e) => e.target.style.display = 'none'"
          >
          <div class="hidden sm:block">
            <div class="text-xl font-bold text-primary-950">Mahadhika Logistik</div>
            <div class="text-xs text-gray-600">Menyatukan Potensi, Membangun Negeri</div>
          </div>
        </router-link>

        <!-- Desktop Navigation -->
        <div class="hidden md:flex items-center space-x-8">
          <router-link
            v-for="item in navigation"
            :key="item.path"
            :to="item.path"
            class="text-sm font-medium transition-colors duration-200"
            :class="isActive(item.path) 
              ? 'text-primary-950 border-b-2 border-primary-950 pb-1' 
              : 'text-gray-700 hover:text-primary-950'"
          >
            {{ item.name }}
          </router-link>
        </div>

        <!-- Mobile Menu Button -->
        <button
          @click="toggleMobileMenu"
          class="md:hidden p-2 rounded-lg text-gray-700 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-primary-500"
        >
          <svg
            v-if="!is_mobile_menu_open"
            class="h-6 w-6"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4 6h16M4 12h16M4 18h16"
            />
          </svg>
          <svg
            v-else
            class="h-6 w-6"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>
      </div>

      <!-- Mobile Navigation -->
      <div
        v-if="is_mobile_menu_open"
        class="md:hidden py-4 border-t border-gray-200"
      >
        <router-link
          v-for="item in navigation"
          :key="item.path"
          :to="item.path"
          @click="closeMobileMenu"
          class="block py-3 px-4 text-base font-medium rounded-lg transition-colors duration-200"
          :class="isActive(item.path)
            ? 'bg-primary-950 text-white'
            : 'text-gray-700 hover:bg-gray-100'"
        >
          {{ item.name }}
        </router-link>
      </div>
    </nav>
  </header>
</template>

