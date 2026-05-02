# PRD — Menu & Manajemen Pengiriman (Admin Console)

**Produk:** Mahadhika Logistik — panel internal Vue 3 + Supabase  
**Versi:** 1.0 · **Tanggal:** 29 Apr 2026

---

## 1. Tujuan

Menyediakan **menu navigasi** dan **halaman operasional** agar staf dapat **melihat dan mengelola pengiriman** (`shipments`) serta **riwayat status** (`shipment_events`) yang sama-sama dipakai oleh fitur publik **Cek Resi** (`get_public_tracking`).

---

## 2. Persona & hak akses

| Peran (`profiles.role`) | Menu Pengiriman | Daftar & detail | Buat / ubah / hapus kiriman | Tambah / ubah event |
| ----------------------- | --------------- | --------------- | --------------------------- | ------------------- |
| **viewer**              | Ya              | Ya (baca saja)  | Tidak                       | Tidak               |
| **operator**            | Ya              | Ya              | Ya                          | Ya                  |
| **admin**               | Ya              | Ya              | Ya                          | Ya                  |

Kebijakan teknis mengikuti migration: `dashboard_has_access()` untuk `SELECT`, `dashboard_can_manage_shipments()` untuk `INSERT`/`UPDATE`/`DELETE` pada `shipments` dan `shipment_events`.

---

## 3. Ruang lingkup fitur

### 3.1 Navigasi (menu)

- Item **“Pengiriman”** di sidebar desktop dan chip navigasi mobile Admin Console.
- Rute: `/admin/pengiriman`.
- Urutan menu: **Dashboard (01) → Pengiriman (02) → Pengguna (03, hanya admin)**.

### 3.2 Halaman Manajemen Pengiriman

1. **Daftar** semua baris `shipments`, diurutkan `updated_at` menurun.
2. **Filter / pencarian**:
   - Teks: mencocokkan `tracking_number` (substring, case-insensitive di klien atau `ilike` jika dipakai).
   - Opsional: filter kasar pada `current_status` (dropdown + “Semua”).
3. **Panel detail** (kiriman terpilih):
   - Field: `tracking_number`, `current_status`, `recipient_city`, `estimated_delivery_date`, `internal_notes`, `created_at` / `updated_at`.
   - **Viewer:** hanya tampil; tanpa tombol simpan/hapus/tambah event.
   - **Operator / admin:** ubah field (kecuali `tracking_number` setelah dibuat — immutable di UI untuk mengurangi risiko resi ganda); tombol **Simpan**.
4. **Riwayat event:** daftar `shipment_events` untuk `shipment_id` terpilih, urut `occurred_at` menurun.
5. **Tambah event** (operator/admin): `status_label`, `location`, `occurred_at` (default sekarang); opsi **samakan status utama** → memperbarui `shipments.current_status`.
6. **Tambah kiriman baru** (operator/admin): form `tracking_number` (wajib, unik), `current_status`, `recipient_city`, `estimated_delivery_date`, `internal_notes`.
7. **Hapus kiriman** (operator/admin): dengan konfirmasi; cascade menghapus event (FK `ON DELETE CASCADE`).

### 3.3 Di luar ruang lingkup (fase ini)

- Impor massal CSV / integrasi TMS eksternal.
- Notifikasi pelanggan / email otomatis.
- Perubahan skema DB baru (memakai kolom yang sudah ada).

---

## 4. Acceptance & non-fungsional

- Pengguna **tanpa** peran dashboard tidak mengakses rute (guard existing `requiresAdminAuth`).
- **Viewer** tidak melihat kontrol mutasi; percobaan langsung ke API akan ditolak RLS.
- Pesan error Supabase ditampilkan ramah (bahasa Indonesia).
- Gaya UI konsisten dengan halaman **Pengguna** dan **AdminLayout** (Tailwind, komponen `btn` jika tersedia).

---

## 5. Implementasi teknis (referensi repo)

- **Rute:** `src/router/index.js` — child di bawah `AdminLayout`, tanpa `requiresRole: 'admin'` agar viewer/operator dapat masuk.
- **Halaman:** `src/pages/AdminShipmentsPage.vue`.
- **Menu:** `src/layouts/AdminLayout.vue`.
- **Data:** `getSupabase().from('shipments'|'shipment_events')` dengan kolom **snake_case**.

---

## 6. Metrik sukses (operasional)

- Operator dapat membuat kiriman dan event baru tanpa query SQL manual.
- Data yang diubah di panel tercermin di **Cek Resi** publik setelah refresh (melalui RPC yang ada).
