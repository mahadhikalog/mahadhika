import { createClient } from '@supabase/supabase-js'

const supabase_url = import.meta.env.VITE_SUPABASE_URL
const supabase_anon_key = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabase_url || !supabase_anon_key) {
  console.warn('Supabase credentials not found. Please check your .env file.')
}

export const supabase = createClient(supabase_url || '', supabase_anon_key || '')

