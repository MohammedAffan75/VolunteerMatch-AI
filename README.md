# VolunteerMatch AI

VolunteerMatch AI is a cross-platform Flutter app (Android, iOS, Web) that connects volunteers and NGOs in real time, with AI-powered matching using Gemini through Firebase AI.

This project is designed for **Google Solution Challenge 2026** and focuses on Karnataka social-impact use cases:
- Rural literacy
- Flood relief
- Community health camps

It aligns with:
- **UN SDG 17**: Partnerships for the Goals
- **UN SDG 3**: Good Health and Well-being
- **UN SDG 4**: Quality Education

---

## 1) Core Features

- Firebase Authentication (Email/Password + Google Sign-In)
- Role-based onboarding (`volunteer` and `ngo`)
- Opportunity posting and live listing (Firestore streams)
- AI Smart Matching with Gemini (`gemini-2.5-flash`)
- Realtime chat between volunteers and NGOs
- Push notification foundation with Firebase Cloud Messaging
- Volunteer dashboard with impact charts and gamification points/badges
- Material 3 UI with responsive layout for mobile + web
- Karnataka-focused demo opportunity seeding

---

## 2) Tech Stack

### Frontend
- Flutter (Material 3)
- Riverpod (state management)
- fl_chart (impact visualizations)

### Backend / Cloud
- Firebase Core
- Firebase Auth
- Cloud Firestore
- Firebase Cloud Messaging
- Firebase AI (Gemini API integration)

### Utility
- intl, shared_preferences, uuid
- geolocator, google_maps_flutter (location/map ready)

---

## 3) Project Structure

```text
lib/
  main.dart
  models/
    user_model.dart
    opportunity_model.dart
    match_model.dart
  services/
    auth_service.dart
    opportunity_service.dart
    gemini_matching_service.dart
    notification_service.dart
    chat_service.dart
    app_providers.dart
    demo_data_service.dart
  screens/
    auth/
      login_screen.dart
      register_screen.dart
      onboarding_screen.dart
    home/
      opportunities_screen.dart
      opportunity_form_screen.dart
    matches/
      smart_matches_screen.dart
    chat/
      chat_list_screen.dart
      chat_screen.dart
    dashboard/
      dashboard_screen.dart
    profile/
      profile_screen.dart
assets/
  images/
firestore.rules
pubspec.yaml
```

---

## 4) Data Model and Firestore Design

### Collections
- `users/{uid}`
- `opportunities/{oppId}`
- `chats/{chatId}/messages/{messageId}`

### `users/{uid}`
- `uid: String`
- `role: "volunteer" | "ngo"`
- `name: String`
- `email: String`
- `skills: List<String>`
- `availability: List<String>`
- `latitude: double`
- `longitude: double`
- `preferredCauses: List<String>`
- `points: int`
- `badges: List<String>`
- `totalHours: double`

### `opportunities/{oppId}`
- `id: String`
- `title: String`
- `description: String`
- `requiredSkills: List<String>`
- `cause: String`
- `latitude: double`
- `longitude: double`
- `dateTime: String (ISO8601)`
- `numberNeeded: int`
- `status: "open" | "closed"`
- `postedBy: String (NGO uid)`
- `applicants: List<String> (volunteer uids)`

### `chats/{chatId}`
- `participants: List<String>`
- `updatedAt: Timestamp`

### `chats/{chatId}/messages/{messageId}`
- `senderId: String`
- `text: String`
- `createdAt: Timestamp`

---

## 5) Firebase Setup (Step-by-Step)

## Prerequisites
- Flutter SDK installed
- Dart SDK installed
- Firebase CLI installed
- FlutterFire CLI installed

### A. Create Flutter App

```bash
flutter create volunteer_match_ai
cd volunteer_match_ai
```

Copy this repository code into the project, then run:

```bash
flutter pub get
```

