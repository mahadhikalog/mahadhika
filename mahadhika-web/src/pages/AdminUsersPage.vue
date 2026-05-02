<script setup>
import { computed, onMounted, ref } from 'vue'
import {
  getSupabase,
  createSupabaseEphemeralAuthClient
} from '@/lib/supabaseClient'

const profiles_ref = ref([])
const loading_ref = ref(true)
const error_message_ref = ref('')
const saving_id_ref = ref(null)
const local_roles_ref = ref({})

/** Create user via anon `auth.signUp` + admin `profiles` update */
const new_user_email_ref = ref('')
const new_user_password_ref = ref('')
const new_user_full_name_ref = ref('')
const new_user_role_ref = ref('viewer')
const create_loading_ref = ref(false)
const create_error_ref = ref('')
const create_success_ref = ref('')
const create_user_modal_open_ref = ref(false)
const suspend_loading_id_ref = ref(null)
const current_user_id_ref = ref(null)

/**
 * Admin-only: kirim email atur ulang kata sandi lewat Auth API publik
 * (`resetPasswordForEmail`), sama seperti halaman lupa kata sandi.
 */
const send_reset_email_loading_id_ref = ref(null)
const reset_email_success_ref = ref('')

/** @type {readonly string[]} */
const role_options = ['viewer', 'operator', 'admin']

function buildLocalRolesFromRows(rows) {
  /** @type {Record<string, string>} */
  const next_local = {}
  for (const row of rows) {
    next_local[row.id] = row.role
  }
  return next_local
}

async function loadProfiles() {
  loading_ref.value = true
  error_message_ref.value = ''
  const supabase = getSupabase()
  if (!supabase) {
    error_message_ref.value =
      'Supabase tidak dikonfigurasi. Periksa berkas .env Anda.'
    profiles_ref.value = []
    loading_ref.value = false
    return
  }

  const { data, error } = await supabase.rpc('admin_list_profiles')
  if (error) {
    error_message_ref.value = error.message || 'Gagal memuat daftar pengguna.'
    profiles_ref.value = []
  } else {
    /** @type {{ id: string, full_name: string | null, role: string, email: string | null, is_suspended?: boolean, created_at: string, updated_at: string }[]} */
    const rows = data || []
    profiles_ref.value = rows
    local_roles_ref.value = buildLocalRolesFromRows(rows)
  }
  loading_ref.value = false
}

onMounted(async () => {
  const supabase = getSupabase()
  if (supabase) {
    const { data: user_data } = await supabase.auth.getUser()
    current_user_id_ref.value = user_data.user?.id ?? null
  }
  void loadProfiles()
})

function resetNewUserFormFields() {
  new_user_email_ref.value = ''
  new_user_password_ref.value = ''
  new_user_full_name_ref.value = ''
  new_user_role_ref.value = 'viewer'
}

function openCreateUserModal() {
  create_error_ref.value = ''
  resetNewUserFormFields()
  create_user_modal_open_ref.value = true
}

function closeCreateUserModal() {
  if (create_loading_ref.value) {
    return
  }
  create_user_modal_open_ref.value = false
  create_error_ref.value = ''
  resetNewUserFormFields()
}

/** Tutup modal setelah berhasil menyimpan — tidak diblokir oleh loading. */
function hideCreateUserModal() {
  create_user_modal_open_ref.value = false
  create_error_ref.value = ''
  resetNewUserFormFields()
}

/**
 * @param {string} message_raw
 */
function formatSignUpAuthError(message_raw) {
  const m = (message_raw || '').toLowerCase()
  if (
    m.includes('already registered') ||
    m.includes('already been registered') ||
    m.includes('user already')
  ) {
    return 'Email sudah terdaftar.'
  }
  if (m.includes('signup') && m.includes('disabled')) {
    return 'Pendaftaran email dinonaktifkan di proyek Supabase (Authentication → Providers).'
  }
  return message_raw || 'Gagal mendaftarkan pengguna.'
}

