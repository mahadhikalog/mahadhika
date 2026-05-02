# PRD — First-party Web Analytics (Owned Telemetry)

**Produk:** Mahadhika web (Vue 3 + Vite SPA, Supabase)  
**Stack teknis:** Vue Router (instrumentasi navigasi), Supabase (Postgres, Edge Functions, RLS), konvensi kode: fungsi JS `camelCase`, variabel JS `snake_case`, komponen Vue `PascalCase`, kolom DB `snake_case`  
**Dokumen:** kebutuhan produk untuk menggantikan/mengurangi ketergantungan pada Google Analytics dengan **analitik first-party** yang dikendalikan sepenuhnya oleh Mahadhika.

---

## 1. Problem statement

Tim membutuhkan visibilitas dasar terhadap perilaku pengunjung (lalu lintas, halaman populer, sumber rujukan) untuk keputusan pemasaran dan operasi produk, namun **mengandalkan solusi pihak ketiga** (mis. Google Analytics) menimbulkan risiko privasi, ketergantungan vendor, fragmentasi kepatuhan (cookie/third-party), dan kontrol terbatas atas data mentah. Mahadhika sudah membangun atas **Supabase + SPA**; analitik sebaiknya **dimasukkan ke dalam data plane yang sama**, dengan pola ingestion yang aman dan kebijakan data yang eksplisit.

---

## 2. Goals & non-goals

### 2.1 Goals

- Menangkap **page view** dan **event kustom** (opsional) dari SPA tanpa mengirim PII yang tidak perlu.
- Menyediakan **identitas pengunjung first-party** (visitor / session) untuk agregasi metrik dasar, dengan **minimisasi data** dan dokumentasi kebijakan “no PII” yang jelas untuk engineer.
- Menggunakan **jalur ingestion terkendali** (disarankan: **Supabase Edge Function** atau API backend), bukan insert `anon` langsung ke tabel sensitif dari browser.
- Mendukung **retensi, indeks, dan kebijakan RLS** yang konsisten dengan pola keamanan repo (service role tidak di browser; akses baca agregat hanya untuk peran internal).

### 2.2 Non-goals (fase ini)

- Paritas fitur dengan GA360 / GA4 (funnel lanjutan, eksplorasi bebas, BigQuery export bawaan).
- **Model atribusi atau ML** untuk kampanya.
- Pelacakan lintas situs pihak ketiga atau jaringan iklan real-time.
- Menyimpan konten form bebas, email, nomor telepon, atau alamat dalam tabel analitik (kecuali dikecualikan secara eksplisit oleh hukum/produk — default: **tidak**).

---

## 3. Personas / pengguna


| Persona                               | Kebutuhan utama                                                                                |
| ------------------------------------- | ---------------------------------------------------------------------------------------------- |
| **Tim pemasaran / growth (internal)** | Volume sesi, page views, top paths, referer/UTM ringkas untuk kampanye.                        |
| **Admin produk / engineering**        | Integritas pipeline, debugging volume, deteksi anomaly/spam, biaya DB.                         |
| **Compliance / product owner**        | Garis besar GDPR/consent, retensi, dan bukti minimisasi data (bukan nasihat hukum — lihat §7). |


---

## 4. User stories

- Sebagai **visitor anonim**, saya ingin situs mencatat kunjungan saya **tanpa** mengumpulkan identitas personal yang tidak perlu, agar privasi saya dihormati sesuai kebijakan situs.
- Sebagai **staf pemasaran**, saya ingin melihat **berapa sesi dan page views** per periode serta **halaman teratas**, agar saya bisa menilai performa konten.
- Sebagai **staf pemasaran**, saya ingin melihat **sumber rujukan** (referer atau kampanye berparameter) pada tingkat agregat, agar saya bisa mengarahkan anggaran.
- Sebagai **admin teknis**, saya ingin **event kustom** (mis. klik CTA penting) dapat dikirim dengan skema stabil tanpa mengekspos kunci service di klien.
- Sebagai **admin teknis**, saya ingin ada **perlindungan terhadap spam/abuse** pada endpoint ingestion agar biaya penyimpanan tidak meledak.
- Sebagai **engineer**, saya ingin instrumentasi terpusat di **Vue Router** (afterEach / navigasi) agat konsisten di seluruh rute SPA.

---

## 5. Functional requirements

### 5.1 Page views (MVP)

