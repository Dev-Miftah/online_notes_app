# 📝 Flutter Notes App

A clean and simple Notes application built using **Flutter** and **Firebase**, designed for managing personal notes with ease. This project was developed as part of a technical assessment for the Flutter Mobile App Developer position at Caretutors.

---

## 📱 Features

- ✅ **Splash Screen** (shown only on first launch)
- 🔐 **User Authentication** (Email & Password via Firebase)
- 🏠 **Home Page** showing list of notes
- ➕ **Add Notes Page** with Title and Description
- 🧭 **Navigation** using `go_router`
- ⚙️ **State Management** using `GetX`
- 📦 Clean Project Architecture (Presentation, Domain, Data)
- 🎨 Simple and intuitive UI/UX

---
## 📸 Screenshots

### 🏠 Home Screen
![Home Screen](assets/screenshots/home.png)

### ➕ Add Note
![Add Note Screen](assets/screenshots/add_note.png)
## 🔧 Tech Stack

| Technology        | Purpose                          |
|------------------|----------------------------------|
| Flutter           | Cross-platform UI toolkit        |
| Firebase Auth     | User authentication              |
| Cloud Firestore   | Online database for notes        |
| GetX              | State management                 |
| go_router         | Route navigation                 |

---

## 📁 Project Structure (Clean Architecture)

lib/
│
├── data/ # Data layer (models, Firebase interaction)
│ └── models/
│ └── repositories/
│
├── domain/ # Domain logic layer
│ └── entities/
│ └── usecases/
│
├── presentation/ # UI and state management
│ ├── screens/
│ │ ├── splash/
│ │ ├── auth/
│ │ ├── home/
│ │ └── add_note/
│ └── controllers/
│
├── routes/ # Routing configuration
│ ├── app_bindings.dart
│ └── app_router.dart
│
├── utils/ # Reusable utilities (e.g., validators)
│
└── main.dart


### 🔨 Prerequisites
- Flutter SDK (3.0 or above)
- Firebase project with:
    - Email/Password authentication enabled
    - Firestore database set up

### 🔌 Setup

```bash
git clone https://github.com/Dev-Miftah/online_notes_app.git
cd flutter-notes-app
flutter pub get