async function submitCreateDashboardUser() {
  create_error_ref.value = ''
  create_success_ref.value = ''
  const supabase = getSupabase()
  const sign_up_client = createSupabaseEphemeralAuthClient()
  if (!supabase || !sign_up_client) {
    create_error_ref.value =
      'Supabase tidak dikonfigurasi. Periksa berkas .env Anda.'
    return
  }

  const email_trimmed = new_user_email_ref.value.trim()
  const password_raw = new_user_password_ref.value
  const full_name_value = new_user_full_name_ref.value.trim() || null
  const desired_role = new_user_role_ref.value

  if (!email_trimmed) {
    create_error_ref.value = 'Email wajib diisi.'
    return
  }
  if (!password_raw || password_raw.length < 8) {
    create_error_ref.value = 'Kata sandi wajib minimal 8 karakter.'
    return
  }
  if (!role_options.includes(desired_role)) {
    create_error_ref.value = 'Peran tidak valid.'
    return
  }

  create_loading_ref.value = true
  try {
    const { data: sign_up_data, error: sign_up_error } =
      await sign_up_client.auth.signUp({
        email: email_trimmed,
        password: password_raw,
        options: {
          data: full_name_value ? { full_name: full_name_value } : undefined
        }
      })

    if (sign_up_error) {
      create_error_ref.value = formatSignUpAuthError(sign_up_error.message)
      return
    }

    const new_user_id = sign_up_data.user?.id
    if (!new_user_id) {
      create_error_ref.value =
        'Tidak mendapat ID pengguna dari pendaftaran. Periksa pengaturan konfirmasi email di Supabase.'
      return
    }

    const { error: profile_error } = await supabase
      .from('profiles')
      .update({
        role: desired_role,
        full_name: full_name_value,
        updated_at: new Date().toISOString()
      })
      .eq('id', new_user_id)
      .select('id')
      .single()

    if (profile_error) {
      create_error_ref.value =
        profile_error.message ||
        'Akun dibuat namun gagal menyimpan peran — periksa di Supabase Dashboard.'
      return
    }

    create_success_ref.value =
      'Pengguna berhasil dibuat. Berikan kata sandi sementara kepada pengguna dengan aman.'
    hideCreateUserModal()
    await loadProfiles()
  } finally {
    create_loading_ref.value = false
  }
}

const role_option_help = {
  viewer: 'Hanya melihat shipments dan events.',
  operator: 'Mengelola shipments dan events; tidak mengubah pengguna.',
  admin: 'Akses penuh termasuk halaman Pengguna.'
}

const has_changes = computed(() => {
  const local = local_roles_ref.value
  for (const p of profiles_ref.value) {
    if (local[p.id] !== undefined && local[p.id] !== p.role) {
      return true
    }
  }
  return false
})

function syncRowFromServer(row) {
  const next = { ...local_roles_ref.value }
  next[row.id] = row.role
  local_roles_ref.value = next
}

/**
 * @param {string} profile_id
 */
async function persistRoleChange(profile_id) {
  const supabase = getSupabase()
  if (!supabase) {
    return
  }

  const desired = local_roles_ref.value[profile_id]
  const original = profiles_ref.value.find((x) => x.id === profile_id)
  if (!original || desired === original.role) {
    return
  }

  saving_id_ref.value = profile_id
  error_message_ref.value = ''

  const { data, error } = await supabase
    .from('profiles')
    .update({
      role: desired,
      updated_at: new Date().toISOString()
    })
    .eq('id', profile_id)
    .select('id, role')
    .single()

  saving_id_ref.value = null

  if (error) {
    error_message_ref.value = error.message || 'Gagal menyimpan peran.'
    syncRowFromServer(original)
    return
  }

  profiles_ref.value = profiles_ref.value.map((row) =>
    row.id === profile_id ? { ...row, role: data.role } : row
  )
}

/**
 * @param {string} profile_id
 */
function discardLocalChange(profile_id) {
  const original = profiles_ref.value.find((x) => x.id === profile_id)
  if (!original) {
    return
  }
  const next = { ...local_roles_ref.value }
  next[profile_id] = original.role
  local_roles_ref.value = next
}

/**
 * @param {string} profile_id
 * @param {boolean} next_suspended
 */
async function setUserSuspended(profile_id, next_suspended) {
  const supabase = getSupabase()
  if (!supabase) {
    return
  }

  if (profile_id === current_user_id_ref.value) {
    error_message_ref.value =
      'Anda tidak dapat mengubah status penangguhan untuk akun Anda sendiri dari panel ini.'
    return
  }

  suspend_loading_id_ref.value = profile_id
  error_message_ref.value = ''

  const { data, error } = await supabase
    .from('profiles')
    .update({
      is_suspended: next_suspended,
      updated_at: new Date().toISOString()
    })
    .eq('id', profile_id)
    .select('id, is_suspended, updated_at')
    .single()

  suspend_loading_id_ref.value = null

  if (error) {
    const raw = error.message || ''
    if (raw.includes('menangguhkan akun Anda sendiri')) {
      error_message_ref.value =
        'Tidak dapat menangguhkan akun Anda sendiri dari panel ini.'
      return
    }
    if (raw.includes('Hanya admin aktif')) {
      error_message_ref.value =
        'Anda tidak memiliki izin mengubah status penangguhan.'
      return
    }
    error_message_ref.value = raw || 'Gagal memperbarui status akun.'
    return
  }

  profiles_ref.value = profiles_ref.value.map((row) =>
    row.id === profile_id
      ? {
          ...row,
          is_suspended: data.is_suspended,
          updated_at: data.updated_at
        }
      : row
  )
}