- Klien SPA mengirim payload ringkas setelah navigasi sukses: path (dan hash/query jika disepakati), judul dokumen opsional, timestamp klien, **visitor_id** & **session_id** first-party, meta teknis (user-agent singkat / viewport opsional — hanya jika dibenarkan kebijakan minimisasi).
- **Satu** event “page_view” per transisi rute (debounce / ignore duplicate jika router memicu ganda).
- Respect **“do not track” / consent gate** (lihat §7): jika pengguna belum setuju atau mode ditolak, **jangan** memanggil ingestion.

### 5.2 Event kustom (opsional, fase berikutnya MVP)

- Klien dapat mengirim event bernama (mis. `cta_click`, `tracking_lookup`) dengan **properti JSON terbatas** (schema atau allowlist diserver) untuk mencegah penyimpanan arbitrer besar.

### 5.3 Visitor & session identity (first-party, no PII)

- **visitor_id:** UUID atau string acak persisten di **first-party storage** (mis. `localStorage` / cookie first-party HttpOnly jika disediakan backend) — tidak boleh email/user id Supabase auth untuk pengunjung anonim.
- **session_id:** ID sesi browsing (regenerated setelah idle window yang disepakati, mis. 30 menit tidak aktif atau restart browser — detail implementasi).
- **Tidak** menyimpan: nama, email, alamat IP lengkap sebagai kolom teks jika dapat dihindari (jika IP disimpan untuk abuse, pertimbangkan hash/truncation + retensi singkat — keputusan open question §11).

### 5.4 Ingestion path

- **Disarankan:** klien memanggil **Supabase Edge Function** (atau route API terpisah) dengan:
  - validasi body (schema),
  - **shared secret** ringan atau **Supabase JWT** untuk membatasi abuse (opsi: anon + rate limit ketat vs signed token),
  - insert ke Postgres memakai **service role** hanya di lingkungan server function, bukan di browser.
- **Tidak disarankan:** policy RLS yang membuka `INSERT` publik tanpa batas ke tabel event mentah (risiko spam dan biaya).

### 5.5 Rate limiting, spam, dan abuse

- Rate limit per **IP** dan/atau per **visitor_id** di Edge Function (token bucket / fixed window).
- Batasi ukuran body dan kedalaman JSON properti.
- **Allowlist origin** (CORS) untuk domain produksi/staging.
- Opsional: deteksi heuristik (burst dari satu subnet, user-agent kosong) → drop atau sampling.
- Retensi dan agregat roll-up mengurangi dampak data historis yang membengkak.

---

## 6. Data model sketch (Postgres, `snake_case`)

Dua pendekatan valid; pilih satu untuk konsistensi migrasi:

**Opsi A — Tabel tunggal `analytics_events`**


| Kolom          | Tipe                 | Catatan                                       |
| -------------- | -------------------- | --------------------------------------------- |
| `id`           | `uuid` / `bigserial` | PK                                            |
| `occurred_at`  | `timestamptz`        | waktu server; boleh juga `client_occurred_at` |
| `event_type`   | `text`               | `page_view`, `custom`, …                      |
| `visitor_id`   | `text` / `uuid`      | first-party, bukan PII                        |
| `session_id`   | `text` / `uuid`      |                                               |
| `path`         | `text`               | path SPA                                      |
| `query_string` | `text` nullable      | minimisasi: opsional atau hashed params       |
| `referrer`     | `text` nullable      | origin/path saja bila memungkinkan            |
| `event_name`   | `text` nullable      | untuk custom                                  |
| `properties`   | `jsonb` nullable     | dibatasi ukuran                               |
| `ingested_at`  | `timestamptz`        | default `now()`                               |


**Opsi B — Pisah `analytics_page_views` + `analytics_custom_events`**

- Normalisasi lebih jelas; join agregat sedikit lebih rumit. Kolom inti mengikuti pola yang sama (`visitor_id`, `session_id`, waktu, path, dll.).

**Indeks (disarankan)**

- `(occurred_at DESC)` atau BRIN untuk tabel besar deret waktu.
- `(event_type, occurred_at DESC)`.
- `(path, occurred_at DESC)` untuk laporan top paths (atau materialized view harian).
- `(visitor_id, occurred_at)` dengan pertimbangan privasi vs performa.

**Retensi**

- Policy produk: mis. **90 hari raw**, lalu **agregat harian** ke tabel ringkas (`analytics_daily_rollups`) atau hapus partisi > N hari (open question §11).

---

## 7. Security & privacy

### 7.1 RLS stance

