# IMDB Movies App

*[Baca dalam Bahasa Indonesia 🇮🇩](README.md)*

Flutter-based application that displays daily trending movies, TV series details, trailers, a smart search feature, and local favorite list capabilities. Powered integration with The Movie Database (TMDB) API.

**Built by Alvin Zanua Putra**

## Tech Stack

- **Flutter** - Cross-platform UI Toolkit/Framework
- **Dart** - Primary programming language
- **HTTP** - Library for API connection and calling
- **SQFlite** - Local SQLite database storage for favorites
- **YouTube Player Flutter** - Embedded video trailer playback integration
- **Cached Network Image** - Efficient web image loading and caching

## Features

- **Interactive Home Screen**: Displays Trending Movies, Trending TV Series, and Upcoming releases
- **Smart Search**: Easily discover your favorite movies and series
- **In-depth Details**: Provides cast info, ratings, reviews, budget, genres, and release status
- **Trailer Streaming**: Watch official YouTube trailers directly on the details page
- **Local Favorites List**: Save your favorite content into a local database accessible anytime
- **Aesthetic Design**: Supports *Clean Architecture* structure and modular PascalCase file naming
- **Indonesian Language**: Interface optimized with native language localization

## Project Structure

```bash
lib/
├── Core/                   # Main configuration and infrastructure
│   ├── Api/                # API constants (ApiKey.dart)
│   └── Database/           # Local Database Manager (NoteDbHelper.dart)
│
├── Screens/                # Main UI screens
│   ├── Home/               # Home screen 
│   │   ├── HomePage.dart   # Main home file
│   │   └── Sections/       # Component snippets (Upcoming, Movie, TvSeries, etc.)
│   └── Details/            # Detail view for clicked movie or series
│
├── Scripts/                # Pure logic utilities
│   └── UrlPack.dart        # Helper functions to build TMDB API URLs
│
├── Widgets/                # Reusable UI components
│   ├── CustomDrawer.dart   # Side navigation
│   ├── FavoriteAndShare.dart # Action buttons
│   ├── ReviewUi.dart       # Review card layout interface
│   ├── SearchBarFunc.dart  # Adaptive search form
│   └── TrailerUi.dart      # Video trailer player
│
└── main.dart               # Flutter app entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (Version ~3.0.0 or latest)
- Dart SDK
- Android Studio / VS Code
- Physical device or Emulator

### Installation

```bash
# Clone repository
git clone https://github.com/alvinzanuaputra/IMDB-Movie-Apps.git
cd IMDB-Movie-Apps
```

### API Configuration (.env Setup)

Although an `ApiKey.dart` example is provided, make sure you use your own TMDB credentials:

1. Create an account at [The Movie Database (TMDB)](https://www.themoviedb.org/).
2. Access settings and generate your *"API Key"*.
3. Open `lib/Core/Api/ApiKey.dart`.
4. Replace the token inside the code:
   ```dart
   const String apikey = 'INSERT_YOUR_TMDB_API_KEY_HERE';
   ```

### Running

```bash
# Install dependencies
flutter pub get

# Run the application (Make sure API / .env config is set)
# 1. If using the standard ApiKey.dart directly
flutter run

# 2. Or, if you use a .env file setup
flutter run --dart-define-from-file=.env
```

### Build to App

Use the following commands to build Android and iOS apps, including output locations:

```bash
# Android APK (release)
flutter build apk --release

# Android APK (release, split per ABI - smaller size)
flutter build apk --release --split-per-abi

# Android App Bundle (AAB) for Play Store
flutter build appbundle --release

# iOS .app (requires macOS + Xcode)
flutter build ios --release

# iOS .ipa (requires macOS + Xcode)
flutter build ipa --release
```

Build output paths:

- `build/app/outputs/flutter-apk/app-release.apk`
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (with `--split-per-abi`)
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` (with `--split-per-abi`)
- `build/app/outputs/flutter-apk/app-x86_64-release.apk` (with `--split-per-abi`)
- `build/app/outputs/bundle/release/app-release.aab`
- `build/ios/iphoneos/Runner.app`
- `build/ios/ipa/*.ipa`

Notes:

- iOS builds can only be created on macOS with Xcode installed.
- If your project uses `.env`, append: `--dart-define-from-file=.env`.

## Key Modules

### Database Handler (SQFLite)
To store the Favorite Movies list, the methods are located in `lib/Core/Database/NoteDbHelper.dart`:

Example of instantiating and inserting data:
```dart
final db = await NoteDbHelper.instance.database;
await db.insert('film', {'title': 'Avengers', 'id': 1});
```

### URL Constructor (UrlPack)
Located in `lib/Scripts/UrlPack.dart`. It manages link parameter formations via string functions.
```dart
var getDetail = UrlPack.movieDetails(movie_id);
```

## Documentation

<p align="center">
   <img src="/assets/docs/doc2.jpeg" alt="Documentation 2" width="19%" />
   <img src="/assets/docs/doc1.jpeg" alt="Documentation 1" width="19%" />
   <img src="/assets/docs/doc3.jpeg" alt="Documentation 3" width="19%" />
   <img src="/assets/docs/doc4.jpeg" alt="Documentation 4" width="19%" />
   <img src="/assets/docs/doc5.jpeg" alt="Documentation 5" width="19%" />
</p>

## License

This project is licensed under the [MIT License](LICENSE) - see the [LICENSE](LICENSE) file for details. Free to use for learning purposes.

---

**Alvin Zanua Putra** - Junior Developer Flutter 2026