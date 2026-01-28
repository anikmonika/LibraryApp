# libraryApp

Aplikasi mobile perpustakaan
- Katalog (dipakai anggota) menampilkan seluruh koleksi.
- Pencatatan peminjaman (oleh petugas): buku, anggota, tanggal pinjam, dan tanggal wajib kembali = 7 hari dari tanggal pinjam.
- Fitur plus: pencarian katalog + penandaan OVERDUEpada daftar peminjaman + tombol Pengembalian.

## 1. Tech

- Java (Android)
- Room (SQLite)
- MVVM (ViewModel + LiveData)

## 2. Cara Menjalankan
### Prasyarat
- Android Studio
- JDK 23

### Langkah
2. Buka Android Studio → Open → pilih folder `LibraryApp`.
3. Tunggu **Gradle Sync** selesai.
4. Jalankan:
   - pilih device emulator
   - klik **Run ▶**.

> Kalau dijalankan via terminal:
- Windows: `gradlew.bat assembleDebug`
- Mac/Linux: `./gradlew assembleDebug`


## 2. Cara Pakai (User Flow)
### 2.1 Pilih Peran
Saat aplikasi dibuka: pilih salah satu:
- **Anggota** → melihat katalog & search.
- **Petugas** → akses menu petugas.

### 2.2 Anggota: Katalog
- Halaman katalog menampilkan:
  - Judul, penulis, tahun
  - Tersedia: `available/total`
- Search bar: cari berdasarkan judul atau penulis.

### 2.3 Petugas: Peminjaman
- Masuk Petugas → **Peminjaman**
- Klik **Tambah Peminjaman**
  - input *Nama anggota*
  - input *Judul buku* (harus ada di katalog)
- Sistem otomatis:
  - set `borrowDate = sekarang`
  - set `dueDate = borrowDate + 7 hari`
  - mengurangi stok `availableCopies` buku
- Daftar peminjaman menandai **OVERDUE** jika:
  - belum dikembalikan, dan
  - tanggal sekarang > dueDate
- Tombol **Pengembalian**:
  - set `returned=true`
  - stok buku bertambah

## 3. Desain Data

### 3.1 ERD

<img width="495" height="184" alt="erd" src="https://github.com/user-attachments/assets/06b8e6b0-c050-4647-8b96-6c450c263990" />

**Tabel utama:**
- `books`
- `members`
- `loans`

Relasi:
- 1 Member bisa punya banyak Loan
- 1 Book bisa dipinjam di banyak Loan (di waktu yang berbeda)

### 3.2 Aturan Peminjaman
- Due date: `borrowDate + 7 hari`
- Jika `availableCopies == 0` → peminjaman ditolak

---

## 4. Class Diagram

<img width="1604" height="279" alt="class-diagram" src="https://github.com/user-attachments/assets/a7bf2b9d-5a72-4cdd-ae76-74596b16a936" />

Ringkasnya:
- **UI (Activity + Adapter)** hanya menampilkan data & menerima input.
- **ViewModel** jembatan UI ↔ Repository.
- **Repository** mengatur logika bisnis (stok, due date, return).
- **Room** menyimpan data.

## 5. Struktur Folder

app/src/main/java/com/example/simplelibrary/
  data/
    entity/ (Book, Member, Loan)
    dao/    (BookDao, MemberDao, LoanDao)
    dto/    (LoanRow join result)
    AppDatabase.java
    LibraryRepository.java
  ui/
    RoleSelectActivity.java
    member/ (MemberHomeActivity, CatalogViewModel, BookAdapter)
    staff/  (StaffHomeActivity, StaffLoansActivity, LoansViewModel, LoanAdapter)
  util/DateUtils.java
docs/diagrams/
  erd.png
  class-diagram.png

## 6. Unit Testing & Scenario Testing

### 6.1 Unit Test (JUnit)
Lokasi: `app/src/test/java/.../DateUtilsTest.java`

Yang diuji:
- perhitungan `addDays()`
- logika `isOverdue()`

Jalankan:
- Android Studio → Gradle → `testDebugUnitTest`
- atau terminal: `./gradlew test`

### 6.2 Unit Testing 

<img width="1161" height="463" alt="Screenshot 2026-01-28 104920" src="https://github.com/user-attachments/assets/2de14a69-c09b-4d80-b93a-fa325c0db9a2" />


Mohon Maaf Pak belum selesai karena keterbatasan waktu 