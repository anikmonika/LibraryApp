# SimpleLibrary Offline (Flutter-only)

Aplikasi perpustakaan **tanpa backend** (cukup `flutter run`). Database memakai **SQLite (sqflite)** di perangkat.

## Fitur
- Login **Anggota** & **Petugas**
- Katalog buku (list semua koleksi)
- Search katalog (judul/penulis) + urut **A–Z**
- Petugas: buat peminjaman (pilih anggota + multi-buku)
- Otomatis hitung **tanggal kembali = tanggal pinjam + 7 hari**
- Riwayat peminjaman + label **OVERDUE**
- Pengembalian (status kembali + stok kembali)

## Akun default
- Petugas: `petugas / 123`
- Anggota: `anggota / 123`

## Cara run
```bash
flutter pub get
flutter run
```

> Data contoh otomatis di-seed saat aplikasi pertama kali dibuka.
