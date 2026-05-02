import { createClient, type SupabaseClient } from '@supabase/supabase-js'

let supabase_singleton: SupabaseClient | null = null

/**
 * Trailing slashes break request paths (e.g. //auth/v1/token → "Failed to fetch").
 */
export function normalizeSupabaseProjectUrl(raw: string | undefined): string {
  if (!raw) return ''
  return raw.trim().replace(/\/+$/, '')
}

/** Anon JWT (legacy) or `sb_publishable_*` (API Keys tab); both work with `createClient`. */
function viteSupabasePublicKey(): string | undefined {
  const anon = import.meta.env.VITE_SUPABASE_ANON_KEY as string | undefined
  const publishable = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY as string | undefined
  const raw = anon?.trim() || publishable?.trim()
  return raw || undefined
}

export function isSupabaseConfigured(): boolean {
  const supabase_url = normalizeSupabaseProjectUrl(
    import.meta.env.VITE_SUPABASE_URL as string | undefined
  )
  return Boolean(supabase_url && viteSupabasePublicKey())
}

/**
 * Singleton browser client (anon key). Returns null when VITE_* env vars are missing (dev-safe).
 */
export function getSupabase(): SupabaseClient | null {
  if (!isSupabaseConfigured()) {
    return null
  }

  const supabase_url = normalizeSupabaseProjectUrl(
    import.meta.env.VITE_SUPABASE_URL as string
  )
  const supabase_public_key = viteSupabasePublicKey() as string

  if (!supabase_singleton) {
    supabase_singleton = createClient(supabase_url, supabase_public_key, {
      auth: {
        persistSession: true,
        autoRefreshToken: true,
        detectSessionInUrl: true
      }
    })
  }

  return supabase_singleton
}

/**
 * Client terpisah untuk `auth.signUp` saja: tidak menyimpan sesi ke storage browser,
 * sehingga admin yang sedang login tidak kehilangan sesi ketika membuat pengguna baru.
 */
export function createSupabaseEphemeralAuthClient(): SupabaseClient | null {
  if (!isSupabaseConfigured()) {
    return null
  }

  const supabase_url = normalizeSupabaseProjectUrl(
    import.meta.env.VITE_SUPABASE_URL as string
  )
  const supabase_public_key = viteSupabasePublicKey() as string

  return createClient(supabase_url, supabase_public_key, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
      detectSessionInUrl: false
    }
  })
}
