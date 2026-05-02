import { createClient } from '@supabase/supabase-js'
import { normalizeSupabaseProjectUrl } from '@/lib/supabaseClient'

function viteSupabasePublicKey() {
  const anon = import.meta.env.VITE_SUPABASE_ANON_KEY
  const publishable = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY
  return String(anon || publishable || '').trim()
}

const supabase_url = normalizeSupabaseProjectUrl(import.meta.env.VITE_SUPABASE_URL)
const supabase_public_key = viteSupabasePublicKey()

if (!supabase_url || !supabase_public_key) {
  console.warn('Supabase credentials not found. Please check your .env file.')
}

export const supabase = createClient(supabase_url || '', supabase_public_key || '', {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true
  }
})

