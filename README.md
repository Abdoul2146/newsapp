# 🌍 Global News Pulse

A high-performance, modern news aggregator built with Flutter, leveraging the power of the **GDELT Project API** to deliver real-time news from across the globe.

## ✨ Current Features

### 📡 Real-Time News Delivery
- **Home Feed:** A chronological stream of the latest news from US sources, filtered for the last 14 days to ensure maximum freshness.
- **Trending Pulse:** A specialized view using GDELT's relevance algorithms to highlight the highest-velocity stories from the last 24 hours.
- **Intelligent Search:** Full-text search capability to find news on any topic, organization, or location.

### ⚡ Performance & Offline Support
- **Cache-First Architecture:** Articles are cached locally using `SharedPreferences`, allowing the app to launch instantly and work offline.
- **Background Processing:** All JSON decoding and data mapping are handled in background isolates (`compute`) to ensure a stutter-free 60FPS UI.
- **Efficient Networking:** Optimized payloads (50 records per fetch) and cache-busting logic to ensure the most recent data is always prioritized.

### 🎨 Modern User Experience
- **Adaptive UI:** Full support for **Light and Dark modes** with persistent user preference.
- **Polished Feedback:** Shimmer skeleton screens during loading and smooth "Time-Ago" formatting for trending stories.
- **Deep Linking:** Integrated In-App WebView for reading full articles without leaving the application.
- **Native Sharing:** Share interesting stories directly to other apps using the native system share sheet.

## 🛠️ Technical Stack

- **Framework:** [Flutter](https://flutter.dev)
- **State Management:** [Riverpod](https://riverpod.dev) (Reactive state & Dependency Injection)
- **Navigation:** [GoRouter](https://pub.dev/packages/go_router) (Declarative routing)
- **Local Storage:** `SharedPreferences` (Initial implementation)
- **API Integration:** [GDELT DOC API v2](https://blog.gdeltproject.org/gdelt-doc-api-v2-introduction/)
- **Image Handling:** `cached_network_image`
- **UI Components:** `shimmer`, `google_fonts`, `webview_flutter`

## 📂 Project Structure

```text
lib/
├── core/               # App-wide routing, theme, and shared widgets
├── features/           # Feature-based module organization
│   ├── home/           # News fetching, searching, and list display
│   ├── trending_news/  # Relevance-based top stories
│   ├── saved_articles/ # Local bookmark management
│   ├── article_detail/ # Detail view and WebView integration
│   └── settings/       # Theme and app configurations
└── main.dart           # Entry point and provider initialization
```

## 📸 Screenshots
*(Visuals available in the `/UIs` directory)*
- Home Screen
- Trending Pulse
- Saved Collection
- Article Detail (Dark & Light Mode)

---
*Note: This README reflects the app state prior to the Phase 1-4 architectural refactor (Isar migration, Infinite Scroll, and Categorized News).*
