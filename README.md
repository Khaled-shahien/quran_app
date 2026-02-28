# 📖 Quran App

A beautiful, feature-rich Islamic application built with Flutter that provides Muslims with easy access to the Holy Quran, prayer times, supplications, and Islamic knowledge.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=material-design&logoColor=white" alt="Material Design"/>
  <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge" alt="License"/>
</p>

##🌟 Features

###📚 Reader
- **Complete Quran Text**: All 114 Surahs with Arabic text
- **Multi-language Support**: Arabic, English translations
- **Audio Recitation**: Listen to Quranic verses
- **Bookmark System**: Save favorite verses
- **Search Functionality**: Find specific verses quickly
- **Night Mode**: Comfortable reading in low light

### Times
- **Accurate Calculations**: Based on your location
- **Multiple Calculation Methods**: Various scholarly opinions
- **Qibla Direction**: Find prayer direction
- **Adhan Notifications**: Prayer time reminders
- **Customizable Alerts**: Personalized notification settings

###🤲plications & Dua
- **Daily Supplications**: Morning, evening, and bedtime duas
- **Prayer Supplications**: Duas for each prayer
- **Special Occasions**: Duas for specific events
- **Categorized Collection**: Organized by theme and purpose

### 📿 Islamic Knowledge
- **Names of Allah**: 99 Beautiful Names with meanings
- **Islamic Calendar**: Hijri calendar integration
- **Islamic Facts**: Educational content
- **Hadith Collection**: Authentic sayings of Prophet Muhammad##🛠️ Technologies & Packages

### Core Technologies
- **Flutter SDK** - Cross-platform mobile framework
- **Dart** - Programming language
- **Material 3** - Modern design system

### Key Packages
- **provider**: State management solution
- **http**: HTTP client for API calls
- **shared_preferences**: Local data persistence
- **google_fonts**: Arabic and international typography
- **connectivity_plus**: Network status monitoring
- **logger**: Application logging
- **json_annotation**: JSON serialization
- **build_runner**: Code generation
- **mockito**: Testing mocks

##🏗️ Architecture

The app follows **Clean Architecture** with **Feature-First** organization:

```
lib/
├── core/                         # Shared logic and cross-cutting concerns
│   ├── api/                      # HTTP clients and API services
│   ├── constants/                # App-wide constants & config
│   ├── errors/                   # Exceptions, failures
│   ├── helper_functions/         # Helper & utility functions
│   ├── navigation/              # Router / navigation setup
│   ├── services/                 # Firebase & shared services
│   ├── theme/                    # Theme, colors, typography
│   ├── utils/                    # Utility functions
│  └── widgets/                  # Reusable shared widgets
├── features/                     # Grouped by feature
│   ├── duas/                     # Supplications feature
│   │   ├── data/                 # Data sources, repositories, models
│   │   ├── domain/               # Entities, use cases, business logic
│   │  └── presentation/         # Screens, widgets, state management
│   ├── onboarding/               # Welcome & navigation
│   ├── prayers/                  # Prayer times feature
│  └── quran/                    # Quran feature
└── main.dart                     # App bootstrap & dependency injection
```

##🎨 UI/UX Design

### Color Palette (Islamic Theme)

<div style="display: flex; gap: 10px; margin: 10px 0;">
  <div style="background: #795547; width: 60px; height: 60px; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">#795547</div>
  <div style="background: #FEFBF4; width: 60px; height: 60px; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #333; font-weight: bold; border: 1px solid #ddd;">#FEFBF4</div>
  <div style="background: #5D4037; width: 60px; height: 60px; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">#5D4037</div>
  <div style="background: #4CAF50; width: 60px; height: 60px; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">#4CAF50</div>
  <div style="background: #FF9800; width: 60px; height: 60px; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">#FF9800</div>
</div>

- **Primary**: #795547 (Islamic Brown) - 60%
- **Secondary**: #FEFBF4 (Cream Background) - 30%
- **Accent**: #5D4037 (Darker Brown) - 10%
- **Success**: #4CAF50 (Green) - Action states
- **Warning**: #FF9800 (Orange) - Alerts

### Typography System
- **Display**: 32px Cairo Bold
- **Headline**: 24px Cairo SemiBold
- **Title**: 20px Cairo Medium
- **Body**: 16px Cairo Regular
- **Label**: 14px Cairo Medium

### Design Principles
- **Islamic Aesthetics**: Respectful and culturally appropriate
- **Accessibility**: WCAG 2.1 AA compliant (4.5:1 contrast)
- **Material 3**: Modern, consistent design language
- **Responsive**: Adapts to all device sizes
- **Inclusive**: Usable by everyone regardless of ability

##🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio or VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/quran-app.git
cd quran_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run code generation**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

### Development Setup

```bash
# Run with hot reload
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in debug mode
flutter run --debug

# Run in profile mode
flutter run --profile

# Run in release mode
flutter run --release
```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📁 Project Structure

