# IMDB Movies App

*[Read in English 🇬🇧](README_EN.md)*

Aplikasi berbasis Flutter bergaya modern yang menampilkan tren harian, informasi detail film, serial TV, trailer, pencarian, dan fitur simpan ke daftar favorit. Didukung oleh integrasi mulus dengan The Movie Database (TMDB) API.

**Built by Alvin Zanua Putra**

## Tech Stack

- **Flutter** - UI Toolkit/Framework lintas platform
- **Dart** - Bahasa pemrograman utama
- **HTTP** - Library untuk koneksi dan pemanggilan API
- **SQFlite** - Penyimpanan database lokal SQLite untuk daftar favorit
- **YouTube Player Flutter** - Integrasi pemutaran trailer video di dalam aplikasi
- **Cached Network Image** - Pemuatan dan caching gambar dari web yang efisien

## Features

- **Beranda Awal**: Film Trending, Serial TV tren, dan yang akan segera tayang
- **Pencarian**: Bisa cari film dan serial favorit
- **Detail**: Info pemeran (cast), rating, ulasan, budget, genre, hingga status rilis
- **Streaming Trailer**: Menonton trailer YouTube resmi langsung di dalam halaman detail
- **Daftar Favorit Lokal**: Menyimpan konten kesukaan ke dalam database lokal 
- **Desain**: Dukungan untuk struktur *Clean Architecture* dan penamaan file modular bergaya PascalCase 

## Project Structure

```bash
lib/
├── Core/                   # conf utama
│   ├── Api/                # konstan API (ApiKey.dart)
│   └── Database/           # PDB lokal (NoteDbHelper.dart)
│
├── Screens/                # tampilan utama interface
│   ├── Home/               # beranda 
│   │   ├── HomePage.dart   # File utama layar awal
│   │   └── Sections/       # Potongan widget per komponen beranda (Upcoming, Movie, TvSeries, dll)
│   └── Details/            # tampilan dari film atau serial yang diklik
│
├── Scripts/                # utilitas aja
│   └── UrlPack.dart        # fungsi call api dari imdb
│
├── Widgets/                # UI 
│   ├── CustomDrawer.dart   # Navigasi samping 
│   ├── FavoriteAndShare.dart # Tombol like  
│   ├── ReviewUi.dart       # Interface tata letak kartu ulasan
│   ├── SearchBarFunc.dart  # pencarian aja
│   └── TrailerUi.dart      # Pemutar video trailer
│
└── main.dart               # root awal buat call app utama
```

### Installation

```bash
# Clone repository
git clone https://github.com/alvinzanuaputra/IMDB-Movie-Apps.git
cd IMDB-Movie-Apps
```

### Konfigurasi API (.env Setup)

Meskipun contoh ApiKey.dart disediakan, pastikan Anda menggunakan kredensial TMDB Anda sendiri:

1. Buat akun di [The Movie Database (TMDB)](https://www.themoviedb.org/).
2. Akses pengaturan dan hasilkan *API Key*.
3. Buka file di `lib/Core/Api/ApiKey.dart`.
4. Ganti token di dalam kode:
   `const String apikey = 'MASUKKAN_API_KEY_TMDB_ANDA';`

### Running

```bash
# Instalasi dependencies
flutter pub get

# Jalankan aplikasi (Pastikan config API / .env key sudah diatur)
# 1. Jika menggunakan ApiKey.dart langsung 
flutter run

# 2. Atau, jika setup menggunakan file .env
flutter run --dart-define-from-file=.env
```

### Build to App



## Modul Kunci

### Database Handler (SQFLite)
Untuk menyimpan list Film Favorit, metode ada di dalam `lib/Core/Database/NoteDbHelper.dart`:

Contoh memanggil instance dan memasukkan data:
```bash
final db = await NoteDbHelper.instance.database;
await db.insert('film', {'title': 'Avengers', 'id': 1});
```

### URL Constructor (UrlPack)
Berada di `lib/Scripts/UrlPack.dart`. 

Untuk mengatur formasi parameter link yaitu pemanfaatan string fungsi.

```bash
var getDetail = UrlPack.movieDetails(movie_id);
```

## 📄 License

This project is licensed under the [MIT License](LICENSE) - see the [LICENSE](LICENSE) file for details. Free to use for learning purposes.

---

**Alvin Zanua Putra** - Junior Developer Flutter 2026
