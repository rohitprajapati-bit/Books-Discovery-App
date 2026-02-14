# Books Discovery App

A modern Flutter application for discovering, tracking, and analyzing books. Features real-time search, AI-powered recommendations, and detailed reading analytics.

## 📱 Screenshots

| Home Tab | Search Tab | Analytics Tab | Profile Tab |
|:---:|:---:|:---:|:---:|
| ![Home Tab](assets/screenshots/home_tab.png) | ![Search Tab](assets/screenshots/search_tab.png) | ![Analytics Tab](assets/screenshots/analytics_tab.png) | ![Profile Tab](assets/screenshots/profile_tab.png) |

*(Note: Add screenshots to `assets/screenshots/` folder)*

## 🔍 Search Mechanisms

The app employs a multi-modal search system to find books effectively:

### 1. Text Search
Standard keyword search querying the Google Books API. Results are cached locally for quick access.

### 2. QR & Barcode Scanner
- **Implementation**: Uses `mobile_scanner` to detect codes.
- **Logic**: 
  - Scans for 10-digit or 13-digit ISBNs.
  - Automatically discriminates between ISBNs and general text.
  - Triggers a specific ISBN search (`isbn:<number>`) for precise matches.

### 3. OCR (Optical Character Recognition)
- **Engine**: Google ML Kit Text Recognition (`google_mlkit_text_recognition`).
- **Workflow**:
  1. **Capture**: User takes a photo of a book cover.
  2. **Extraction**: ML Kit extracts all visible text blocks.
  3. **Filtering**: The app filters out common "noise" phrases (e.g., "New York Times Bestseller", "Edition").
  4. **Selection**: The largest remaining text block is identified as the likely **Title**.
  5. **Context**: Secondary distinct text blocks are added as **Author** context to refine the search.
  6. **Action**: Performs a search query with the extracted metadata.

## 📊 Analytics Logic

Insights are generated locally on the device to ensure privacy and speed.

- **Data Source**: The app maintains a local database of your interactions (viewed books, search history) using `GetCachedBooksUseCase`.
- **Processing**:
  - **Genre Distribution**: Calculates the frequency of book categories from your history.
  - **Publishing Trends**: Parses `publishedDate` to group books by release decades (e.g., 2020s, 1990s, Classics).
- **Visualization**: Data is fed into the `AnalyticsBloc`, which computes these statistics on-the-fly for real-time charting.

## 🔌 WebSocket Integration (Trending Books)

The "Trending Now" section simulates a live data feed to demonstrate real-time updates.

- **Service**: `TrendingSocketService`
- **Behavior**: a `StreamController` emits a new list of trending books every 5 seconds.
- **Simulation**: In the current version, this mocks a WebSocket connection by shuffling and broadcasting a curated list of popular titles (e.g., "Atomic Habits", "Project Hail Mary") with dynamic "trend scores".

## 🤖 Gemini AI Integration

Powered by Google's Gemini Pro model via `google_generative_ai`.

- **Book Summaries**: Generates concise, engaging 150-word summaries for books that lack detailed descriptions.
  - *Prompt*: "Summarize [Title] by [Author]..."
- **Personalized Recommendations**: Analyzes the current book's category and author to suggest 5 similar titles.
  - *Prompt*: "Based on [Title]... recommend 5 similar book titles."
- **Privacy**: No user personal data is sent; only book metadata is used for generation.

## 🔥 Firebase Setup

The app uses Firebase for secure Authentication and backend services.

- **Configuration**: Uses `flutterfire configure` to generate `firebase_options.dart`.
- **Security**:
  - Api Keys and secrets are **NOT** stored in the codebase or version control. calls are made using the generated options file which should be excluded from public repositories.
  - **Authentication**: Supports Email/Password and Google Sign-In via `AuthBloc`.
  - **Firestore**: (Planned/Implemented) for syncing user profiles and remote history.

## 🚀 Getting Started

1. **Prerequisites**: Flutter SDK `3.x`, Dart `3.x`.
2. **Setup**:
   ```bash
   flutter pub get
   ```
3. **Environment**:
   - Create a `.env` file (if applicable) or ensure `firebase_options.dart` is present.
   - Add your Gemini API Key in `lib/core/constants/api_constants.dart` or `.env`.
4. **Run**:
   ```bash
   flutter run
   ```
