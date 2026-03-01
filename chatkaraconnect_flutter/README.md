# ChatkaraConnect Flutter App

A Flutter mobile application for **ChatkaraConnect** - a catering service platform that connects customers with professional caterers.

## Features

✅ **User Authentication**
- Customer & Vendor registration
- Secure login with email and password
- User profile management

✅ **Vendor Discovery**
- Search and filter vendors by name, category, location
- View detailed vendor information
- Check ratings and customer reviews
- Browse vendor menus

✅ **Event Booking**
- Create booking requests for events
- Select event date, type, and guest count
- Set budget for catering services

✅ **Order Management**
- Track booking status (Pending, Accepted, Completed)
- View order history
- Leave feedback and ratings

✅ **Payment Integration** (Ready for implementation)
- Payment processing support
- Multiple payment methods

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── config/
│   └── api_config.dart         # API configuration & base URLs
├── models/
│   ├── user.dart               # User model
│   ├── vendor.dart             # Vendor model
│   ├── order.dart              # Order model
│   ├── menu.dart               # Menu model
│   ├── feedback.dart           # Feedback/Review model
│   └── payment.dart            # Payment model
├── services/
│   └── api_service.dart        # API calls & HTTP client
├── screens/
│   ├── login_screen.dart       # Login screen
│   ├── register_screen.dart    # User registration
│   ├── home_screen.dart        # Vendor listing & search
│   ├── vendor_detail_screen.dart
│   └── booking_screen.dart     # Event booking form
└── widgets/
    ├── custom_widgets.dart     # Reusable UI components
    └── vendor_card.dart        # Vendor list card
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio or Xcode (for emulator)
- Django backend running on `http://localhost:8000`

### Installation

1. **Navigate to the Flutter project:**
```bash
cd chatkaraconnect_flutter
```

2. **Get dependencies:**
```bash
flutter pub get
```

3. **Update API URL** (if backend is on different machine):
   Open `lib/config/api_config.dart` and change:
   ```dart
   static const String baseUrl = 'http://YOUR_IP:8000/api';
   ```

4. **Run the app:**
```bash
flutter run
```

Or on specific device:
```bash
flutter run -d chrome        # Web
flutter run -d windows       # Windows
```

## API Endpoints Used

The app connects to the Django REST API:

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/users/login/` | POST | User login |
| `/api/users/register/` | POST | User registration |
| `/api/vendors/` | GET | List vendors |
| `/api/vendors/{id}/` | GET | Vendor details |
| `/api/vendors/register_vendor/` | POST | Vendor registration |
| `/api/orders/` | GET/POST | List/Create orders |
| `/api/menu/` | GET | Get menu items |
| `/api/feedback/` | GET/POST | Get/Create feedback |
| `/api/payments/` | GET/POST | Payment management |

## Key Dependencies

- **http**: HTTP client for API calls
- **shared_preferences**: Local data storage
- **flutter_rating_bar**: Rating component
- **cached_network_image**: Image caching
- **intl**: Date/time formatting
- **table_calendar**: Calendar widget (for date selection)

## Configuration

### Backend Connection
Update the API base URL in `lib/config/api_config.dart`:

```dart
static const String baseUrl = 'http://localhost:8000/api';
```

For production, change to your production server URL.

### Local Storage
The app uses `SharedPreferences` to store:
- User ID
- User email
- User name
- User role (customer/vendor)

## Screens Overview

### 1. Login Screen
- Email and password input
- Link to register page
- Validates credentials against backend

### 2. Register Screen
- Name, email, phone, password fields
- Account type selection (Customer/Vendor)
- Form validation

### 3. Home Screen
- Welcome message with user name
- Search bar for vendors
- Grid view of vendors with ratings
- Tap to view vendor details

### 4. Vendor Detail Screen
- Full vendor information
- Menu items with prices
- Customer reviews and ratings
- Location and service area info
- "Book Now" button

### 5. Booking Screen
- Vendor summary card
- Event details form
- Date picker
- Guest count and budget inputs
- Submit booking

## Building for Release

### Android
```bash
flutter build apk
```

### iOS
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

## Troubleshooting

### API Connection Issues
- Ensure Django backend is running
- Check if your machine IP is correct in `api_config.dart`
- For emulator, use `http://10.0.2.2:8000` instead of `localhost`

### Image Loading Issues
- Verify vendor images are uploaded to `/media/vendor_images/` on backend
- Check network connectivity

### State Management
For large projects, consider using:
- Provider (already in pubspec.yaml)
- Riverpod
- Bloc

## Future Enhancements

- [ ] Payment gateway integration (Razorpay/Stripe)
- [ ] Push notifications for order updates
- [ ] Real-time chat with vendors
- [ ] Advanced filtering and sorting
- [ ] Vendor analytics dashboard
- [ ] Reviews with images
- [ ] Wallet functionality
- [ ] Referral program

## License

This project is part of the ChatkaraConnect platform.

## Support

For issues or questions:
1. Check Django backend API responses
2. Review Flutter console logs
3. Verify network connectivity
4. Check SharedPreferences data storage

---

**Happy Coding! 🎉**
