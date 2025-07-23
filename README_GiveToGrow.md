# 📚 GiveToGrow

**GiveToGrow** is a mobile donation platform designed to support under-resourced schools in Ghana. The app allows users to browse verified schools, learn about their needs, and make tailored donations that directly impact education in local communities.

---

## ✨ Features

- 🔐 **Firebase Authentication** – Secure login and registration.
- 🏫 **School Directory** – Browse and view schools with urgent needs.
- 🛍️ **Donation Cart** – Add items and amounts to donate to selected schools.
- 💳 **Firestore Integration** – Save donation records with full details.
- 🧾 **Receipt Upload (Firebase Storage)** – (Optional) Upload donation receipts.
- 📜 **Past Donation History** – View donation summaries with status and timestamp.
- 👤 **User Profile** – View personalized profile with avatar and motivational quote.
- 🌟 **Daily Quote** – Get inspired with a new motivational quote each day (via ZenQuotes API).

---

## 🛠️ Tech Stack

- **Flutter** (Frontend)
- **Firebase Authentication**
- **Cloud Firestore** (Data storage)
- **Firebase Storage** (Image uploads)
- **SharedPreferences** (Local user info)
- **Riverpod / Provider** (State management)
- **REST API** (ZenQuotes for daily quote)

---

## 📸 Screenshots

*(Include screenshots here from major pages: Login, Home, School Detail, Cart, Profile, Donations)*

---

## 🧱 Folder Structure

```bash
lib/
├── models/              # Data models (School, Donation)
├── screens/             # UI screens (auth, home, profile, donation)
├── services/            # Firebase, API, and SharedPreferences logic
├── providers/           # State management (CartProvider, etc.)
├── firebase_options.dart
└── main.dart            # App entry point
```

---

## 🔄 How It Works

1. **User signs in** via Firebase Authentication.
2. On the **Home Screen**, they browse schools and view needs.
3. From a **School Detail** screen, they add donation items to a cart.
4. After confirming, donations are saved to **Firestore**.
5. Users can view **Past Donations** from their **Profile Screen**.

---

## 🧪 Setup & Run Locally

1. **Clone the repo**

```bash
git clone https://github.com/KikiOduro/give_2_grow
cd give-to-grow
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Firebase setup**

- Add your `google-services.json` (Android) or `GoogleService-Info.plist` (iOS).
- Ensure your Firebase project has:
  - Authentication (Email/Password)
  - Firestore
  - Storage rules set appropriately

4. **Run app**

```bash
flutter run
```

---

## 📦 Build APK

```bash
flutter build apk --release
```

Find the APK at: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🙌 Contributors

- **Akua Oduro** – Developer & Designer

---

## 📄 License

This project is for educational use. Reach out if you would like to collaborate or scale the initiative.