# Firebase Setup Guide (Flutter + Firebase)

This guide explains how to set up Firebase for this Flutter project from scratch.

---

## 1. Prerequisites

Make sure you have the following installed:

- Flutter SDK
- Node.js (required for Firebase CLI)
- A Google account

Verify installations:

flutter --version  
node --version  

---

## 2. Install Firebase CLI

Install Firebase CLI globally using npm:

npm install -g firebase-tools

Verify installation:

firebase --version

Login to Firebase:

firebase login

---

## 3. Install FlutterFire CLI

Activate FlutterFire CLI:

dart pub global activate flutterfire_cli

Make sure Dart global binaries are in PATH.

Verify:

flutterfire --version

---

## 4. Create Firebase Project

1. Go to https://console.firebase.google.com
2. Click **Add project**
3. Name the project (e.g. laza-ecommerce)
4. Disable Google Analytics (not required)
5. Create project

---

## 5. Configure Firebase for Flutter App

From the root of the Flutter project:

flutterfire configure

- Select the Firebase project
- Select Android platform
- Confirm Android package name
- This generates:
  - firebase_options.dart
  - Firebase app configuration

---

## 6. Add Firebase Packages

In pubspec.yaml:

firebase_core  
firebase_auth  
cloud_firestore  

Run:

flutter pub get

---

## 7. Initialize Firebase in main.dart

Before runApp():

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

---

## 8. Enable Authentication

Firebase Console → Authentication → Get Started

Enable:
- Email/Password

---

## 9. Firestore Setup

Firebase Console → Firestore Database

- Create database (test mode for development)

Collections used:
- users
- carts
- favorites

---

## 10. Firestore Rules (Basic)

Allow authenticated access:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}

---

## 11. Auto Login Behavior

Firebase Auth persists the user session automatically.
Use FirebaseAuth.instance.currentUser to check login state.

---

## 12. Logout

Call:

FirebaseAuth.instance.signOut();

---

## Notes

- Re-running flutterfire configure is safe
- firebase_options.dart is auto-generated
- Do not commit sensitive keys

---

Setup complete.
