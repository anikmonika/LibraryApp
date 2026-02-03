DOKUMENTASI LENGKAP
Aplikasi Mobile Perpustakaan (LibraryApp)
1. Gambaran Umum Sistem
1.1 Latar Belakang
Aplikasi ini dibuat untuk memenuhi kebutuhan perpustakaan sederhana yang membutuhkan:

Katalog koleksi buku untuk anggota
Pencatatan peminjaman buku oleh petugas
Pengelolaan tanggal pinjam dan tanggal kembali otomatis (7 hari)
Sistem offline (tanpa server)
Aplikasi dirancang ringan, jelas, dan mudah dinilai, fokus ke alur bisnis perpustakaan, bukan UI kompleks.

1.2 Tujuan Sistem
Memudahkan anggota melihat katalog buku

Membantu petugas mencatat peminjaman & pengembalian

Menjamin data konsisten (stok, due date, status)

Dapat dijalankan langsung tanpa konfigurasi server

2. Teknologi & Bahasa Pemrograman
2.1 Bahasa Pemrograman
Komponen	Bahasa
Aplikasi Mobile	Dart
Framework	Flutter
Database	SQLite (offline)
Tidak menggunakan Java backend, MySQL, API, atau server eksternal.

2.2 Technology Stack
Layer	Teknologi
UI	Flutter Material
State Management	StatefulWidget (sederhana & eksplisit)
Database	sqflite
Path DB	path_provider
Testing	flutter_test
Build Android	Gradle + Kotlin
3. Arsitektur Aplikasi
3.1 Pola Arsitektur
Digunakan layered architecture sederhana:

UI (Screens)
│
├── Service / Logic
│
├── Database Helper
│
└── SQLite Database

Kenapa tidak MVVM penuh?
- Proyek kecil
- Fokus ke logika bisnis
- Lebih mudah dipahami & dinilai

4. Struktur Folder Project
lib/
├── main.dart
├── db/
│   └── db.dart
├── models/
│   ├── book.dart
│   ├── member.dart
│   └── loan.dart
├── screens/
│   ├── login_page.dart
│   ├── member_home_page.dart
│   ├── staff_home_page.dart
│   ├── catalog_page.dart
│   ├── create_loan_page.dart
│   ├── loan_history_page.dart
│   └── member_loans_page.dart
└── utils/
    └── date_utils.dart

5. Database Design (ERD)
5.1 Tabel & Relasi
- books
| Field  | Tipe         |
| ------ | ------------ |
| id     | INTEGER (PK) |
| title  | TEXT         |
| author | TEXT         |
| stock  | INTEGER      |
- members
| Field | Tipe         |
| ----- | ------------ |
| id    | INTEGER (PK) |
| name  | TEXT         |
- loans
| Field     | Tipe                |
| --------- | ------------------- |
| id        | INTEGER (PK)        |
| member_id | INTEGER (FK)        |
| loan_date | INTEGER (timestamp) |
| due_date  | INTEGER             |
| status    | TEXT                |
- loan_items
| Field   | Tipe         |
| ------- | ------------ |
| id      | INTEGER (PK) |
| loan_id | INTEGER (FK) |
| book_id | INTEGER (FK) |

5.2 Gambar ERD

6. Use Case Diagram
6.1 Aktor
Anggota
Petugas

6.2 Use Case Anggota
Login
Melihat katalog buku
Mencari buku
Melihat peminjaman sendiri
Melihat status overdue

6.3 Use Case Petugas
Login
Membuat peminjaman
Memilih anggota
Memilih banyak buku
Mengembalikan buku
Melihat riwayat peminjaman


7. Alur Bisnis (Workflow)
7.1 Alur Peminjaman
Petugas login
Pilih menu Tambah Peminjaman
Pilih anggota
Pilih satu atau lebih buku

Sistem:
Simpan loan
Hitung due date = loan_date + 7 hari
Kurngi stok buku
Status awal = PINJAM

7.2 Alur Pengembalian
Petugas buka riwayat peminjaman
Klik Kembalikan
Sistem:
Status jadi KEMBALI
Stok buku +1
Jika lewat due date → ditandai OVERDUE

8. Daftar Fitur Aplikasi
8.1 Fitur Utama
Login multi-role
Katalog buku
Search buku
Multi-book loan
Due date otomatis
Overdue detection
Offline database

8.2 Fitur Tambahan (Nilai Plus)
Label OVERDUE otomatis
Seed data awal (buku & anggota)
Validasi stok
UI sederhana & konsisten

9. Test Case (Scenario & Unit)
9.1 Scenario Testing (Manual)


10. Cara Cek Database (SQLite)
Langkah:

Jalankan aplikasi
Android Studio → Device Explorer
Buka:
data/data/com.example.simple_library_offline/app_flutter/

11. Cara Menjalankan Aplikasi
11.1 Prasyarat
Flutter SDK
Android Studio
Emulator / Device
JDK 17

11.2 Langkah Run
flutter pub get
flutter run




