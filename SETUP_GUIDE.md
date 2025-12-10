# Bangladesh Landmarks Manager - Complete Setup Guide

## 🚀 Quick Start (3 Steps)

### Step 1: Install Dependencies
```bash
cd bangladesh_landmarks
flutter pub get
```

### Step 2: Run the App
```bash
flutter run
```

### Step 3: Grant Permissions
When app starts, grant:
- Location permission (for GPS)
- Camera permission (for photos)
- Storage permission (for gallery)

**That's it! No API key needed - OpenStreetMap is completely free!**

---

## 📱 How to Use the App

### Tab 1: Overview (Map)
- View all landmarks on OpenStreetMap
- Map centered on Bangladesh (23.6850°N, 90.3563°E)
- Tap any red marker to see details in bottom sheet
- Bottom sheet shows: photo, title, coordinates, edit/delete buttons
- Pinch to zoom, drag to pan

### Tab 2: Records (List)
- Scrollable list of all landmarks
- **Swipe left** on any item to edit or delete
- Pull down to refresh from server
- Each card shows thumbnail, title, and coordinates

### Tab 3: New Entry (Add Landmark)
1. Tap image placeholder → Choose camera or gallery
2. Enter landmark title
3. Click "Detect My Location" (auto-fills GPS coordinates)
   - Or manually enter latitude/longitude
4. Click "Create Landmark"
5. Image is automatically resized to 800×600 before upload

---

## 🔧 Technical Details

### Map Technology
- **OpenStreetMap** - Free, open-source mapping
- No API key required
- No billing setup needed
- Tile server: `tile.openstreetmap.org`

### API Endpoints
**Base URL**: `https://labs.anontech.info/cse489/t3/api.php`

- **Create**: `POST /api.php` (multipart/form-data)
  - Fields: title, lat, lon, image
- **Read All**: `GET /api.php`
- **Update**: `PUT /api.php` (x-www-form-urlencoded)
  - Fields: id, title, lat, lon, image (optional)
- **Delete**: `DELETE /api.php`
  - Fields: id

### Offline Mode
- App automatically caches data in SQLite database
- Works offline with cached data
- Shows orange "Offline Mode" banner when no internet
- Auto-syncs when connection restored

### Image Handling
- Automatically resized to 800×600 pixels
- JPEG compression at 85% quality
- Supports camera and gallery selection

---

## 🐛 Troubleshooting

### Map tiles not loading
**Problem**: Map shows grey boxes  
**Fix**: 
- Check internet connection
- Map tiles load from OpenStreetMap servers
- No configuration needed

### "Failed to detect location"
**Problem**: GPS detection fails  
**Fix**: 
- Enable location services on device
- Grant location permission to app
- For emulator: Set location in extended controls

### Build errors
**Problem**: App won't compile  
**Fix**: 
```bash
flutter clean
flutter pub get
flutter run
```

### Images won't upload
**Problem**: Upload fails  
**Fix**:
- Check internet connection
- Ensure camera/storage permissions granted
- Verify API endpoint is accessible

---

## 📦 Project Structure

```
lib/
├── main.dart                      # App entry with 3-tab navigation
├── models/
│   ├── landmark.dart              # Landmark data model
│   └── auth_user.dart             # Auth user model
├── services/
│   ├── api_service.dart           # REST API calls (Dio)
│   ├── image_service.dart         # Image resize/storage
│   └── location_service.dart      # GPS services
├── database/
│   └── database_helper.dart       # SQLite offline storage
├── providers/
│   ├── landmark_provider.dart     # Landmark state management
│   └── auth_provider.dart         # Auth state management
├── screens/
│   ├── map_screen.dart            # OpenStreetMap view tab
│   ├── records_screen.dart        # List view tab
│   └── landmark_form_screen.dart  # Add/edit form
└── widgets/
    └── landmark_bottom_sheet.dart # Marker detail popup
```

---

## 🧪 Testing Data

Use these Bangladesh landmarks for testing:

**Ahsan Manzil**: Lat 23.7098, Lon 90.4063  
**Lalbagh Fort**: Lat 23.7186, Lon 90.3916  
**National Martyrs' Memorial**: Lat 23.9145, Lon 90.2741  
**Cox's Bazar Beach**: Lat 21.4272, Lon 92.0058  
**Sundarbans**: Lat 21.9497, Lon 89.1833

---

## 💰 Cost Information

**100% FREE!**
- OpenStreetMap: Free and open-source
- No API key required
- No billing setup needed
- No usage limits
- No credit card needed

---

## 📱 Building Release APK

```bash
# For Android
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# For Play Store
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

---

## ⚙️ Configuration Files

### Android Configuration
File: `android/app/src/main/AndroidManifest.xml`
- Permissions: Internet, Location, Camera, Storage
- Min SDK: 21

### iOS Configuration
File: `ios/Runner/Info.plist`
- Location usage description
- Camera usage description
- Photo library usage description

---

## ✅ Features Implemented

- ✅ REST API integration (CRUD operations)
- ✅ OpenStreetMap with custom markers
- ✅ Offline caching with SQLite
- ✅ GPS location detection
- ✅ Image upload with auto-resize (800×600)
- ✅ Bottom navigation (3 tabs)
- ✅ Swipe-to-edit/delete
- ✅ Material Design UI
- ✅ Error handling with snackbars/dialogs
- ✅ Authentication infrastructure (ready to configure)
- ✅ **No API key needed!**

---

## 📞 Support

**Flutter Issues**: Run `flutter doctor` to check setup  
**API Issues**: Contact instructor  
**Map Issues**: Check internet connection  

---

## 🌍 Why OpenStreetMap?

✅ **Free forever** - No API keys, no billing  
✅ **Open source** - Community-driven  
✅ **No limits** - Unlimited map loads  
✅ **Privacy-friendly** - No tracking  
✅ **Reliable** - Used by millions of apps  

---

**That's it! Just run `flutter pub get` and `flutter run` - you're ready to go!** 🎉