function formatDate(iso_raw) {
  if (!iso_raw) {
    return '—'
  }
  try {
    return new Date(iso_raw).toLocaleString('id-ID', {
      dateStyle: 'medium',
      timeStyle: 'short'
    })
  } catch {
    return iso_raw
  }
}

function adminPasswordResetRedirectUrl() {
  if (typeof window === 'undefined') {
    return ''
  }
  return `${window.location.origin}/admin/reset-password`
}

/**
 * Memicu email reset kata sandi untuk pengguna lain (bukan mengatur string kata sandi langsung).
 * @param {{ id: string, email: string | null }} row
 */
async function sendUserPasswordResetEmail(row) {
  error_message_ref.value = ''
  reset_email_success_ref.value = ''

  if (row.id === current_user_id_ref.value) {
    error_message_ref.value =
      'Untuk akun Anda sendiri, gunakan tautan Lupa kata sandi di halaman masuk.'
    return
  }

  const email_trimmed = (row.email || '').trim()
  if (!email_trimmed) {
    error_message_ref.value =
      'Tidak ada alamat email untuk pengguna ini.'
    return
  }

  const supabase = getSupabase()
  if (!supabase) {
    error_message_ref.value =
      'Supabase tidak dikonfigurasi. Periksa berkas .env Anda.'
    return
  }

  send_reset_email_loading_id_ref.value = row.id
  try {
    const { error } = await supabase.auth.resetPasswordForEmail(
      email_trimmed,
      { redirectTo: adminPasswordResetRedirectUrl() }
    )
    if (error) {
      error_message_ref.value =
        error.message || 'Gagal mengirim email atur ulang. Coba lagi.'
      return
    }
    reset_email_success_ref.value =
      `Permintaan atur ulang kata sandi telah dikirim untuk ${email_trimmed}. Minta pengguna memeriksa email (dan folder spam). Pesan sukses ini muncul meskipun alamat tidak terdaftar — demi keamanan, Supabase tidak mengungkapkan apakah email ada.`
  } finally {
    send_reset_email_loading_id_ref.value = null
  }
}
</script>

