# Madhesh Patro

Bilingual (Nepali / English) Flutter Android app foundation for Madhesh, Nepal.

## Phase 1
- Material 3 UI with Madhesh-inspired maroon, gold and forest-green palette
- Home dashboard with device Gregorian date
- Interactive Gregorian month calendar
- Madhesh News screen with all eight district filters
- Culture and Festivals screen
- Nepali / English language toggle
- Light / dark theme toggle
- Five-tab bottom navigation

## Data integrity
This starter does not claim to provide verified Bikram Sambat dates, tithi, Panchang, festival dates, live news, weather, exchange rates or market prices. These need reliable data sources and backend/API integration.

## Local setup
Install Flutter stable and Android SDK, then run:
```bash
flutter create . --platforms=android --org com.madheshpatro
flutter pub get
flutter analyze
flutter test
flutter run
```

## Android CI
GitHub Actions runs Flutter analyze, widget tests and a release APK build. The APK is uploaded as a workflow artifact.

## Planned milestones
1. Verified Bikram Sambat conversion and Panchang data
2. PHP/MySQL REST API and admin panel
3. News CMS integration, district feeds and offline reading
4. Festival dates, bookmarks and reminders
5. Firebase push notifications
6. Weather, exchange rates, gold/silver and radio integrations

Package: `madhesh_patro`
