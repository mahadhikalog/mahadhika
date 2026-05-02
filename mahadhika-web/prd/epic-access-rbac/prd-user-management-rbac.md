# PRD — Manajemen pengguna & RBAC dashboard Mahadhika

**Versi borang:** 1.0 (diselaraskan dengan implementasi Phase 1 kode ini)  
**Audience:** engineer (Indonesian dokumentasi utama, istilah teknik inglés boleh dipakai bila menjadi konvensi codebase / Supabase)

---

## 1. Tujuan bisnis dan produk

- **Goals (Indonesian):** Pengguna dashboard dikelola oleh admin; akses ke fitur panel mengikuti peran (**role-based access**), mengurangi risiko kesalahan operasi dan kebocoran data.
- **Goals (technical):** Persistensi peran pada `profiles.role`, evaluasi lewat RPC / RLS Postgres, dan guards router Vue agar UI dan perilaku konsisten.

---

## 2. Model peran yang direkomendasikan

Untuk menghindari skema akses yang terlalu rigid (hanya dua nilai (`admin` | `staff`)), kami memakai tiga nilai utama:


| Nilai (`profiles.role`) | Deskripsi                                                                                                                             |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `admin`                 | Akses penuh dashboard termasuk **manajemen pengguna** dan semua CRUD shipments / events sesuai kebijakan.                             |
| `operator`              | Hanya otomasi operasional pengiriman: **CRUD `shipments` dan `shipment_events`**; **tidak** mengubah pengguna lain atau peran mereka. |
| `viewer`                | **Hanya baca** shipments dan events (+ profil sendiri); tidak menulis shipment.                                                       |


**Legacy / migrasi:** nilai Postgres lama `user` telah **dipetakan ke `viewer`** dalam satu migrasi ALTER (lihat migration `extend_profiles_rbac`). Tidak mempertahankan sinonim `user` di constraint — satu sumber kebenaran: `admin` | `operator` | `viewer`.

Selaras dengan constraint baru `CHECK`: `profiles_role_check`.

---

## 3. Permissions matrix (backend + perilaku UX)

Hal ini mencerminkan policy SQL Phase 1 + guard frontend.


| Area                                                                        | `viewer` | `operator` | `admin`                     |
| --------------------------------------------------------------------------- | -------- | ---------- | --------------------------- |
| Masuk `/admin/login` dengan role dashboard                                  | ✅        | ✅          | ✅                           |
| Halaman utama `/admin`                                                      | ✅        | ✅          | ✅                           |
| **Pengguna** `/admin/users` (listing + dropdown peran)                      | ❌        | ❌          | ✅                           |
| `SELECT` shipments / shipment_events (Postgres `dashboard_has_access()`)    | ✅        | ✅          | ✅                           |
| `INSERT`/`UPDATE`/`DELETE` shipments ( `dashboard_can_manage_shipments()` ) | ❌        | ✅          | ✅                           |
| `INSERT`/`UPDATE`/`DELETE` shipment_events                                  | ❌        | ✅          | ✅                           |
| Update profil **sendiri** di `profiles`                                     | ✅        | ✅          | ✅                           |
| Insert / update profile **orang lain** (peran dll.)                         | ❌        | ❌          | ✅ (via RLS + UI admin saja) |


**Catatan RPC:** `admin_list_profiles()` (**SECURITY DEFINER**) menyatukan kolom profil dengan `email` dari `auth.users` hanya ketika `**is_admin()`** benar bagi pemanggil; operator/viewer tidak memanggil fungsi tersebut dari UI.

---

## 4. Siklus hidup pengguna (User lifecycle)

- **Saat ini (Phase 1):** Pembuatan pengguna bisa manual lewat Supabase Dashboard (Authentication) atau signup publik sesuai kebijakan produk; baris di `profiles` tetap dibuat oleh trigger (`handle_new_user`) dengan role default `**viewer`** (setelah migration).
- **Invite & email — Phase 2 (opsional):** Alur invite (email tertaut, onboarding) menggunakan **Edge Function** + template email; tidak mengekpose **service role** di browser client; kunci sensitif tetap server-side dalam Edge atau backend terpisah.

---

## 5. Keamanan

- Client hanya menggunakan **anon key** + sesi JWT user; `**service_role` tidak boleh ada di frontend** (bundled env `VITE_*` atau aplikasi SPA).
- Fungsi definer seperti `admin_list_profiles()` menyaring dengan `WHERE (SELECT public.is_admin())`; audit dan testing perlu menyertakan regressi jika pola diganti.
- **Edge Functions** menjadi tempat sah untuk webhook invite, OTP, dll., tanpa melebihi scope RLS end-user secara tidak sadar dari browser.

---

## 6. Acceptance criteria (singkat)

1. Migrasi Postgres menambah constraint peran baru, memigrasikan baris legacy, dan menyediakan helper SQL yang dipanggil oleh RLS baru.
2. Policy `shipments` / `shipment_events` membezakan pembaca (**viewer**) vs penulis (**operator**, **admin**) sesuai tabel atas.
3. Router Vue membolehkan **semua role dashboard** ke shell `/admin` tetapi route `/admin/users` hanya bisa diisi oleh `**admin`**.
4. Halaman pengguna membaca listing melalui RPC `**admin_list_profiles()`** atau fallback yang setara untuk admin — Phase 1: RPC utama + update `.from('profiles')` bagi admin.

---

## 7. Fase rollout


| Phase                         | Isi ringkas                                                                                                                                                                                 |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Phase 1 (sampai sekarang)** | Migrasi RBAC + RLS; dashboard login multidomain peran (`viewer`/`operator`/`admin`); RPC `admin_list_profiles()`; halaman `/admin/users` dengan kontrol UI admin-only; dokumentasi PRD ini. |
| **Phase 2**                   | Invite + Edge Function email; audit log pergantian role; pembatasan rate / CSRF konsisten dengan stack.                                                                                     |


---

## Referensi cepat dalam repo

- Migrasi utama awal: `supabase/migrations/20260429120000_admin_dashboard_tracking.sql`
- Migrasi RBAC Phase 1: `supabase/migrations/20260429140000_extend_profiles_rbac.sql`
- Frontend auth: `src/composables/useAdminAuth.js`, `src/router/index.js`