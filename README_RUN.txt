CARA RUN (FIX ERROR 'No plugin found for prefix spring-boot')

1) Pastikan kamu masuk folder backend-java (harus ada file pom.xml)
   Contoh di Windows:
   cd Perpustakaan_Mobile_Flutter_Java_v2\backend-java

2) Jalankan:
   mvn -v
   (pastikan Java = 23)

3) Buat DB MySQL:
   - Import database\perpustakaan.sql (opsional; Spring juga bisa auto-create tabel via ddl-auto=update)

4) Jalankan backend:
   mvn spring-boot:run

Kalau sukses, coba akses:
- http://localhost:8080/api/buku

====================================

FLUTTER (Frontend)
- Masuk folder frontend-flutter
  cd ..\frontend-flutter
- Install deps:
  flutter pub get
- Run emulator:
  flutter run

Catatan:
- Emulator Android akses backend host PC memakai http://10.0.2.2:8080 (sudah diset di ApiService)
