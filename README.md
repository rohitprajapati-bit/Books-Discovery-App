# Books Discovery App

A Flutter-based application for discovering books, featuring real-time trends, AI-powered insights, and comprehensive analytics.

## Features

- **Book Discovery**: Search for books by title, author, or ISBN.
- **Real-time Trends**: View live trending books with sales updates via WebSocket simulation.
- **AI Integration**: Get AI-generated summaries and recommendations using Gemini API.
- **Analytics**: Visualize your search history and reading interests.
- **Contacts Integration**: Access and explore contacts within the app.
- **Profile Management**: Update profile picture and name with background sync.
- **Multi-Platform**: Responsive design for Mobile, Tablet, and Desktop.

## Technical Stack

- **Architecture**: Clean Architecture (Presentation, Domain, Data layers).
- **State Management**: `flutter_bloc`.
- **Dependency Injection**: `get_it` & `injectable`.
- **Navigation**: `auto_route`.
- **Networking**: `dio`.
- **Local Storage**: `shared_preferences`.
- **AI**: Google Gemini API (`gemini-2.5-flash`).
- **Realtime**: Simulated WebSocket service.

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

| Home (Grid) | Home (List) | Book Details | QR Scanner|
|:---:|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/e28df62c-4172-4894-bee4-6a512a5f18c5" width="200"> | <img src="https://github.com/user-attachments/assets/25ac8dbb-4b7f-4731-bfe2-bc0a6db03d67" width="200"> | 
<img src="https://github.com/user-attachments/assets/439983a3-080e-453c-b34b-16ce065af39f" width="200"> |<img src="https://github.com/user-attachments/assets/121c5ed1-8d52-4d5a-b50e-6b99927e46ad" width="200"> |

| Analytics | Contacts | Profile |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/0b413107-486a-48b7-a0f5-e20b6a1159e8" width="200"> | <img src="https://github.com/user-attachments/assets/3cc4f71e-c593-467f-ac80-8f3bc105be1e" width="200"> | <img src="https://github.com/user-attachments/assets/ae03842f-3f12-4991-91e9-dee7b8215071" width="200"> |



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
1.  **Local Storage**: Every successful search is saved locally using `SharedPreferences`.
2.  **Processing**: `AnalyticsBloc` retrieves this history asynchronously:
    - **Top Search Terms**: Computed by frequency analysis of local search queries.
    - **Genre Distribution**: Derived from the `categories` field of viewed/searched books.
    - **Publishing Trends**: Extracted from `publishedDate` to categorize books by decade.
3.  **Visualization**: Data is presented using:
    - **Pie Charts**: For Genre distribution.
    - **Bar Charts**: For detailed trends (using `fl_chart`).

---

## WebSocket Integration

Real-time features are powered by a simulated WebSocket connection.

- **Service**: `TrendingSocketService` (Simulated)
- **Functionality**:
    - Establishes a stream of `TrendingBook` updates.
    - Uses a `Timer.periodic` to mock real-time data pushes every 5 seconds.
    - Emits updates with changing "Sales" numbers and "Trend Scores".
- **UI Updates**: The `HomeBloc` and `AnalyticsBloc` listen to this stream and update the UI instantaneously, showing live "Up/Down" indicators.

---

## Gemini AI Usage

We leverage Google's **Gemini 2.5 Flash** model for enhanced content.

- **Summaries**:
    - When a user views a book, a prompt is sent to Gemini: *"Summarize [Book Title] by [Author]..."*
    - The response is displayed as a concise paragraph.
- **Recommendations**:
    - Contextual recommendations are generated based on the currently viewed book.
- **Privacy**: No personal user data is sent to Gemini; only public book metadata is used for context.

---

## Firebase Setup (Secure)

The app uses Firebase for Authentication and User Data.

**Configuration:**
- **Auth**: Email/Password and Google Sign-In.
- **Firestore**: Stores user names and other metadata.
- **Local Storage**: Profile pictures are saved directly on the device (avoiding Cloud Storage costs).

**Security Best Practices:**
- `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are required for Firebase but should **NOT** be committed to public repositories.
- API Keys in `firebase_options.dart` are restricted to specific platforms (Android/iOS) via Google Cloud Console to prevent misuse.
- For production, consider using environment variables to inject sensitive keys at build time.

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
