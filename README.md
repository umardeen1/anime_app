# 🎬 Anime Hub - Flutter

A modern Anime discovery application built with Flutter using **BLoC Architecture** and **Jikan API**. This app allows users to explore trending anime, search for titles, and watch trailers.

## ✨ Key Features
- **Dynamic Home:** Features trending and upcoming anime with a random hero header.
- **Search Functionality:** Real-time anime search using the Jikan API.
- **New Releases:** Dedicated page to track the latest anime movies and series.
- **Deep Details:** Comprehensive view including synopsis, ratings, and genres.
- **Trailer Support:** Direct integration to watch trailers via YouTube.
- **Modern UI:** Dark theme with Netflix-style layout and **Shimmer** loading effects.

## 🛠️ Tech Stack
- **Framework:** [Flutter](https://flutter.dev)
- **State Management:** [Flutter BLoC](https://pub.dev/packages/flutter_bloc)
- **Networking:** [Http](https://pub.dev/packages/http)
- **API:** [Jikan API](https://jikan.moe/) (MyAnimeList API)
- **Animations:** Shimmer effect for smooth loading.

## 📂 Project Structure
```text
lib/
├── bloc/          # Business logic & State management (AnimeBloc)
├── models/        # Data models for parsing API responses
├── pages/         # UI Screens (Home, Search, Details, New Releases)
├── services/      # API Service for network calls
└── main.dart      # App Entry point & BLoC Provider