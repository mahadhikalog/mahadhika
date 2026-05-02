import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import GTMPlugin from './plugins/gtm.js'
import './styles/main.css'

const app = createApp(App)
const pinia = createPinia()

// Configure GTM Plugin
// Replace 'GTM-XXXXXXX' with your actual GTM Container ID
app.use(GTMPlugin, {
  gtmId: 'GTM-5B5BKRH4' // Your actual GTM Container ID
})

app.use(pinia)
app.use(router)

app.mount('#app')

