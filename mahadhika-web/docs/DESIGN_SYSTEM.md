# Design system — Mahadhika web

Dokumen ini merangkum aturan UI/UX yang konsisten di repo Vue. Perbarui bersama perubahan pola yang disepakati tim.

---

## Modal (dialog overlay)

### Perilaku wajib

1. **Klik di luar konten modal (area overlay / backdrop)** menutup modal — pengguna mengharapkan perilaku ini di desktop maupun mobile.
2. **Klik di dalam panel modal** tidak menutup modal: hentikan propagasi klik pada pembungkus konten (`role="dialog"`).
3. **Saat submit / operasi berjalan**, penutupan via overlay atau tombol Batal bisa dinonaktifkan: pemanggilan `close` mengembalikan tanpa efek sampai `_loading` selesai (sesuai kebutuhan halaman).
4. **Teleport**: render modal ke `<body>` agar stacking context (`z-index`) dan scroll halaman utama tidak bermasalah.
5. **Aksesibilitas**: set `role="dialog"`, `aria-modal="true"`, dan `aria-labelledby` mengarah ke judul modal.

### Implementasi teknis (Vue 3)

Gunakan **satu** lapisan full-screen sebagai overlay bermedia (warna gelap semi-transparan) **sekaligus** area klik untuk menutup:

- Pada elemen overlay: `@click.self="closeModal"`  
  **`self`** memastikan handler hanya jalan ketika target klik tepat adalah overlay itu sendiri — bukan anaknya (panel putih).
- Pada panel konten langsung dengan `role="dialog"`: `@click.stop` agar klik di dalam konten tidak mem-bubble ke overlay.

Contoh struktur ringkas:

```html
<Teleport to="body">
  <div
    v-if="modal_open_ref"
    class="fixed inset-0 z-[100] flex min-h-full items-center justify-center overflow-y-auto bg-slate-900/50 p-4 backdrop-blur-[1px]"
    role="presentation"
    @click.self="closeModal"
  >
    <div role="dialog" aria-modal="true" aria-labelledby="modal-title-id" @click.stop>
      <h2 id="modal-title-id">Judul</h2>
      <!-- konten -->
    </div>
  </div>
</Teleport>
```

**Hindari** pola dua lapisan yang menumpuk (`backdrop` + `flex wrapper` tanpa `@click.self` pada wrapper): lapisan atas transparan sering menangkap klik sehingga klik pada area gelap tidak sampai ke backdrop — overlay **tunggal** dengan `@click.self` lebih dapat diandalkan.

### Varian layar kecil

Untuk modal “bottom sheet” (`items-end` pada mobile), tetap pola yang sama: overlay satu elemen dengan `flex items-end justify-center`; area gelap di atas kartu merupakan bagian overlay sehingga `@click.self` tetap menutup.

---

## Referensi cepat dalam repo

- Modal pengguna: `src/pages/AdminUsersPage.vue` (`create_user_modal_open_ref`, `closeCreateUserModal`).