- Tabel event mentah: **tanpa akses baca langsung** untuk `anon` dan untuk pengguna publik.
- Akses baca ke **agregat** atau **view** dibatasi kepada `authenticated` dengan `**profiles.role`** yang diizinkan (mis. `admin` saja pada MVP dashboard internal), menggunakan view atau RPC `SECURITY DEFINER` yang hanya mengembalikan metrik agregat.
- Tulis ke tabel mentah hanya dari **service role** di Edge Function / backend — selaras prinsip PRD admin: **service role tidak ada di bundle VITE.**

### 7.2 GDPR / consent (tingkat tinggi — bukan nasihat hukum)

- Analitik berbasis cookie/storage first-party dapat memerlukan **dasar hukum** (mis. consent atau kepentingan sah) tergantung yurisdiksi dan interpretasi “strictly necessary”.
- Produk harus mendukung **banner / preferensi consent** yang mengontrol apakah skrip ingestion dijalankan (lihat §5.1).
- Sediakan mekanisme **penghapusan** atau **anonimisasi** berdasarkan permintaan subjek data sesuai kebijakan perusahaan (detail proses operasional di luar ruang lingkup dokumen ini).

### 7.3 Data minimization

- Kumpulkan hanya field yang ada di §6; hindari fingerprinting berlebihan; dokumentasikan setiap tambahan kolom dengan review privasi.

---

## 8. Reporting

### 8.1 MVP metrics (tanpa UI dashboard wajib)

- **Sesi** (perkiraan dari `session_id`).
- **Page views** total dan per `path`.
- **Referrer** top (truncated/host-level).
- **Periode** harian/mingguan (query RPC atau SQL internal).

### 8.2 Phased roadmap


| Fase                    | Deliverable                                                                            |
| ----------------------- | -------------------------------------------------------------------------------------- |
| **MVP instrumentation** | Hook Vue Router + Edge ingestion + tabel + rate limit + retensi dasar.                 |
| **MVP reporting**       | Query agregat manual / notebook / Supabase SQL; export CSV opsional.                   |
| **Dashboard**           | Halaman admin Vue (komponen `PascalCase`) menampilkan grafik & tabel dari RPC agregat. |
| **Polish**              | Sampling under load, roll-up terjadwal, alerting volume anomaly.                       |


---

## 9. Dependencies

- **Vue Router:** `afterEach` (atau guard setara) memanggil modul telemetry `camelCase` yang membaca variabel state `snake_case`, mengirim batch ringan ke endpoint ingestion.
- **Supabase:** Edge Function + Postgres migrations; client hanya env publik umum (`VITE_SUPABASE_URL` + anon jika dipakai untuk auth terpisah — tidak untuk insert langsung analytics).
- **Konvensi:** fungsi helper telemetry `trackPageView`, variabel lokal `visitor_id`, komponen tidak wajib pada Fase MVP kecuali dashboard.

---

## 10. Out of scope

- Paritas fitur **Google Analytics** (segmen lanjutan, multi-channel attribution built-in, remarketing audiences).
- **Machine learning** atau model atribusi otomatis.
- Pemrosesan stream real-time untuk iklan (sub-detik).
- Menyimpan **PII** di tabel analitik sebagai default.

---

## 11. Success metrics

- **Coverage:** ≥ 95% navigasi rute utama menghasilkan `page_view` valid (diukur di staging dengan tes e2e ringan).
- **Integrity:** 0 eksposur service role di bundle frontend; skrip audit dependensi tetap bersih.
- **Cost:** volume write harian berada di bawah anggaran baris DB yang disepakati (token rate limit efektif).
- **Adoption:** tim internal memakai laporan MVP minimal 1× per minggu untuk keputusan konten (survey/OKR produk).

---

## 12. Open questions

- Apakah **IP** disimpan untuk abuse saja, dan jika ya, **hash + TTL** berapa hari?
- Jendela **session idle** tepatnya (perbandingan industri vs beban server)?
- Apakah **UTM** disimpan penuh atau hanya kampanye `utm_campaign` ter-normalisasi?
- Single vs multi-tenant: jika ada banyak properti domain, apakah perlu kolom `site_key`?
- Jadwal **roll-up** (cron Edge vs `pg_cron`) dan SLA query dashboard.
- Kebutuhan **DSAR** (data subject access) praktis untuk ID visitor acak — apakah “tidak dapat diidentifikasi” menjadi posisi produk?

---

## 13. Riwayat pembaruan (update log)

Tambahkan entri baru di atas entri lama.

### Update log

- **2026-05-02** — Versi awal PRD first-party web analytics (belum diimplementasikan; baseline kebutuhan untuk review tim).