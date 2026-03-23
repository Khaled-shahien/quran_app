# 📖 Quran App

A beautiful, performant, and accessible Flutter application designed to provide a premium experience for reading the Holy Quran, viewing prayer times, and learning the Asma-ul-Husna (Names of Allah). Built completely with Clean Architecture and Feature-First principles.

Current delivery/verification state is tracked in `PROJECT_STATUS.md`.

## 🌟 Features
* **Interactive Quran Reader:** Read the Holy Quran with a traditional Mushaf feel. Smooth right-to-left horizontal pagination with auto-scaling verses.
* **Prayer Times:** Accurate prayer time calculations fetched cleanly with local caching integration.
* **Asma-ul-Husna:** A dedicated visually appealing screen to read and learn the 99 Names of Allah with meanings.
* **Modern UI/UX:** Material 3 design, carefully selected color scheme featuring warm, eye-comforting palettes (`AppColors.lightBackground`, `AppColors.lightPrimary`).
* **Offline Ready:** Utilizes local asset files and robust caching to work seamlessly without internet.

## 🛠️ Technologies & Packages
* **[Flutter](https://flutter.dev/):** UI framework for natively compiled applications.
* **[Provider](https://pub.dev/packages/provider):** Clean and straightforward State Management.
* **[Shared Preferences](https://pub.dev/packages/shared_preferences):** Persistent local storage for caching API responses & user settings.
* **[Google Fonts](https://pub.dev/packages/google_fonts):** High-quality typography (Amiri, Cairo).
* **[JSON Serializable](https://pub.dev/packages/json_serializable):** Robust, type-safe data modeling.

## 🏗️ Architecture
The app follows **Clean Architecture** combined with a **Feature-first** folder structure. This ensures separation of concerns, testability, and extreme scalability.

```text
lib/
├── core/
│   ├── theme/             # Modern AppColors and Theme configuration
│   ├── utils/             # Helper functions and security utils
│   └── errors/            # Centralized error handling
└── features/
    ├── onboarding/        # Onboarding flow Presentation
    ├── prayers/           # Prayer Times Feature (Data, Domain, Presentation)
    └── quran/             # Quran & Asma Feature (Data, Domain, Presentation)
```

## 🔄 App Flow
1. **App Initialization:** Loads `SharedPreferences` asynchronously and injects it into Repositories.
2. **Onboarding:** Greets the user and directs them to the main interface.
3. **Home Overview:** Displays Prayer metrics or navigates to Quran / Asma.
4. **Quran Reading Flow:** Parses `assets/ayaat/` `.txt` files in real-time, splits them efficiently, scales them to fit the screen, and paginates horizontally using a `PageView`.

## 🎨 UI/UX Design
Designed with **Palette** guidelines to be visually stunning:
* **Background:** `Color(0xFFFEFBF4)` - A warm, paper-like off-white to reduce eye strain.
* **Primary / Text:** `Color(0xFF795547)` - Earthy brown tones creating contrast while remaining soft.
* **Typography:** `Amiri` for Quranic text guaranteeing authentic shaping, `Cairo` for modern standard Arabic interface text.

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (`^3.8.0` or higher)
* Dart SDK

### Installation
1. Clone the repository.
   ```bash
   git clone <repo-url>
   ```
2. Fetch dependencies.
   ```bash
   flutter pub get
   ```
3. Run the application.
   ```bash
   flutter run
   ```

## 🔐 Code Health & Security
Maintained dynamically by **Sentinel** Agent:
* Checked and resolved code lints (e.g., deprecated `withOpacity`, unused variables).
* Graceful `try-catch` structures preventing UI crashes when loading `rootBundle` assets or fetching API endpoints.

## 🤝 Contributing
Contributions are totally welcome! Feel free to open an Issue or submit a Pull Request.

## 📄 License
This project is open-sourced and available under the standard MIT License.