# Neo Weather - AI Coding Instructions

## Project Overview
Neo Weather is a Flutter weather app for Android & iOS that fetches real-time weather data from OpenWeather API. The app features dynamic backgrounds/icons that change based on weather conditions, persistent city storage, and a pull-to-refresh interface.

## Architecture & Project Structure

### Component-Based Architecture
The app follows a **screen + components** pattern:
- **Screens** (`lib/screens/`): Top-level pages (`homeScreen.dart`, `searchScreen.dart`)
- **Components** (`lib/components/`): Organized by parent screen (`homeScreen/`, `searchScreen/`)
- **Shared Logic** (`lib/components/homeScreen/helpers.dart`): Configuration maps and utility functions

### Key Files & Responsibilities
- `lib/main.dart`: App entry point, loads `.env`, locks portrait orientation
- `lib/screens/homeScreen.dart`: Main screen with weather display, handles API calls, pull-to-refresh, SharedPreferences
- `lib/screens/searchScreen.dart`: City search interface with gradient overlay
- `lib/components/homeScreen/helpers.dart`: **Central config** - defines `weatherStatus` map linking weather conditions to images/icons/overlays
- `lib/components/homeScreen/weatherDetails.dart`: Displays temperature, weather icon, and data bars
- `lib/components/searchScreen/searchBox.dart`: Handles city validation, API calls, navigation

## Data Flow & State Management

### Weather Data Flow
1. User adds city via `SearchBox` → API validation → Save to `SharedPreferences`
2. `HomeScreen.initState()` → Check `SharedPreferences` → Fetch weather data
3. Weather data updates `weatherData` map → UI rerenders
4. Pull-to-refresh → Clear state → Refetch data

### State Management Pattern
**StatefulWidget with `setState`** - No state management library used. State is lifted to screen level:
```dart
Map<String, dynamic> weatherData = {};  // Holds all weather info
bool? isSetWeather;  // Tracks if city is configured
String? weatherMainStatus;  // Current weather condition
```

### Persistent Storage
Uses `SharedPreferences` to store:
- `'city'` (String): Last searched city
- `'isSetWeather'` (bool): Whether weather is configured

## Environment Configuration

### Required Setup
Create `.env` file in project root (never commit this):
```bash
OPENWEATHER_API_KEY=your_api_key_here
```

Access API key: `dotenv.env['OPENWEATHER_API_KEY']`

Template file: `.env.example`

## Weather Condition System

### Dynamic UI Based on Weather
All weather conditions are configured in `lib/components/homeScreen/helpers.dart`:
```dart
weatherStatus['Clear']  // { img: 'assets/images/sunny.jpg', icon: 'assets/icons/sun.svg', overlay: BoxDecoration(...) }
```

Supported conditions: `Clear`, `Haze`, `Smoke`, `Mist`, `Clouds`, `Rain`, `Snow`

### Adding New Weather Conditions
1. Add entry to `weatherStatus` map in `helpers.dart`
2. Add corresponding image to `assets/images/`
3. Add corresponding SVG icon to `assets/icons/`
4. Update `pubspec.yaml` if adding new asset directories

## Code Conventions

### Color Usage
- Use `Colors.grey[900]` for dark backgrounds (scaffold background set in theme)
- Use `withValues(alpha: X)` for transparency (Flutter 3.5+ API): `Colors.black.withValues(alpha: 0.25)`
- DO NOT use deprecated `.withOpacity()` method

### Widget Patterns
- **Stateless widgets** for pure UI components (`ProgressBar`, `WeatherData`, `HeadSection`)
- **Stateful widgets** for screens with API calls or user input (`HomeScreen`, `SearchBox`)
- Use `const` constructors wherever possible
- Pass callbacks as `VoidCallback` parameters (e.g., `openDeleteDialog`)

### Navigation
Standard Flutter navigation with replacement for main flow:
```dart
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => HomeScreen()),
  (Route<dynamic> route) => false,
)
```

### API Integration
OpenWeather API v2.5: `https://api.openweathermap.org/data/2.5/weather?q={city}&appid={key}&units=metric`
- Units: Always metric (`°C`, `km/h`)
- Error handling: Check `fetchedData['cod'] != '404'`
- Null safety: Check API key exists before calls

## Developer Workflows

### Initial Setup
```powershell
flutter pub get
# Create .env file from .env.example
flutter run
```

### Building
```powershell
# Debug APK
flutter build apk

# Release APK
flutter build apk --release

# Release App Bundle
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release
```

### Testing
```powershell
flutter test
flutter test --coverage
```

### Common Issues
- **Missing API key**: App will show error state - ensure `.env` exists with valid key
- **City not found**: `SearchBox` displays "Enter a valid city name"
- **Portrait lock**: Set in `main.dart` via `SystemChrome.setPreferredOrientations`

## Dependencies & Versions
- **Flutter SDK**: >=3.5.0 <4.0.0
- **Key packages**: `http` (API calls), `shared_preferences` (storage), `flutter_dotenv` (env vars), `flutter_svg` (icons), `timer_builder` (clock), `intl` (date formatting)
- **No state management library** - uses built-in `setState`

## Platform-Specific Notes
- **Android**: `minSdkVersion` from Flutter config, `targetSdkVersion` 35, namespace `com.rezuanulfahim.neo_weather`
- **iOS**: Standard Flutter configuration
- **Orientation**: Portrait-only (enforced in `main.dart`)
- **Assets**: SVG icons require `flutter_svg`, images are standard assets

## UI/UX Patterns
- **Pull-to-refresh**: Implemented via `RefreshIndicator` wrapping `CustomScrollView`
- **Loading states**: Show `CircularProgressIndicator` during API calls
- **Empty state**: "Add City" button when no city configured
- **Gradient overlays**: Applied to background images for text readability (defined in `weatherStatus`)
- **Dynamic clock**: Uses `TimerBuilder.periodic` with 1-second updates
