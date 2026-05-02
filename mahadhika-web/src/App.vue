<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import PublicLayout from './layouts/PublicLayout.vue'

const route = useRoute()
const is_admin_shell = computed(() => route.path.startsWith('/admin'))
</script>

<template>
  <PublicLayout v-if="!is_admin_shell">
    <RouterView />
  </PublicLayout>
  <RouterView v-else />
</template>
