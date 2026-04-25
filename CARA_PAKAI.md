# 📖 CARA PAKAI - RidNovel Project
**Farid Dhiya Fairuz — 247006111058 — B**

---

## 📁 Struktur ZIP ini

```
ridnovel_full/
├── backend/              ← Backend Node.js (jalankan ini dulu)
│   ├── server.js
│   ├── .env              ← Konfigurasi database & JWT
│   ├── database.sql      ← Import ini ke MySQL
│   ├── config/
│   ├── controllers/
│   ├── middleware/
│   ├── models/
│   └── routes/
└── flutter_app/          ← Flutter app (copy isinya ke project Flutter)
    ├── pubspec.yaml
    ├── android/
    └── lib/
```

---

## LANGKAH 1 — Setup Database MySQL

1. Buka **phpMyAdmin** atau **MySQL Workbench** atau **HeidiSQL**
2. Buat database baru bernama `webnovel_db` (atau jalankan file SQL)
3. Import file `backend/database.sql`
   - Di phpMyAdmin: klik **Import** → pilih file `database.sql` → Go
4. ✅ Selesai. Database sudah ada beserta data contoh 5 novel.

---

## LANGKAH 2 — Setup & Jalankan Backend

### Buka terminal, masuk ke folder backend:
```
cd path\ke\ridnovel_full\backend
```

### Install dependencies:
```
npm install
```

### Cek & edit file `.env` sesuai konfigurasi MySQL kamu:
```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=         ← isi password MySQL kamu (kosong kalau tidak ada)
DB_NAME=webnovel_db
JWT_SECRET=ridnovel_secret_key_247006111058
JWT_EXPIRES_IN=24h
```

### Jalankan backend:
```
node server.js
```

### ✅ Harus muncul:
```
🚀 RidNovel API berjalan di http://localhost:3000
```

### Jangan tutup terminal ini selama testing!

---

## LANGKAH 3 — Setup Flutter Project

### 3a. Buat Flutter project baru:
Buka terminal BARU di folder yang kamu inginkan:
```
flutter create ridnovel
cd ridnovel
```

### 3b. Copy file dari ZIP:
Dari folder `flutter_app/` di ZIP ini, copy:
- Seluruh folder `lib/` → timpa folder `lib/` di project Flutter
- File `pubspec.yaml` → timpa `pubspec.yaml` di project Flutter
- Folder `android/app/src/main/AndroidManifest.xml` → timpa yang sudah ada

### 3c. Install dependencies Flutter:
```
flutter pub get
```

---

## LANGKAH 4 — Jalankan di Emulator

### 4a. Buka Android Studio
### 4b. Buka project ridnovel (folder Flutter)
### 4c. Buka Device Manager → Start emulator Pixel_4
### 4d. Tunggu emulator boot sampai muncul home screen Android
### 4e. Klik tombol ▶ Run (hijau) di toolbar atas

### ✅ Harus muncul splash screen RidNovel

---

## LANGKAH 5 — Test Aplikasi

1. **Register** akun baru
2. **Login** dengan akun yang dibuat
3. Lihat daftar novel (5 novel sudah ada dari database)
4. Tap novel untuk lihat detail
5. Tambah novel baru dengan tombol FAB (+)
6. Edit/hapus novel dari halaman detail
7. Coba search novel

---

## ⚠️ TROUBLESHOOTING

### Error: "Connection refused" / tidak bisa konek ke API
- Pastikan backend sudah jalan (`node server.js`)
- Untuk emulator Android, `10.0.2.2` = localhost laptop → sudah benar di kode
- Untuk HP fisik: ganti di `lib/services/api_service.dart`:
  ```dart
  static const String baseUrl = 'http://192.168.x.x:3000';
  // Ganti dengan IP laptop kamu (cek dengan: ipconfig di Windows)
  ```

### Error: "Database connection failed"
- Cek file `.env` → pastikan DB_USER dan DB_PASSWORD benar
- Pastikan MySQL sudah berjalan (cek di XAMPP/WAMP/services)
- Pastikan database `webnovel_db` sudah dibuat

### Error saat `flutter pub get`
- Pastikan Developer Mode Windows sudah aktif
- Jalankan: `start ms-settings:developers`
- Toggle Developer Mode → ON
- Ulangi `flutter pub get`

### Emulator tidak muncul di Android Studio
- Tutup semua jendela emulator yang terbuka
- Di Task Manager, kill proses `qemu-system` kalau ada
- Restart Android Studio
- Start emulator dari Device Manager

---

## 📡 Endpoint API

| Method | URL | Keterangan | Auth |
|--------|-----|------------|------|
| POST | /register | Daftar akun | ❌ |
| POST | /login | Login, dapat JWT | ❌ |
| GET | /novels | List semua novel | ✅ |
| GET | /novels/:id | Detail novel | ✅ |
| POST | /novels | Tambah novel | ✅ |
| PUT | /novels/:id | Edit novel | ✅ |
| DELETE | /novels/:id | Hapus novel | ✅ |
