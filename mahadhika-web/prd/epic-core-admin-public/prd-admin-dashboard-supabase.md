# PRD — Admin Dashboard & Pelacakan Publik (Supabase)

**Produk:** Mahadhika Logistik — situs publik + panel admin  
**Stack teknis:** Vue 3 (Vite), Supabase (Auth, Postgres, RLS), deployment terpisah untuk subdomain admin (disarankan)

---

## 1. Ringkasan produk

Pengunjung utama dapat **mengecek nomor resi** (“Cek Resi”) tanpa login. Tim internal mengelola **data pengiriman** dan **update status / event** melalui **dashboard admin**. Semua pengiriman dikelola oleh Mahadhika — **tidak ada pemilihan kurir** di UI publik maupun alur bisnis utama; nomor resi mengidentifikasi kiriman Mahadhika.

---

## 2. Arsitektur domain: admin vs publik


| Aspek  | Domain utama (publik)                                               | Subdomain admin                      |
| ------ | ------------------------------------------------------------------- | ------------------------------------ |
| Contoh | `mahadhika.id`, `www.mahadhika.id`                                  | `admin.mahadhika.id`                 |
| Tujuan | Marketing, formulir, **Cek Resi** (baca-only via RPC aman)          | Login staf, CRUD kiriman & event     |
| Auth   | Opsional untuk fitur lain; Cek Resi **tidak** memakai login         | **Supabase Auth** wajib              |
| Data   | Hanya panggilan yang aman untuk publik (mis. `get_public_tracking`) | Policy RLS `profiles.role = 'admin'` |


**Rekomendasi implementasi**

- Dua **Vite build** atau dua **entry/route groups**: satu untuk marketing + Cek Resi, satu untuk SPA admin (router terpisah, base path atau host berbeda).
- **Satu project Supabase** untuk Auth + DB; variabel lingkungan `VITE_SUPABASE_*` di setiap frontend yang perlu.
- **Jangan** mengekspos service role key di browser admin; gunakan **anon key** + RLS. Operasi khusus (jika ada) lewat Edge Functions atau backend dengan service role.

---

## 3. Alur bisnis: pengiriman & feed ke “Cek Resi”

1. Admin membuat atau mengimpor **shipment** dengan `tracking_number` unik (satu nomor = satu kiriman Mahadhika).
2. Admin menambah **shipment_events** (scan hub, transit, dll.) beserta waktu dan lokasi yang boleh ditampilkan ke publik.
3. **Tampilan “Cek Resi”** di domain utama memanggil **RPC publik** `get_public_tracking(p_tracking_number)` — bukan query langsung ke tabel — agar hanya field yang disetujui yang terbaca.
4. Tidak ada langkah “pilih ekspedisi”; salinan UI menjelaskan bahwa pelacakan adalah untuk jaringan Mahadhika.

---

## 4. Supabase: Auth, skema data, RLS (overview)

### 4.1 Auth

- Identitas pengguna admin di `**auth.users`**.
- Profil aplikasi di `**public.profiles`**, foreign key `profiles.id → auth.users(id)`.
- Kolom `**profiles.role`**: `'user' | 'admin'`. Hanya `'admin'` yang mendapat policy tulis penuh ke `shipments` dan `shipment_events` (melalui fungsi helper `is_admin()` agar evaluasi policy tidak rekursif).

### 4.2 Tabel (ringkas)


| Tabel             | Fungsi                                                 |
| ----------------- | ------------------------------------------------------ |
| `profiles`        | Per-user metadata + role untuk RLS admin               |
| `shipments`       | Satu baris per resi: status saat ini, ETA publik, dll. |
| `shipment_events` | Riwayat event terurut untuk timeline publik            |


Kolom mengikuti **snake_case** di database (lihat migration di repo).

### 4.3 RLS — prinsip

- **Publik:** tidak memberikan `SELECT` langsung ke `shipments` / `shipment_events` untuk `anon`; publik hanya `EXECUTE` pada `**get_public_tracking(text)`** (`SECURITY DEFINER`, `search_path` terkunci), yang merakit JSON aman.
- **Admin (authenticated + `is_admin()`):** `ALL` pada `shipments` dan `shipment_events`.
- **profiles:** user biasa baca/ubah baris baru sendiri; admin dapat mengelola (untuk promote role, dll.) sesuai policy di migration.