### B. Create Firebase Project
1. Open [Firebase Console](https://console.firebase.google.com/)
2. Create a new project: `VolunteerMatch AI`
3. Add apps:
   - Android
   - iOS (optional for now)
   - Web

### C. Configure FlutterFire

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart` and links your app with Firebase.

### D. Enable Firebase Products
1. **Authentication**
   - Enable Email/Password
   - Enable Google Sign-In
2. **Cloud Firestore**
   - Create database in production mode
   - Choose closest region suitable for Karnataka users
3. **Cloud Messaging**
   - Enable FCM

### E. Platform Files
- Android: ensure `google-services.json` is in `android/app/`
- iOS: ensure `GoogleService-Info.plist` is in `ios/Runner/`

### F. Run App

```bash
flutter run
```

For web:

```bash
flutter run -d chrome
```

---

## 6) Firestore Rules

Project includes `firestore.rules` with authenticated read/write baseline rules.

Deploy rules:

```bash
firebase deploy --only firestore:rules
```

> Note: For production, tighten rules with role checks, ownership validation, and participant-based chat restrictions.

---

## 7) Authentication Flow

Implemented screens:
- `LoginScreen`
- `RegisterScreen` (role selection: Volunteer/NGO)
- `OnboardingScreen` (skills, causes, availability, location)

Service:
- `auth_service.dart` handles:
  - Email login/register
  - Google sign-in
  - Profile creation/update in Firestore
  - Auth state stream

---

## 8) Opportunity Management

### NGO Side
- `OpportunityFormScreen` to create opportunities with:
  - title, description
  - required skills
  - cause
  - location (lat/lng)
  - date/time
  - volunteers needed

### Volunteer + NGO Side
- `OpportunitiesScreen`:
  - realtime `StreamBuilder`-style updates via Riverpod stream provider
  - search by title/description
  - cause filtering
  - apply action
  - demo data seed action for Karnataka use cases

---

## 9) Gemini AI Smart Matching

Service:
- `lib/services/gemini_matching_service.dart`

What it does:
- Takes a volunteer profile and opportunity
- Sends structured context to Gemini (`gemini-2.5-flash`)
- Expects strict JSON output:
  - `matchScore` (0-100)
  - `reason`
  - `biasCheck`
  - `recommendation`

Scoring dimensions in prompt:
- Skills fit (35%)
- Cause alignment (25%)
- Availability overlap (20%)
- Location practicality (20%)

Screen:
- `SmartMatchesScreen`
  - Generates and displays AI match cards
  - Refreshable for demo "before/after AI" experience

---

## 10) Realtime Features

### Push Notifications
- `notification_service.dart`
- Requests permissions and subscribes to topics:
  - `opportunity_matches`
  - `application_updates`

### Chat
- `ChatListScreen`
- `ChatScreen`
- `chat_service.dart` handles:
  - chat list stream
  - message stream
  - sending messages with timestamps

### Realtime Opportunities
- Firestore snapshot stream via `OpportunityService.streamOpenOpportunities()`

---

## 11) Dashboard and Impact Tracking

`DashboardScreen` includes:
- Total volunteering hours
- Points
- Estimated people helped
- Badge chips
- Bar chart visualization (`fl_chart`)
- Action to log post-event hours (placeholder CTA, extendable)

`ProfileScreen` includes:
- basic profile editing
- skills update
- sign out
- chat navigation

---

## 12) Navigation and UX

Bottom Navigation in `main.dart`:
- Home
- Matches
- My Activity
- Profile

Also includes:
- Loading indicators
- Empty states
- Error fallback text
- Responsive content width usage for auth pages

---

## 13) Karnataka Demo Data

`demo_data_service.dart` seeds sample opportunities:
- Rural Literacy Weekend - Mysuru
- Flood Relief Logistics - Kodagu
- Community Health Camp - Bengaluru Rural

This is useful for demo without manual content entry.

---

## 14) How to Demo (Solution Challenge Flow)

Suggested 3-5 minute demo script:
1. Register as NGO and post a new opportunity
2. Register/login as volunteer and complete onboarding
3. Show live opportunities and filtering
4. Open AI Smart Matches and explain score + fairness note
5. Apply to an opportunity and show realtime chat
6. Show dashboard impact (hours, points, badges, chart)
7. Close with SDG alignment and Karnataka impact story

---

## 15) Improvements for Production

- Add strict role-based Firestore rules
- Add Cloud Functions for automatic FCM on match/accept
- Store geolocation as Firestore `GeoPoint` consistently
- Add robust form validation and localization (Kannada + English)
- Add offline caching and background sync
- Add NGO feedback flow that updates volunteer points/badges automatically
- Add analytics and impact export for NGO reporting

---

## 16) Troubleshooting

### Common Issues
- **Firebase not initialized**: run `flutterfire configure` and ensure platform config files exist.
- **Google Sign-In fails**: add SHA fingerprints for Android and verify OAuth setup.
- **Firestore permission denied**: deploy rules and verify authenticated state.
- **AI response parse issue**: model may return non-JSON wrapper; parser fallback is already included.

---

## 17) License

Use your preferred license for submission (MIT recommended for open demo projects).

---

## 18) Credits

Built for **Google Solution Challenge 2026** with Flutter + Firebase + Gemini AI.

