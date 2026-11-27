# BiblioApp — Personal Library Mobile App

Cross-platform mobile app for managing a personal book collection, built with **Flutter**, the **BLoC** pattern and a local **SQLite** database. It works fully offline: add your books, track what you have read, rate them, keep favourites and read your notes or excerpts in a dedicated reading space.

## Features

- **Book catalogue**: add, edit and delete books (title, author, year, genre, rating, read status, favourite)
- **Search and filters**: search by title or author, filter by genre, show only favourites or books already read
- **Sorting**: by title, author, rating or most recently added
- **Book details**: full information with date added and date of last modification
- **Reading space**: store a summary, a chapter or excerpts with each book and read them in a distraction-free screen
- **Statistics**: total books, books read, favourites and average rating
- **Form validation** on every field, and a sample library loaded on first launch
- Modern Material 3 interface with a custom theme, splash screen and app icon

## Tech stack

| Layer | Technology |
|---|---|
| UI | Flutter (Dart), Material 3 |
| State management | `flutter_bloc` (BLoC pattern), `equatable` |
| Persistence | SQLite via `sqflite` |
| Platforms | Android, iOS, Web, Windows, macOS, Linux |

## Architecture

The app follows a layered architecture: screens dispatch events to a BLoC, which goes through a repository to reach the SQLite database.

```
UI (screens, widgets)  ──events──►  LivreBloc  ──►  LivreRepository  ──►  DatabaseHelper (SQLite)
          ▲                              │
          └────────────states────────────┘
```

```
lib/
├── main.dart                 # app entry point and theme
├── bloc/                     # LivreBloc, events (Load, Add, Update, Delete) and states
├── database/                 # DatabaseHelper: schema, sample data, CRUD queries
├── models/                   # Livre model (toMap / fromMap / copyWith)
├── repositories/             # LivreRepository: data access with error handling
├── screens/                  # list, details, add, edit, reading space, statistics, splash
├── utils/                    # form validators
└── widgets/                  # reusable custom text field
```

## Getting started

Prerequisites: [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x and an emulator or a connected device.

```bash
git clone https://github.com/youssrahaddouch0103-coder/biblio-app.git
cd biblio-app
flutter pub get
flutter run
```

## Possible improvements

- Cover images from the camera or an online book API
- Cloud sync between devices
- Unit tests for the BLoC and the repository

## Author

**Youssra Haddouch** — Computer Engineering student at ENSAM Meknès, with contributions from [Ikram Ech-Charqy](https://github.com/ikramcharqy)
[GitHub](https://github.com/youssrahaddouch0103-coder) · [LinkedIn](https://www.linkedin.com/in/youssra-haddouch-830565297)
