import { ref, shallowRef } from 'vue'
import { getSupabase, isSupabaseConfigured } from '@/lib/supabaseClient'

/** @type {import('vue').ShallowRef<import('@supabase/supabase-js').Session | null>} */
export const session_ref = shallowRef(null)

/** Current profile.role from `public.profiles` (null until loaded or absent). */
export const profile_role_ref = ref(null)

/** Any dashboard-eligible role: admin | viewer | operator. */
export const has_dashboard_access_ref = ref(false)

/** Convenience: profile.role === 'admin'. Kept for layout links and RBAC UX. */
export const is_admin_role_ref = ref(false)

export const auth_ready_ref = ref(false)

/** Allowed roles aligned with Postgres CHECK on `profiles.role` (migration). */
const dashboard_roles_allowed = ['admin', 'viewer', 'operator']

const network_error_re = /failed to fetch|networkerror|load failed|network request failed/i

function messageLooksLikeNetworkFailure(text) {
  return network_error_re.test(String(text || ''))
}

function networkErrorUserMessage() {
  return (
    'Tidak dapat menjangkau server Supabase (gagal menghubungi jaringan). ' +
    'Periksa: URL di .env tanpa "/" di akhir (contoh: https://xxxx.supabase.co), koneksi internet/VPN, ' +
    'proyek Supabase tidak paused, dan coba nonaktifkan ekstensi pemblokir iklan untuk domain ini. ' +
    'Setelah mengubah .env, jalankan ulang `npm run dev` atau build ulang untuk production.'
  )
}

let init_promise = null

function resetRoleFlags() {
  profile_role_ref.value = null
  has_dashboard_access_ref.value = false
  is_admin_role_ref.value = false
}

/**
 * Loads profiles.role for the signed-in user.
 * Must filter by `id`: RLS allows admins to SELECT all profiles, so an unfiltered query breaks maybeSingle().
 * @param {import('@supabase/supabase-js').SupabaseClient} supabase
 * @returns {Promise<boolean>}
 */
export async function fetchDashboardProfileRole(supabase) {
  const {
    data: { session }
  } = await supabase.auth.getSession()
  const user_id = session?.user?.id
  if (!user_id) {
    resetRoleFlags()
    return false
  }

  const { data, error } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user_id)
    .maybeSingle()
  if (error && messageLooksLikeNetworkFailure(error.message)) {
    const err = new Error('NETWORK_ERROR')
    err.cause = error
    throw err
  }
  if (error || !data) {
    resetRoleFlags()
    return false
  }
  const role_raw = data.role
  profile_role_ref.value = role_raw
  is_admin_role_ref.value = role_raw === 'admin'
  has_dashboard_access_ref.value =
    dashboard_roles_allowed.includes(role_raw)
  return has_dashboard_access_ref.value
}

/** @deprecated Use fetchDashboardProfileRole — alias for existing imports. */
export async function fetchAdminProfileRole(supabase) {
  return fetchDashboardProfileRole(supabase)
}

export async function ensureAdminAuthInitialized() {
  if (init_promise) {
    return init_promise
  }

  init_promise = (async () => {
    auth_ready_ref.value = false
    const supabase = getSupabase()
    if (!supabase) {
      session_ref.value = null
      resetRoleFlags()
      auth_ready_ref.value = true
      return
    }

    const {
      data: { session }
    } = await supabase.auth.getSession()
    session_ref.value = session
    if (session) {
      try {
        await fetchDashboardProfileRole(supabase)
      } catch (err) {
        if (err?.message !== 'NETWORK_ERROR' && !messageLooksLikeNetworkFailure(err?.message)) {
          console.error('fetchDashboardProfileRole (init)', err)
        }
      }
    } else {
      resetRoleFlags()
    }

    // Must not await slow work here: Supabase awaits onAuthStateChange callbacks before
    // finishing updateUser / token refresh — awaiting profiles would block password reset UI.
    supabase.auth.onAuthStateChange((_event, next_session) => {
      session_ref.value = next_session
      if (next_session) {
        void fetchDashboardProfileRole(supabase).catch((err) => {
          if (err?.message !== 'NETWORK_ERROR' && !messageLooksLikeNetworkFailure(err?.message)) {
            console.error('fetchDashboardProfileRole', err)
          }
        })
      } else {
        resetRoleFlags()
      }
    })

    auth_ready_ref.value = true
  })()

  return init_promise
}