<template>
  <div class="px-4 py-8 md:px-8 max-w-5xl mx-auto">
    <div
      class="mb-8 flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between"
    >
      <div class="max-w-xl">
        <h1 class="text-2xl font-semibold text-gray-900">
          Pengguna
        </h1>
        <p class="mt-2 text-sm text-gray-600">
          Peran dibatasi oleh kebijakan database (RBAC). Hanya pengguna dengan peran admin yang dapat mengubah peran orang lain dari halaman ini. Untuk kata sandi pengguna lain, admin dapat mengirim email atur ulang lewat API Auth Supabase (bukan mengisi kata sandi baru secara langsung di sini).
        </p>
      </div>
      <button
        type="button"
        class="btn btn-primary shrink-0 self-start px-4 py-2.5"
        @click="openCreateUserModal"
      >
        Tambah pengguna
      </button>
    </div>

    <div
      v-if="error_message_ref"
      class="mb-6 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800"
      role="alert"
    >
      {{ error_message_ref }}
    </div>

    <div
      v-if="create_success_ref"
      class="mb-6 rounded-lg border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-900"
      role="status"
    >
      {{ create_success_ref }}
    </div>

    <div
      v-if="reset_email_success_ref"
      class="mb-6 rounded-lg border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-900"
      role="status"
    >
      {{ reset_email_success_ref }}
    </div>

    <div class="rounded-xl border border-gray-200 bg-white shadow-sm overflow-hidden">
      <div
        v-if="loading_ref"
        class="px-4 py-10 text-center text-sm text-gray-500"
      >
        Memuat daftar pengguna…
      </div>
      <div
        v-else-if="!profiles_ref.length"
        class="px-4 py-10 text-center text-sm text-gray-500"
      >
        Tidak ada data pengguna, atau Anda tidak memiliki akses RPC <code class="rounded bg-gray-100 px-1 py-0.5 text-xs">admin_list_profiles</code>.
      </div>
      <div v-else class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200 text-sm">
          <thead class="bg-gray-50">
            <tr>
              <th class="text-left px-4 py-3 font-semibold text-gray-700">
                Email
              </th>
              <th class="text-left px-4 py-3 font-semibold text-gray-700">
                Nama
              </th>
              <th class="text-left px-4 py-3 font-semibold text-gray-700">
                Status akun
              </th>
              <th class="text-left px-4 py-3 font-semibold text-gray-700">
                Peran
              </th>
              <th class="text-left px-4 py-3 font-semibold text-gray-700">
                Pembaruan
              </th>
              <th class="text-right px-4 py-3 font-semibold text-gray-700">
                Aksi
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr
              v-for="row in profiles_ref"
              :key="row.id"
              class="hover:bg-gray-50/80"
              :class="{ 'bg-rose-50/40': row.is_suspended === true }"
            >
              <td class="px-4 py-3 font-mono text-xs text-gray-800">
                {{ row.email || '—' }}
              </td>
              <td class="px-4 py-3 text-gray-800">
                {{ row.full_name || '—' }}
              </td>
              <td class="px-4 py-3">
                <span
                  class="inline-flex w-fit shrink-0 rounded-full px-2.5 py-0.5 text-xs font-semibold"
                  :class="
                    row.is_suspended === true
                      ? 'bg-rose-100 text-rose-950'
                      : 'bg-emerald-50 text-emerald-950'
                  "
                >
                  {{ row.is_suspended === true ? 'Ditangguhkan' : 'Aktif' }}
                </span>
              </td>
              <td class="px-4 py-3">
                <select
                  v-model="local_roles_ref[row.id]"
                  class="rounded-lg border border-gray-300 px-2 py-1.5 text-gray-900 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
                  <option
                    v-for="opt in role_options"
                    :key="opt"
                    :value="opt"
                  >
                    {{ opt }}
                  </option>
                </select>
              </td>
              <td class="px-4 py-3 text-gray-600 whitespace-nowrap">
                {{ formatDate(row.updated_at) }}
              </td>
              <td class="px-4 py-3 text-right align-top">
                <div class="inline-flex flex-col items-end gap-2">
                  <template v-if="row.id !== current_user_id_ref">
                    <button
                      type="button"
                      class="rounded-lg border border-gray-300 px-3 py-1.5 text-xs font-semibold text-gray-800 transition hover:bg-gray-50 disabled:cursor-not-allowed disabled:opacity-50"
                      :disabled="suspend_loading_id_ref === row.id"
                      @click="setUserSuspended(row.id, row.is_suspended !== true)"
                    >
                      {{
                        suspend_loading_id_ref === row.id
                          ? 'Memproses…'
                          : row.is_suspended === true
                            ? 'Aktifkan'
                            : 'Tangguhkan'
                      }}
                    </button>
                    <button
                      type="button"
                      class="rounded-lg border border-primary-200 bg-primary-50 px-3 py-1.5 text-xs font-semibold text-primary-900 transition hover:bg-primary-100 disabled:cursor-not-allowed disabled:opacity-50"
                      :disabled="send_reset_email_loading_id_ref !== null"
                      @click="sendUserPasswordResetEmail(row)"
                    >
                      {{
                        send_reset_email_loading_id_ref === row.id
                          ? 'Mengirim…'
                          : 'Email atur ulang kata sandi'
                      }}
                    </button>
                  </template>
                  <span
                    v-else
                    class="text-xs text-gray-500"
                  >Akun Anda</span>
                  <div
                    v-if="local_roles_ref[row.id] !== row.role"
                    class="flex flex-wrap justify-end gap-2"
                  >
                    <button
                      type="button"
                      class="btn btn-primary text-xs py-1.5 px-3"
                      :disabled="saving_id_ref === row.id"
                      @click="persistRoleChange(row.id)"
                    >
                      {{ saving_id_ref === row.id ? 'Menyimpan…' : 'Simpan' }}
                    </button>
                    <button
                      type="button"
                      class="text-xs text-gray-600 underline hover:text-gray-900"
                      :disabled="saving_id_ref === row.id"
                      @click="discardLocalChange(row.id)"
                    >
                      Batal
                    </button>
                  </div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <p
      v-if="has_changes"
      class="mt-4 text-xs text-amber-800"
    >
      Ada perubahan peran yang belum disimpan — gunakan tombol Simpan pada baris terkait.
    </p>

    <Teleport to="body">
      <div
        v-if="create_user_modal_open_ref"
        class="fixed inset-0 z-[100] flex min-h-full items-end justify-center overflow-y-auto bg-slate-900/50 p-4 pb-6 backdrop-blur-[1px] sm:items-center sm:p-6"
        role="presentation"
        @click.self="closeCreateUserModal"
      >
        <div
          role="dialog"
          aria-modal="true"
          aria-labelledby="create-user-modal-title"
          class="w-full max-w-lg rounded-2xl border border-gray-200 bg-white shadow-xl"
          @click.stop
        >
            <div class="flex items-start justify-between gap-4 border-b border-gray-100 px-5 py-4">
              <h2
                id="create-user-modal-title"
                class="text-lg font-semibold text-gray-900"
              >
                Tambah pengguna baru
              </h2>
              <button
                type="button"
                class="rounded-lg p-1.5 text-gray-500 hover:bg-gray-100 hover:text-gray-800 focus:outline-none focus-visible:ring-2 focus-visible:ring-primary-500"
                aria-label="Tutup"
                :disabled="create_loading_ref"
                @click="closeCreateUserModal"
              >
                <svg
                  class="h-5 w-5"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                  aria-hidden="true"
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

            <div class="border-b border-gray-100 px-5 py-3 text-sm text-gray-600">
              Akun dibuat lewat signup (sesi admin tidak diganti); peran dan nama disimpan di
              <code class="rounded bg-gray-100 px-1 py-0.5 text-xs">profiles</code>.
            </div>

            <div
              v-if="create_error_ref"
              class="mx-5 mt-4 rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-800"
              role="alert"
            >
              {{ create_error_ref }}
            </div>

            <form
              class="px-5 py-5"
              @submit.prevent="submitCreateDashboardUser"
            >
              <div class="grid gap-4 sm:grid-cols-2">
                <div class="sm:col-span-2">
                  <label
                    for="new-user-email"
                    class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
                  >Email</label>
                  <input
                    id="new-user-email"
                    v-model="new_user_email_ref"
                    type="email"
                    autocomplete="off"
                    required
                    class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
                    placeholder="nama@perusahaan.com"
                  >
                </div>
                <div>
                  <label
                    for="new-user-password"
                    class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
                  >Kata sandi sementara</label>
                  <input
                    id="new-user-password"
                    v-model="new_user_password_ref"
                    type="password"
                    autocomplete="new-password"
                    required
                    minlength="8"
                    class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
                    placeholder="Minimal 8 karakter"
                  >
                </div>
                <div>
                  <label
                    for="new-user-full-name"
                    class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
                  >Nama lengkap (opsional)</label>
                  <input
                    id="new-user-full-name"
                    v-model="new_user_full_name_ref"
                    type="text"
                    autocomplete="off"
                    class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500"
                    placeholder="Nama untuk ditampilkan"
                  >
                </div>
                <div class="sm:col-span-2">
                  <label
                    for="new-user-role"
                    class="block text-xs font-semibold uppercase tracking-wide text-gray-600"
                  >Peran</label>
                  <select
                    id="new-user-role"
                    v-model="new_user_role_ref"
                    class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-gray-900 focus:border-primary-500 focus:ring-2 focus:ring-primary-500 sm:max-w-md"
                  >
                    <option
                      v-for="opt in role_options"
                      :key="opt"
                      :value="opt"
                    >
                      {{ opt }}
                    </option>
                  </select>
                  <p class="mt-1 text-xs text-gray-500">
                    {{ role_option_help[new_user_role_ref] }}
                  </p>
                </div>
              </div>

              <div class="mt-6 flex flex-col-reverse gap-2 sm:flex-row sm:justify-end sm:gap-3">
                <button
                  type="button"
                  class="rounded-lg border border-gray-300 px-4 py-2.5 text-sm font-semibold text-gray-700 transition hover:bg-gray-50 disabled:cursor-not-allowed disabled:opacity-60"
                  :disabled="create_loading_ref"
                  @click="closeCreateUserModal"
                >
                  Batal
                </button>
                <button
                  type="submit"
                  class="btn btn-primary px-5 py-2.5 disabled:cursor-not-allowed disabled:opacity-60"
                  :disabled="create_loading_ref"
                >
                  {{ create_loading_ref ? 'Membuat…' : 'Buat pengguna' }}
                </button>
              </div>
            </form>
        </div>
      </div>
    </Teleport>
  </div>
</template>
