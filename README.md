# 🛍️ Laza E-Commerce App

A modern **Flutter-based e-commerce mobile application** powered by **Firebase**, designed with clean architecture, secure authentication, and scalable backend services.

---

## 📌 Overview

**Laza** is a full-featured e-commerce mobile app that allows users to:
- Browse products
- Add items to cart
- Manage wishlist (favorites)
- Place and view orders
- Authenticate securely using Firebase

The app focuses on **performance**, **security**, and **clean UI/UX**.

---

## ✨ Features

- 🔐 Firebase Authentication (Email & Password)
- 🛒 Shopping Cart Management
- ❤️ Wishlist (Favorites)
- 📦 Order History
- 🔥 Cloud Firestore Backend
- 🛡️ Secure Firestore Rules
- 📱 Responsive UI (Android & iOS)

---

## 🧱 Project Architecture

```
lib/
│── models/        # Data models
│── services/      # Firebase & business logic
│── screens/       # UI screens
│── widgets/       # Reusable UI components
│── utils/         # Helpers & constants
│── main.dart      # App entry point
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Android Studio / VS Code
- Firebase account
- Android Emulator or Physical Device

---

## ⚙️ Installation

### Clone the repository
```bash
git clone https://github.com/ahmedbrsh1/mobile-prog-project.git
```

### Navigate to project directory
```bash
cd mobile-prog-project
```

### Install dependencies
```bash
flutter pub get
```

---

## 🔥 Firebase Configuration

### 1️⃣ Create Firebase Project
- Go to **Firebase Console**
- Create a new project

### 2️⃣ Add Android App
- Package name example:
```
com.example.laza
```
- Download `google-services.json`
- Place it in:
```
android/app/google-services.json
```

---

## 🔐 Enable Firebase Services

### Authentication
- Build → Authentication → Sign-in method
- Enable **Email / Password**

### Firestore Database
- Build → Firestore Database
- Create database (Test or Production mode)

<img width="1725" height="846" alt="image" src="https://github.com/user-attachments/assets/6f84286e-8df4-48bb-abf9-5c5514138775" />
<img width="1803" height="834" alt="image" src="https://github.com/user-attachments/assets/f9db764b-b2d5-4e33-8f34-a8b65b9040a1" />
<img width="1785" height="836" alt="image" src="https://github.com/user-attachments/assets/d6bf7743-646f-44f3-acb5-ee61f29000f9" />
<img width="1773" height="842" alt="image" src="https://github.com/user-attachments/assets/80ea68e4-1f59-48cb-8b1c-d8b0169bbfd3" />



---

## 🛡️ Firestore Security Rules

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId} {
      allow read, write: if request.auth != null &&
        request.auth.uid == userId;
    }

    match /carts/{cartId} {
      allow read, delete: if request.auth != null &&
        resource.data.userId == request.auth.uid;

      allow create: if request.auth != null &&
        request.resource.data.userId == request.auth.uid;

      allow update: if request.auth != null &&
        resource.data.userId == request.auth.uid;
    }

    match /wishlist/{itemId} {
      allow read, write: if request.auth != null &&
        (resource == null || resource.data.userId == request.auth.uid);
    }

    match /orders/{orderId} {
      allow read: if request.auth != null &&
        resource.data.userId == request.auth.uid;

      allow create: if request.auth != null;
    }
  }
}
```

---

## ▶️ Running the App

### Android

#### Debug Mode
```bash
flutter run
```

#### Release APK
```bash
flutter build apk --release
```

Output:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

### iOS (macOS only)

#### Debug Mode
```bash
flutter run
```

#### Release Build
```bash
flutter build ios --release
```

---

## 🛠️ Tech Stack

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore

---

## 📄 License
This project is for **educational purposes**.

---

⭐ If you like this project, don’t forget to star the repository!
