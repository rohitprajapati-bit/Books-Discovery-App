# Books Discovery App

A Flutter-based application for discovering books, featuring real-time trends, AI-powered insights, and comprehensive analytics.

![App Banner](screenshots/banner.png)

## Features

- **Book Discovery**: Search for books by title, author, or ISBN.
- **Real-time Trends**: View live trending books with sales updates via WebSocket.
- **AI Integration**: Get AI-generated summaries and recommendations using Gemini API.
- **Analytics**: Visualize your search history and reading interests.
- **Profile Management**: Update profile picture and name with background sync.
- **Multi-Platform**: Responsive design for Mobile, Tablet, and Desktop.

## Technical Stack

- **Architecture**: Clean Architecture (Presentation, Domain, Data layers).
- **State Management**: `flutter_bloc`.
- **Dependency Injection**: `get_it` & `injectable`.
- **Navigation**: `auto_route`.
- **Networking**: `dio` / `http`.
- **Local Storage**: `shared_preferences` & `sqflite` (if applicable).
- **Testing**: `mocktail`, `bloc_test`.

## Project Structure

```
lib/
├── core/                   # Global utilities, DI, Router, etc.
├── feature/                # Feature-based modules
│   ├── auth/               # Authentication (Login, Register, Splash)
│   ├── home/               # Home screen, Search, Discovery
│   ├── book_details/       # Book Details, Reviews, AI Summary
│   ├── profile/            # User Profile management
│   ├── analytics/          # Usage stats and visualization
│   └── contacts/           # Contact integration
└── main.dart               # App entry point
```

---

## Screenshots

| Home (Mobile) | Home (Tablet) | Analytics |
|:---:|:---:|:---:|
| ![Home Mobile](screenshots/home_tablet.png)
) | ![Home Tablet](screenshots/home_tablet.png) | ![Analytics](screenshots/analytics.png) |

| Book Details | QR Scanner | Dark Mode |
|:---:|:---:|:---:|
| ![Details](screenshots/details.png) | ![Scanner](screenshots/scanner.png) | ![Dark Mode](screenshots/dark_mode.png) |

---

## Search Mechanisms

The app supports multiple ways to find books:

1.  **Text Search**: Standard text input to query the Google Books API.
2.  **QR/Barcode Scanner**:
    - Uses `mobile_scanner` to detect ISBNs from barcodes.
    - Automatically triggers a search upon successful detection.
3.  **OCR (Optical Character Recognition)**:
    - Uses `google_mlkit_text_recognition` to extract text from images (e.g., book covers).
    - Extracted text is populated into the search bar for easy querying.

---

## Analytics Logic

We track user search behavior to provide personalized insights.

**Data Flow:**
1.  **Local Storage**: Every successful search is saved locally using `SharedPreferences` (via `SearchHistoryRepository`).
2.  **Processing**: `AnalyticsBloc` retrieves this history asynchronously:
    - **Top Search Terms**: Computed by frequency analysis of local search queries.
    - **Genre Distribution**: Derived from the `categories` field of viewed/searched books.
    - **Publishing Trends**: Extracted from `publishedDate` to categorize books by decade.
3.  **Visualization**: Data is presented using:
    - **Pie Charts**: For Genre distribution.
    - **Bar Charts**: For detailed trends (using `fl_chart`).

---

## WebSocket Integration

Real-time features are powered by a WebSocket connection (currently simulated).

- **Service**: `TrendingSocketService`
- **Functionality**:
    - Establishes a stream of `TrendingBook` updates.
    - Emits updates every few seconds with changing "Sales" numbers and "Trend Scores".
- **UI Updates**: The `HomeBloc` and `AnalyticsBloc` listen to this stream and update the UI instantaneously, showing live "Up/Down" indicators.

---

## Gemini AI Usage

We leverage Google's **Gemini 2.5 Flash** model for enhanced content.

- **Summaries**:
    - When a user views a book, a prompt is sent to Gemini: *"Summarize [Book Title] by [Author]..."*
    - The response is streamed or displayed as a concise paragraph.
- **Recommendations**:
    - Contextual recommendations are generated based on the currently viewed book.
    - Prompt: *"Recommend 5 books similar to [Book Title]..."*
- **Privacy**: No personal user data is sent to Gemini; only book metadata is used for context.

---

## Profile & Authentication

- **Non-blocking Updates**: Profile updates (image/name) happen in the background with a non-blocking loading overlay, ensuring smooth UX.
- **Security**:
    - **Logout Confirmation**: Prevents accidental session termination.
    - **Session Management**: Auth state is managed via `AuthBloc` and persists across app restarts.

---

## Firebase Setup

The app uses Firebase for Authentication and User Data.

**Configuration:**
- **Auth**: Email/Password and Google Sign-In.
- **Firestore**: Stores user profiles and potential cloud-synced settings.
- **Security**:
    - `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are required but **NOT** included in the repo for security.
    - API Keys are managed via environment variables or secure config files.

**To run this project:**
1.  Create a Firebase project.
2.  Add Android/iOS apps in the Firebase Console.
3.  Download configuration files and place them in `android/app/` and `ios/Runner/`.
4.  Enable Auth and Firestore services.

---

## Getting Started

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/rohitprajapati-bit/Books-Discovery-App.git
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

---

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.
