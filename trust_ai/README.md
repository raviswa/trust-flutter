# Trust AI — Flutter

Complete Flutter rewrite of the React Native + Node.js frontend.
The Node.js + MongoDB **backend is unchanged** — only the mobile client moves to Flutter.

---

## Project structure

```
trust_ai/
├── pubspec.yaml
├── assets/
│   └── logo.png                         ← copy your Trust AI logo here
└── lib/
    ├── main.dart                         ← app entry point
    ├── theme/
    │   └── app_theme.dart                ← colours (C), text styles (T), Material theme
    ├── data/
    │   └── static_data.dart              ← kCountries, kLanguages (replaces countries.js)
    ├── models/
    │   └── user_model.dart               ← UserModel (matches MongoDB User schema)
    ├── services/
    │   ├── api_service.dart              ← Dio HTTP client (mirrors services/api.js)
    │   └── auth_provider.dart            ← ChangeNotifier auth state
    ├── utils/
    │   └── router.dart                   ← go_router (replaces React Navigation stack)
    ├── widgets/
    │   └── widgets.dart                  ← all shared components (single import)
    └── screens/
        ├── welcome_screen.dart           ← WelcomeScreen.js
        ├── login_screen.dart             ← LoginScreen (sign in)
        ├── register_screen.dart          ← RegisterScreen.js  (Step 1 of 5)
        ├── intake_feelings_screen.dart   ← IntakeFeelingsScreen.js  (Step 2)
        ├── intake_addiction_screen.dart  ← IntakeAddictionScreen.js (Step 3)
        ├── intake_support_screen.dart    ← (Step 4 — support network)
        ├── privacy_screen.dart           ← PrivacyScreen.js  (Step 5)
        └── dashboard_screen.dart         ← DashboardScreen (placeholder)
```

---

## RN → Flutter screen map

| React Native file | Flutter file | Route |
|---|---|---|
| `WelcomeScreen.js` | `welcome_screen.dart` | `/` |
| *(login)* | `login_screen.dart` | `/login` |
| `RegisterScreen.js` | `register_screen.dart` | `/register` |
| `IntakeFeelingsScreen.js` | `intake_feelings_screen.dart` | `/intake/feelings` |
| `IntakeAddictionScreen.js` | `intake_addiction_screen.dart` | `/intake/addiction` |
| *(new step 4)* | `intake_support_screen.dart` | `/intake/support` |
| `PrivacyScreen.js` | `privacy_screen.dart` | `/intake/privacy` |
| `DashboardScreen` | `dashboard_screen.dart` | `/dashboard` |

---

## API endpoints — unchanged

| Method | Path | Called from |
|---|---|---|
| POST | `/api/auth/register` | `register_screen.dart` |
| POST | `/api/auth/login` | `login_screen.dart` |
| POST | `/api/intake/feelings` | `intake_feelings_screen.dart` |
| POST | `/api/intake/addiction` | `intake_addiction_screen.dart` |
| POST | `/api/intake/support` | `intake_support_screen.dart` |
| POST | `/api/intake/consent` | `privacy_screen.dart` |
| GET  | `/api/intake/me` | `ApiService.i.getIntake()` |

---

## Setup

### 1. Install Flutter SDK
```bash
# macOS
brew install --cask flutter

# Verify
flutter doctor
```

### 2. Copy the logo
```bash
cp your-logo.png trust_ai/assets/logo.png
```

### 3. Install dependencies
```bash
cd trust_ai
flutter pub get
```

### 4. Point to your backend
Edit `lib/services/api_service.dart`:
```dart
const _kDev   = true;                          // false for production
const _devUrl  = 'http://localhost:5000/api';  // your local Node server
const _prodUrl = 'https://YOUR_PROD_URL/api';
```

### 5. Run
```bash
flutter run            # picks up connected device / emulator
flutter run -d chrome  # web (for testing UI only)
```

---

## Build for release

```bash
# iOS
flutter build ios --release

# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release
```

---

## Key packages

| Package | Purpose | RN equivalent |
|---|---|---|
| `go_router` | Navigation | `@react-navigation/native-stack` |
| `provider` | State management | React Context |
| `dio` | HTTP client | `axios` |
| `flutter_secure_storage` | HIPAA token storage | `SecureStore` |
| `google_fonts` | Inter font | `expo-font` |

---

## HIPAA checklist before release

- [ ] Set `_kDev = false` in `api_service.dart`
- [ ] Add certificate pinning in the Dio interceptor
- [ ] Add jailbreak/root detection: `flutter pub add flutter_jailbreak_detection`
- [ ] Remove all `print()` / `debugPrint()` calls from production builds
- [ ] Enable ProGuard / R8 obfuscation on Android
- [ ] Confirm MongoDB Atlas + AWS have signed BAA agreements