/**
 * Sign in and verify dashboard role (admin, viewer, or operator). Signs out if role is not allowed.
 * @returns {{ ok: boolean, error_message?: string }}
 */
export async function signInAdmin(email_raw, password_raw) {
  const supabase = getSupabase()
  if (!supabase) {
    return {
      ok: false,
      error_message:
        'Konfigurasi Supabase belum lengkap. Isi VITE_SUPABASE_URL dan VITE_SUPABASE_PUBLISHABLE_KEY atau VITE_SUPABASE_ANON_KEY di .env.'
    }
  }

  const email_trim = email_raw.trim()

  let sign_payload
  try {
    sign_payload = await supabase.auth.signInWithPassword({
      email: email_trim,
      password: password_raw
    })
  } catch (err) {
    if (messageLooksLikeNetworkFailure(err?.message)) {
      return { ok: false, error_message: networkErrorUserMessage() }
    }
    throw err
  }

  const { data, error } = sign_payload

  if (error) {
    if (messageLooksLikeNetworkFailure(error.message)) {
      return { ok: false, error_message: networkErrorUserMessage() }
    }
    return {
      ok: false,
      error_message: error.message || 'Gagal masuk. Periksa email dan kata sandi.'
    }
  }

  session_ref.value = data.session

  let ok_dashboard
  try {
    ok_dashboard = await fetchDashboardProfileRole(supabase)
  } catch (err) {
    if (err?.message === 'NETWORK_ERROR' || messageLooksLikeNetworkFailure(err?.message)) {
      await supabase.auth.signOut()
      session_ref.value = null
      resetRoleFlags()
      return { ok: false, error_message: networkErrorUserMessage() }
    }
    throw err
  }

  if (!ok_dashboard) {
    await supabase.auth.signOut()
    session_ref.value = null
    resetRoleFlags()
    return {
      ok: false,
      error_message:
        'Akun Anda tidak memiliki peran dashboard (admin, operator, atau viewer). Hubungi pengelola sistem.'
    }
  }

  return { ok: true }
}

export async function signOutAdmin() {
  const supabase = getSupabase()
  if (!supabase) {
    session_ref.value = null
    resetRoleFlags()
    return
  }
  await supabase.auth.signOut()
  session_ref.value = null
  resetRoleFlags()
}

/**
 * Guard: session must have a dashboard role (viewer, operator, admin). Otherwise sign out.
 * @returns {Promise<boolean>}
 */
export async function requireDashboardSessionOrSignOut() {
  const supabase = getSupabase()
  if (!supabase || !session_ref.value) {
    return false
  }
  let ok
  try {
    ok = await fetchDashboardProfileRole(supabase)
  } catch (err) {
    if (err?.message === 'NETWORK_ERROR' || messageLooksLikeNetworkFailure(err?.message)) {
      return false
    }
    throw err
  }
  if (!ok) {
    await supabase.auth.signOut()
    session_ref.value = null
    resetRoleFlags()
  }
  return ok
}

/**
 * @deprecated Prefer requireDashboardSessionOrSignOut (same behavior after RBAC).
 */
export async function requireAdminSessionOrSignOut() {
  return requireDashboardSessionOrSignOut()
}

export function useAdminAuth() {
  return {
    session_ref,
    profile_role_ref,
    has_dashboard_access_ref,
    is_admin_role_ref,
    auth_ready_ref,
    isSupabaseConfigured,
    ensureAdminAuthInitialized,
    signInAdmin,
    signOutAdmin,
    fetchDashboardProfileRole,
    fetchAdminProfileRole
  }
}

/** Re-export for guards/pages without needing to touch both modules */
export { isSupabaseConfigured } from '@/lib/supabaseClient'
