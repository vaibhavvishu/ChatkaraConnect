# ChatkaraConnect Flutter Setup Guide

Complete step-by-step guide to set up and run the Flutter app.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Backend Setup](#backend-setup)
3. [Flutter Installation](#flutter-installation)
4. [Project Setup](#project-setup)
5. [Running the App](#running-the-app)
6. [API Configuration](#api-configuration)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### System Requirements
- **OS**: Windows, macOS, or Linux
- **RAM**: 4GB minimum (8GB recommended)
- **Disk**: 5GB free space
- **Git**: Installed and configured

### Required Software
1. **Flutter SDK** (v3.0.0 or later)
   - Download from: https://flutter.dev/docs/get-started/install
   
2. **Dart SDK** (included with Flutter)
   
3. **Android SDK** (for Android development)
   - Android Studio: https://developer.android.com/studio
   - Or install via command line tools
   
4. **Xcode** (for iOS development - macOS only)
   - Install via App Store or `xcode-select --install`

5. **Git** (for version control)

---

## Backend Setup

### 1. Ensure Django Backend is Running

```bash
cd d:\coding\clg project\ChatkaraConnect

# Install requirements
pip install -r req.txt

# Run migrations
python manage.py migrate

# Create superuser (optional)
python manage.py createsuperuser

# Start development server
python manage.py runserver
```

The backend should be running on: `http://localhost:8000`

### 2. Verify API Endpoints

Test if API is working:
```bash
curl http://localhost:8000/api/vendors/
```

---

## Flutter Installation

### Windows

1. **Download Flutter SDK**
   ```bash
   # Using Git
   git clone https://github.com/flutter/flutter.git -b stable
   ```
   
2. **Add Flutter to PATH**
   - Add `C:\path\to\flutter\bin` to your system PATH
   
3. **Verify Installation**
   ```bash
   flutter --version
   dart --version
   ```

### macOS

```bash
# Using Homebrew
brew install flutter

# Or manually
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (~/.zshrc or ~/.bash_profile)
export PATH="$PATH:$HOME/flutter/bin"
```

### Linux

```bash
cd ~
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (~/.bashrc or ~/.profile)
export PATH="$PATH:$HOME/flutter/bin"
```

---

## Project Setup

### 1. Navigate to Flutter Project
```bash
cd d:\coding\clg project\ChatkaraConnect\chatkaraconnect_flutter
```

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Check Flutter Setup
```bash
flutter doctor
```

Expected output should show:
- ✓ Flutter SDK
- ✓ Dart SDK
- ✓ Android SDK (or Xcode for iOS)

### 4. Update API Configuration

Open `lib/config/api_config.dart` and update the base URL:

**For Local Development:**
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

**For Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

**For Physical Device:**
```dart
static const String baseUrl = 'http://YOUR_COMPUTER_IP:8000/api';
// Example: http://192.168.1.100:8000/api
```

---

## Running the App

### Option 1: Chrome (Easiest for Testing)

```bash
flutter run -d chrome
```

### Option 2: Android Emulator

1. **Open Android Studio**
   - Click AVD Manager
   - Create or start an emulator

2. **Run the app**
   ```bash
   flutter run -d emulator-5554
   ```

### Option 3: Physical Android Device

1. **Enable Developer Mode**
   - Settings → About Phone → Tap Build Number 7 times
   
2. **Enable USB Debugging**
   - Settings → Developer Options → USB Debugging ON

3. **Connect device via USB**

4. **Run the app**
   ```bash
   flutter run
   ```

### Option 4: iOS Simulator (macOS only)

```bash
open -a Simulator
flutter run -d macos
```

### Option 5: Physical iOS Device (requires Apple Developer account)

```bash
flutter run -d ios
```

---

## API Configuration

### Backend is on Different Machine

If your backend is running on a different computer:

1. **Get Django Server IP Address**
   ```bash
   ipconfig getifaddr en0  # macOS/Linux
   ipconfig               # Windows
   ```

2. **Allow Django to accept requests**
   - Edit `ChatkaraConnect/settings.py`
   - Update ALLOWED_HOSTS:
   ```python
   ALLOWED_HOSTS = ['*']  # For development only
   ```

3. **Update API URL in Flutter**
   ```dart
   static const String baseUrl = 'http://192.168.1.100:8000/api';
   ```

4. **Restart Django server**
   ```bash
   python manage.py runserver 0.0.0.0:8000
   ```

---

## Testing the App

### Login Credentials

First, create a user account through the register screen or via Django admin:

1. **Via Django Admin**
   ```bash
   # Create superuser
   python manage.py createsuperuser
   
   # Goto http://localhost:8000/admin
   ```

2. **Via Flutter App**
   - Click "Register" on login screen
   - Enter details and submit

### Test Flow

1. **Login** with your credentials
2. **View Vendors** on home screen
3. **Search Vendors** using search bar
4. **View Details** by tapping a vendor card
5. **Book Event** by clicking "Book Now"

---

## Troubleshooting

### Issue: "Cannot connect to backend"

**Solution:**
```bash
# Check if backend is running
curl http://localhost:8000/api/vendors/

# Check firewall
# Windows: Check Windows Defender Firewall
# Allow port 8000 for Django

# Update API config to your machine IP
# Use 10.0.2.2 for emulator (not localhost)
```

### Issue: "flutter: command not found"

**Solution:**
```bash
# Check PATH setup
echo $PATH

# Add Flutter to PATH
export PATH="$PATH:$HOME/flutter/bin"

# Or add permanently to ~/.bashrc, ~/.zshrc, or ~/.profile
```

### Issue: "No devices found"

**Solution:**
```bash
# List available devices
flutter devices

# For Android:
# Start Android emulator from Android Studio

# For iOS:
# Run: open -a Simulator

# For Web:
flutter run -d chrome
```

### Issue: "Build failed"

**Solution:**
```bash
# Clean build
flutter clean

# Get dependencies again
flutter pub get

# Run with verbose output
flutter run -v
```

### Issue: "API returns 404"

**Solution:**
- Check if Django migrations are applied
- Verify API endpoint in Django urls.py
- Check if REST framework is installed
- Review Django server logs

### Issue: "Image not loading"

**Solution:**
```bash
# Ensure vendor has image uploaded
# Check MEDIA_URL and MEDIA_ROOT in settings.py
# Image path should be: http://localhost:8000/media/vendor_images/filename.jpg
```

---

## Development Tips

### Hot Reload
Press `r` in terminal to reload app without recompilation.

### Hot Restart
Press `R` in terminal to restart app.

### Debug Mode
Run with verbose logging:
```bash
flutter run -v
```

### Widget Inspector
Enable in browser dev tools to inspect Flutter widgets.

### Change API Endpoint Quickly
Create multiple config files:
```dart
// config/api_config_dev.dart
// config/api_config_prod.dart
```

---

## Building for Release

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/release/app-release.apk`

### Android App Bundle
```bash
flutter build appbundle --release
```
Output: `build/app/release/app-release.aab`

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```
Output: `build/web/`

---

## Documentation Links

- **Flutter**: https://flutter.dev/docs
- **Dart**: https://dart.dev/guides
- **Django**: https://docs.djangoproject.com
- **REST Framework**: https://www.django-rest-framework.org

---

## Support Commands

```bash
# Check Flutter setup
flutter doctor

# Check devices
flutter devices

# Clean project
flutter clean

# Get packages
flutter pub get

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/
```

---

**Need Help?** Check the error message in the console and search on Stack Overflow or Flutter GitHub issues.

Happy coding! 🚀
