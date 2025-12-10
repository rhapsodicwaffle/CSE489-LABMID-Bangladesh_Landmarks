# Bangladesh Landmarks App

A Flutter mobile application for documenting and managing landmarks across Bangladesh with interactive maps, offline caching, and real-time synchronization.

## Features

### Core Functionality
- **Interactive Map View**: OpenStreetMap integration centered on Bangladesh (23.6850°N, 90.3563°E)
- **CRUD Operations**: Create, Read, Update, and Delete landmarks via REST API
- **GPS Auto-Detection**: Automatic location detection using device GPS
- **Image Management**: 
  - Camera and gallery image picker
  - Automatic resize to 800×600 pixels
  - JPEG compression at 85% quality
- **Offline Mode**: SQLite local caching when API is unavailable
- **Swipe Actions**: Swipe-to-edit and swipe-to-delete in list view
- **Custom Markers**: Interactive map markers with bottom sheet details

### UI/UX
- **Cyberpunk Theme**: Neon cyan/pink/yellow color scheme with dark backgrounds
- **Bottom Navigation**: Three tabs (Overview, Records, New Entry)
- **Material 3 Design**: Modern Flutter UI components
- **Responsive Feedback**: SnackBars for success/error messages

### Technical Features
- **State Management**: Provider pattern for reactive state
- **REST API Integration**: Full HTTP CRUD via Dio
- **Offline Caching**: SQLite persistence layer
- **Image Processing**: Server-side and client-side optimization
- **Location Services**: Geolocator for GPS positioning
- **Permission Handling**: Camera, storage, and location permissions

## Tech Stack

- **Framework**: Flutter 3.9.2+
- **Language**: Dart
- **State Management**: Provider
- **HTTP Client**: Dio
- **Database**: sqflite (SQLite)
- **Maps**: flutter_map + OpenStreetMap
- **Image Handling**: image_picker, image package
- **Permissions**: permission_handler
- **Location**: geolocator

## API Endpoints

Base URL: `https://labs.anontech.info/cse489/t3/api.php`

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api.php` | Fetch all landmarks |
| POST | `/api.php` | Create new landmark (multipart/form-data) |
| PUT | `/api.php?id={id}` | Update landmark (with optional image) |
| DELETE | `/api.php?id={id}` | Delete landmark |

## Setup Instructions

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Android Studio / VS Code
- Android Emulator or Physical Device
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/bangladesh_landmarks.git
   cd bangladesh_landmarks
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Android Configuration
- Minimum SDK: 21
- Target SDK: 34
- Permissions required: Camera, Storage, Location

### Network Security
The app uses HTTP for API communication. Network security config is set to allow cleartext traffic to `labs.anontech.info`.

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   └── landmark.dart             # Landmark data model
├── providers/
│   └── landmark_provider.dart    # State management
├── services/
│   ├── api_service.dart          # REST API client
│   ├── image_service.dart        # Image processing
│   └── location_service.dart     # GPS services
├── database/
│   └── database_helper.dart      # SQLite operations
├── screens/
│   ├── map_screen.dart           # Interactive map view
│   ├── records_screen.dart       # List view with CRUD
│   └── landmark_form_screen.dart # Create/Edit form
└── widgets/
    └── landmark_bottom_sheet.dart # Marker detail popup
```

## Git Workflow

This project follows proper Git practices:
- **Main branch**: Production-ready code
- **Feature branches**: 
  - `feature/api`: API integration and services
  - `feature/ui`: User interface screens and widgets
  - `feature/offline`: Offline caching functionality
- **Commit standards**: Conventional commits (feat, fix, refactor, docs, chore)
- **Pull Requests**: Feature branches merged via PRs

## Known Limitations

1. **No Authentication**: User authentication was removed due to server-side constraints
2. **HTTP Only**: Uses cleartext HTTP (not HTTPS) for API communication
3. **Single Language**: English only, no localization
4. **Android Only**: iOS configuration not included
5. **Limited Error Recovery**: Some edge cases in offline-to-online sync
6. **No Image Caching**: Map tiles and landmark images downloaded each time
7. **Fixed Image Size**: All images resized to 800×600 regardless of aspect ratio
8. **No Search/Filter**: Records screen shows all landmarks without search functionality

## Requirements Checklist

- ✅ REST API CRUD operations (GET, POST, PUT, DELETE)
- ✅ Interactive map centered on Bangladesh
- ✅ GPS auto-detection for coordinates
- ✅ Image upload with resize (800×600)
- ✅ Form validation and error handling
- ✅ Success/error feedback messages
- ✅ Offline mode with SQLite caching
- ✅ Custom markers with tap interaction
- ✅ List view with swipe actions
- ✅ Cyberpunk themed UI
- ✅ 10+ meaningful commits
- ✅ Feature branch workflow
- ✅ Conventional commit messages

## License

This project is created for CSE 489 Lab Exam - Mobile Application Development.

## Developer

Created by: Shahjalal Farhan Bhuiyan  
Student ID: 22299307 
Course: CSE 489 - Mobile Application Development  
Institution: BRAC University