### 4.4 Trigger onboarding

- Setelah user baru di `auth.users`, trigger menyiapkan baris `profiles` default (`role = 'user'`). Promosi ke admin dilakukan manual (SQL dashboard / service role) atau alur internal yang aman.

---

## 5. Fase implementasi


| Fase              | Isi kerja                                                                                                        |
| ----------------- | ---------------------------------------------------------------------------------------------------------------- |
| **0 — Scaffold**  | Client Supabase di frontend, migration tabel + RLS + RPC `get_public_tracking`, `.env.example`, dokumentasi ini. |
| **1 — Cek Resi**  | Hubungkan komponen publik ke RPC; empty state & error handling; tidak mengekspos detail internal.                |
| **2 — Admin MVP** | Login Supabase, daftar kiriman, form create/edit shipment, timeline event, validasi `tracking_number`.           |
| **3 — Hardening** | Rate limiting (Edge/API), audit log opsional, backup & indexing review, monitoring.                              |
| **4 — Ops & CI**  | `supabase db push` / pipeline migration, environment staging/production, subdomain + SSL admin.                  |


---

## 6. Kriteria sukses (MVP)

- Publik dapat melacak resi yang ada di DB tanpa login, dengan data konsisten dari RPC.
- Non-admin tidak dapat menyisipkan/mengubah shipment lewat anon key.
- Admin dapat mengelola data setelah login dan `role = admin`.
- Dokumentasi environment dan langkah migrate tersedia untuk tim.

---

## 7. Lampiran teknis (repo)

- Migration: `supabase/migrations/*_admin_dashboard_tracking.sql`
- Client singleton: `src/lib/supabaseClient.ts`
- Variabel: `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY` (lihat `.env.example`)

---

## 8. Riwayat pembaruan (update log)

Bagian ini untuk **pemantauan cepat**: apa yang sudah ada di repo versus apa yang masih mengacu ke fase PRD. Tambahkan entri baru di atas entri lama (urutkan menurun tanggal).

### Update log

- **2026-04-29** — Verifikasi terhadap codebase `mahadhika-web`:
  - **Layout publik vs admin:** `src/App.vue` memuat `PublicLayout` + `RouterView` untuk semua path yang **bukan** prefiks `/admin`; untuk `/admin`, hanya `RouterView` (shell admin tidak membungkus konten dengan header/footer publik).
  - **Router admin:** `src/router/index.js` — parent `/admin` memakai `src/layouts/AdminLayout.vue` (`meta.layout: 'admin'`); child default (`''`) → `src/pages/AdminDashboardPage.vue` (nama rute `admin`, judul meta «Beranda admin»). **Belum ada** rute `/admin/login` di router.
  - **UI admin:** `src/layouts/AdminLayout.vue` — sidebar, header, slot konten `RouterView`; teks sesi masih placeholder (belum terhubung ke auth di layout).
  - **Supabase Auth (logika, composable):** `src/composables/useAdminAuth.js` — inisialisasi sesi + `onAuthStateChange`, baca `profiles.role` via `fetchAdminProfileRole`, `signInAdmin` (`signInWithPassword`, lalu cek `role === 'admin'`; jika bukan admin → `signOut`), `signOutAdmin`, `requireAdminSessionOrSignOut`, `ensureAdminAuthInitialized`. **Catatan:** composable ini **belum** dipakai oleh `AdminLayout`, halaman login, atau `beforeEach` router (guard navigasi belum di kode).
  - **Client Supabase:** `src/lib/supabaseClient.ts` — `getSupabase()` mengembalikan client atau `null` bila env belum diisi; `isSupabaseConfigured()` untuk cek cepat.
  - **Publik / Cek Resi:** `src/components/ShipmentTrackingSection.vue` memanggil RPC `get_public_tracking` melalui `getSupabase()` (selaras Fase 1 PRD).
  - **Yang belum terlihat di repo (sesuai arah Fase 2):** halaman `AdminLoginPage` (atau ekuivalen), rute `/admin/login`, proteksi rute admin (redirect ke login), dan penyambungan header admin ke `session_ref` / nama pengguna.

Ringkasnya: kerangka **SPA admin + split layout** dan **logika auth admin di composable** sudah ada; **alur login UI + guard rute** masih menjadi pekerjaan lanjutan.