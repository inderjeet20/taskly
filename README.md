# Taskly

Taskly is a polished Flutter task manager built for internship evaluation with:

- Firebase Authentication for signup, login, logout, and persistent auth state
- Cloud Firestore CRUD for personal task management
- ZenQuotes REST API integration using `http`
- GetX state management and routing
- Reusable premium UI widgets with an iOS-inspired aesthetic
- Responsive layouts, animations, loading states, and error handling

---

## Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/7f782df0-a2a3-419e-b2ad-a14d83e83b5c" width="220"/>
  <img src="https://github.com/user-attachments/assets/6d2a90fa-2d2a-4b9c-8961-fecd5c1889a7" width="220"/>
  <img src="https://github.com/user-attachments/assets/cb30b7cd-7c02-458b-a932-560341e29b22" width="220"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/d5e7b429-f430-4f07-876b-ca23dc90b718" width="220"/>
  <img src="https://github.com/user-attachments/assets/2dbfd26d-26df-4393-86b3-788a67eeee4c" width="220"/>
  <img src="https://github.com/user-attachments/assets/95afaeee-d0ee-4c22-9471-2d1bce0d64a0" width="220"/>
</p>

---

## Folder Structure

```text
lib/
├── models/
├── screens/
├── services/
├── widgets/
├── controllers/
├── utils/
└── main.dart
```

---

## Features

- Splash, Login, Signup, Dashboard, Add/Edit Task, Task Detail, All Tasks, Calendar, and Profile screens
- Firestore-backed add, edit, delete, and complete task flows
- Motivational quote card powered by `https://zenquotes.io/api/random`
- Clean architecture with separated controllers, services, and UI widgets
- Smooth Cupertino-style page transitions and subtle micro-interactions

---

## Firebase Setup

Before running the app on Android or iOS, add your Firebase app configuration:

1. Create a Firebase project
2. Add Android and iOS apps in Firebase
3. Place `google-services.json` inside `android/app/`
4. Place `GoogleService-Info.plist` inside `ios/Runner/`
5. Run:

```bash
flutter pub get
flutter run
```

### Optional FlutterFire CLI Setup

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

---

## Firestore Data Shape

Tasks are stored per user under:

```text
users/{uid}/tasks/{taskId}
```

Each task contains:

- `title`
- `description`
- `date`
- `status`
- `createdAt`
- `userId`
- `category`

---

## Verification

The project has been verified with:

```bash
flutter analyze
```

---

