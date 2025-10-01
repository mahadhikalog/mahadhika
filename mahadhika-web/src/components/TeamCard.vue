<script setup>
defineProps({
  name: {
    type: String,
    required: true
  },
  position: {
    type: String,
    required: true
  },
  role: {
    type: String,
    required: true
  },
  photo_url: {
    type: String,
    default: ''
  }
})
</script>

<template>
  <div class="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300">
    <div class="aspect-square bg-gradient-to-br from-primary-950 to-primary-700 flex items-center justify-center">
      <img 
        v-if="photo_url" 
        :src="photo_url" 
        :alt="name" 
        class="w-full h-full object-cover"
      >
      <svg v-else class="w-24 h-24 text-white" fill="currentColor" viewBox="0 0 24 24">
        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
      </svg>
    </div>
    <div class="p-6">
      <h3 class="text-xl font-bold text-primary-950 mb-1">{{ name }}</h3>
      <p class="text-accent-950 font-semibold text-sm mb-2">{{ position }}</p>
      <p class="text-gray-600 text-sm">{{ role }}</p>
    </div>
  </div>
</template>