### Core Layer (Shared Logic)
- **api/**: Base API service, HTTP clients, interceptors
- **constants/**: App-wide configuration and constants
- **errors/**: Custom exception types and error handling
- **helper_functions/**: Utility functions and helpers
- **navigation/**: Router configuration and navigation
- **services/**: Shared services (location, notifications, etc.)
- **theme/**: Material 3 theming, colors, typography
- **utils/**: Utility classes and extensions
- **widgets/**: Reusable UI components

### Feature Layer (Feature Modules)
Each feature follows the Clean Architecture pattern:

```
features/<feature_name>/
├── data/
│   ├── data_sources/     # Local and remote data sources
│   ├── models/           # Data models and DTOs
│  └── repositories/     # Repository implementations
├── domain/
│   ├── entities/         # Business entities
│   ├── repositories/     # Repository interfaces
│  └── use_cases/       # Business logic
└── presentation/
    ├── providers/        # State management
    ├── screens/          # UI screens
   └── widgets/          # Feature-specific widgets
```

##🔐 Backend / API Integration

### Quran API Integration
- **Source**: Al-Quran Cloud API
- **Features**: Complete Quran text, translations, audio
- **Caching**: Local storage for offline access
- **Rate Limiting**: Respectful API usage

### Prayer Times API
- **Source**: Aladhan API
- **Features**: Accurate prayer time calculations
- **Methods**: Multiple calculation methods supported
- **Location**: GPS-based automatic detection

### Security Features
- **HTTPS**: All API calls use secure connections
- **Input Validation**: Comprehensive data sanitization
- **Error Handling**: Secure error messaging
- **Data Encryption**: Local data protection
- **Authentication**: Secure session management

## 📱 Responsive Design

### Supported Platforms
- **Mobile**: Android (API 21+) and iOS (12.0+)
- **Tablet**: iPad and Android tablets
- **Web**: Modern browsers (Chrome, Firefox, Safari, Edge)
- **Desktop**: Windows, macOS, Linux
- **Wearables**: Future smartwatch support

### Adaptive Features
- **Flexible Layouts**: Grid systems that adapt to screen size
- **Responsive Typography**: Text that scales appropriately
- **Touch Optimization**: Finger-friendly interface elements
- **Keyboard Navigation**: Full keyboard support
- **Screen Reader**: Complete accessibility support

##🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/quran/data/surah_repository_test.dart

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

### Test Structure

```
test/
├── core/                     # Core module tests
├── features/                 # Feature-specific tests
│   ├── quran/               # Quran feature tests
│   ├── prayers/             # Prayer times tests
│   └── duas/                # Supplications tests
└── widget_test.dart         # Widget tests
```

### Testing Strategy
- **Unit Tests**: 80%+ coverage for business logic
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end feature workflows
- **Performance Tests**: Load and stress testing
- **Security Tests**: Input validation and sanitization

##🤝 Contributing

We welcome contributions from the Muslim developer community!

### How to Contribute

1. **Fork** the repository
2. **Create** your feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

### Code Guidelines
- Follow Flutter [style guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- Write meaningful commit messages
- Include tests for new features
- Update documentation
- Ensure all tests pass
- Follow Clean Architecture principles

### Development Process
1. Create an issue describing the feature/bug
2. Fork and create a feature branch
3. Implement changes with proper testing
4. Submit pull request with description
5. Code review and approval
6. Merge to main branch

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Quran App Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

##🙏 Acknowledgements

### API Services
- **[Al-Quran Cloud](https://alquran.cloud/)** - Quran text and translations
- **[Aladhan API](https://aladhan.com/)** - Prayer time calculations

### Libraries & Tools
- **[Google Fonts](https://fonts.google.com/)** - Beautiful typography
- **[Material Design](https://material.io/)** - Design system
- **[Flutter](https://flutter.dev/)** - Development framework

### Community
- **Islamic Scholars** - Guidance and review
- **Muslim Developers** - Code contributions
- **Open Source Community** - Inspiration and support

### Special Thanks
- **Contributors** - Code and documentation
- **Testers** - Bug reporting and feedback
- **Users** - Feature suggestions and support

## 📞 Support & Community

### Get Help
- **GitHub Issues**: [Create an issue](https://github.com/yourusername/quran-app/issues)
- **Email**: support@quranapp.com
- **Discord**: Join our developer community
- **Twitter**: Follow @QuranAppDev

### Community Resources
- **Documentation**: [docs.quranapp.com](https://docs.quranapp.com)
- **API Reference**: [api.quranapp.com](https://api.quranapp.com)
- **Contribution Guide**: [CONTRIBUTING.md](CONTRIBUTING.md)

## 📈 Project Stats

<p align="center">
  <img src="https://img.shields.io/github/languages/code-size/yourusername/quran-app?style=flat-square" alt="Code Size"/>
  <img src="https://img.shields.io/github/repo-size/yourusername/quran-app?style=flat-square" alt="Repo Size"/>
  <img src="https://img.shields.io/github/last-commit/yourusername/quran-app?style=flat-square" alt="Last Commit"/>
  <img src="https://img.shields.io/github/contributors/yourusername/quran-app?style=flat-square" alt="Contributors"/>
  <img src="https://img.shields.io/github/issues/yourusername/quran-app?style=flat-square" alt="Issues"/>
  <img src="https://img.shields.io/github/license/yourusername/quran-app?style=flat-square" alt="License"/>
</p>

---

<p align="center">
  <strong>May this app be a source of benefit and guidance for all Muslims.</strong>
</p>

<p align="center">
  Made with ❤️ for the Ummah | Built with Flutter
</p>