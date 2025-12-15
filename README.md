# 🥋 Gringo-QI-Gong Mobile Application

**Version:** 1.0.0  
**Framework:** Flutter (Dart)  
**State Management:** Riverpod  
**Design System:** Deep Earth Aesthetic  

---

## 📖 Introduction

**Gringo-QI-Gong** is a holistic wellness application designed to guide users through Qigong movement practices. Unlike generic fitness apps, it uses an "Agentic AI" backend (powered by n8n and Claude) to personalize daily sessions based on the user's real-time pain, energy levels, and emotional state.

This `gringo_qi_gong` folder contains the complete frontend mobile application. It is built to be cross-platform (iOS, Android, Web) and communicates with the Gringo n8n Orchestrator.

---

## 🏗️ Technical Architecture

The application follows a clean, layered architecture to ensure scalability and testability.

### 1. Feature-First Layering
Code is organized by "Feature" (screens/flows) rather than technical type (controllers/views).
*   **Screens**: UI Components and Pages.
*   **State**: Global app state (User, Session) managed by Riverpod.
*   **Services**: Data fetching and API communication logic.
*   **Theme**: Design tokens and global styling.

### 2. State Management (Riverpod)
We use `flutter_riverpod` for robust state management.
*   **`userProvider`**: Manages authentication state (`UserState`), persistence (Shared Preferences), and user profile data.
*   **`gringoApiProvider`**: A dependency injection provider for the API service, allowing for easy mocking during tests.

### 3. API & Connectivity
All external communication happens via `GringoApiService` (`lib/services/gringo_api.dart`).
*   **Mock Mode**: Built-in toggle to simulate backend responses for UI development.
*   **Endpoints**: Connects to the defined n8n webhooks (`/user/register`, `/ai/personalize`, `/session/complete`, `/ai/orchestrator`).

---

## ✨ Key Features

### 1. Onboarding & Registration
*   **Flow**: Simple, distraction-free sign-up form.
*   **Data**: Captures Name and Email to register the user in Supabase via the n8n webhook.
*   **Persistence**: Auto-login on subsequent app launches using `SharedPreferences`.

### 2. Daily Dashboard (The "Resonance" Hub)
*   **Wellness Check-in**: Interactive sliders for tracking Pain (0-10) and Energy (1-10). These metrics drive the AI personalization engine.
*   **AI Recommendation**: Fetches a personalized session based on the check-in data.
    *   *Example*: High pain + Low energy -> "Gentle Lymphatic Flow".
    *   *Example*: Low pain + High energy -> " vigorous Power Set".

### 3. Movement Player
*   **HLS Streaming**: Supports high-quality video streaming of the 12-movement Qigong protocol.
*   **Queue System**: Automatically plays the recommended sequence of movements in order.
*   **Focus Mode**: Darkened interface to minimize distraction during practice.

### 4. AI Orchestrator Chat
*   **Contextual Assistant**: A chat overlay accessible from anywhere.
*   **Intelligence**: Connected to the `05_orchestrator_agent` n8n workflow. It knows your user context and can answer questions like "Why does my lower back hurt during this move?".

---

## 🔗 Backend Integration (n8n & Supabase)

This app is the **Frontend** of the Gringo-QI-Gong platform. It requires the **Logic Layer** to function fully.

### Required n8n Workflows
The app communicates with the following workflows (found in the `gringo-qigong-n8n-workflows` package):
1.  **User Registration** (`01_user_registration.json`): Handles sign-ups and database creation.
2.  **Session Logging** (`02_session_complete.json`): Stores practice data.
3.  **Personalization Agent** (`03_ai_personalization.json`): Generates dynamic sessions using Claude.
4.  **Orchestrator** (`05_orchestrator_agent.json`): Manages the chat interface.

### Database Schema
Ensure your Supabase project is set up with `database_schema.sql`. The app expects `profiles`, `practice_sessions`, and `exercises` tables to exist.

---

## 🎨 Design System: "Deep Earth"

The app utilizes a custom `ThemeData` defined in `lib/theme/app_theme.dart`.

*   **Palette**:
    *   `Background`: Deep Charcoal/Brown (`#1A1816`) - Grounding.
    *   `Primary`: Sand Gold (`#D4A373`) - Warmth and focus.
    *   `Secondary`: Muted Sage (`#8B9D83`) - Nature and healing.
    *   `Accent`: Terracotta (`#C56C58`) - Vitality.
*   **Typography**: Uses **Outfit** (via Google Fonts) for a modern, clean, yet approachable feel.

---

## 🚀 Setup & Installation

### Prerequisites
1.  **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install)
2.  **IDE**: VS Code (recommended) or Android Studio.

### Step 1: Install Dependencies
Open a terminal in the project root:
```bash
flutter pub get
```

### Step 2: Run the App
To run on a connected device or emulator:
```bash
flutter run
```

---

## 🔌 Configuration: Going Live

By default, the app runs in **Mock Mode** to allow testing without a server. To connect to your real n8n backend:

1.  Open `lib/services/gringo_api.dart`.
2.  Locate the configuration section:
    ```dart
    final String _baseUrl = 'https://YOUR-N8N-INSTANCE.cloud/webhook/gringo';
    final String _apiKey = 'YOUR-SECRET-KEY';
    final bool _mockMode = false; // Change from true to false
    ```
3.  **Note**: Ensure your n8n workflows are active and the Webhooks are set to `POST`.

---

## 📂 Project Structure

```
gringo_qi_gong/
├── android/            # Native Android configuration
├── ios/                # Native iOS configuration
├── lib/
│   ├── screens/        # UI Screens
│   │   ├── chat_overlay.dart       # AI Assistant Chat
│   │   ├── dashboard_screen.dart   # Main Hub
│   │   ├── onboarding_screen.dart  # Sign up
│   │   └── player_screen.dart      # Video Player
│   ├── services/       # Logic Layer
│   │   └── gringo_api.dart         # API Client (n8n connector)
│   ├── state/          # State Management
│   │   └── user_state.dart         # User Profile & Auth
│   ├── theme/          # Design System
│   │   └── app_theme.dart          # Colors & Fonts
│   └── main.dart       # Entry point
├── pubspec.yaml        # Dependencies & Assets
└── README.md           # This file
```

---

## 🐛 Troubleshooting

*   **Video not playing?**
    *   The demo uses a publicly available test video. If switching to your own, ensure the URL supports HLS (`.m3u8`) or standard MP4, and that your server handles CORS if running on Web.
*   **API Errors?**
    *   Check the `_baseUrl` in `gringo_api.dart`. It must match your n8n Webhook URL exactly.
    *   Ensure the `Authorization` header matches the one defined in your n8n workflow credentials.

---

*Built with ❤️ for the Gringo-QI-Gong Community.*
