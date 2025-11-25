# Deep Linking Setup for Fan Poll World

## Overview
This document explains the deep linking implementation for sharing polls. Users can share polls via URL (`https://fanpollworld.com/share/poll/{id}`) and when recipients open the link:
- **If logged in**: They can vote on active polls or view past polls with vote history
- **If not logged in (guest)**: They see a login/register dialog to access features

## What's Implemented

### 1. Core Deep Linking Components
- **UrlHandlerService** (`lib/app/utills/url_handler_service.dart`): Handles URL parsing and routing
- **SharedPollView** (`lib/app/modules/shared_poll/views/shared_poll_view.dart`): Displays individual polls from shared links
- **SharedPollController & Binding**: GetX controller and dependency binding
- **API Enhancement**: Added `getPollById()` method to `ApiService`

### 2. Route Configuration
- Added `/shared-poll` route to `app_pages.dart`
- Route accepts `pollId` and `isGuest` parameters

### 3. Share Button Update
- Updated share button in `home_view.dart` (both active and past poll sections)
- New share format: `https://fanpollworld.com/share/poll/{pollId}`

### 4. Platform-Specific Configuration

#### Android (`android/app/src/main/AndroidManifest.xml`)
- Added intent filters for `https://fanpollworld.com/share/poll` and `https://fanpollworld.com/poll` URLs
- Configured `singleTop` launch mode for activity

#### iOS (`ios/Runner/Info.plist`)
- Added `fanpollworld` URL scheme
- Added Bonjour service configuration

#### Web (`lib/main.dart`)
- Added `setupDeepLinking()` function
- Web deep link handler reads `Uri.base` and navigates to shared poll

## Features Implemented

### Guest User Behavior
- Guests can view the poll UI
- When attempting actions (vote, like, comment), they see a login dialog
- Dialog offers options to login or register
- After authentication, they're redirected back to the poll

### Login User Behavior  
- Active polls: Can vote and see results
- Past polls: Can view results (can't vote)
- Can like/unlike polls
- Can view and add comments

### Poll State Handling
- Automatically detects if poll is active or expired
- Shows appropriate UI based on poll status
- Displays login requirements for guest users

## Additional Configuration Needed

### 1. Add uni_links Dependency (for native deep linking)
```yaml
dependencies:
  uni_links: ^0.0.4
```

If you want full native deep linking support on mobile, add this to `pubspec.yaml` and implement:
```dart
// In setupDeepLinking() function
void _handleMobileDeepLink() async {
  try {
    deepLinkStream.listen((String? link) {
      if (link != null) {
        UrlHandlerService.to.handleSharedUrl(link);
      }
    }, onError: (err) {
      print('Deep linking error: $err');
    });
  } catch (e) {
    print('Error in deep link handling: $e');
  }
}
```

### 2. Add Associated Domains (iOS)
To enable web-based deep links on iOS, add to `ios/Runner/Runner.entitlements`:
```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:fanpollworld.com</string>
</array>
```

And `ios/Runner/RunnerProfile.entitlements`:
```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:fanpollworld.com</string>
</array>
```

### 3. Setup Web Association (iOS/Android)
Create `fanpollworld.com/.well-known/apple-app-site-association`:
```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "YOUR_TEAM_ID.com.example.fanpoll",
        "paths": ["/share/poll/*", "/poll/*"]
      }
    ]
  }
}
```

Create `fanpollworld.com/.well-known/assetlinks.json`:
```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.example.fanpoll",
      "sha256_cert_fingerprints": ["YOUR_SHA256_FINGERPRINT"]
    }
  }
]
```

### 4. Update Backend Endpoint (if needed)
If your backend uses a different endpoint structure, update the `getPollById()` method in `appServices.dart`:
```dart
final uri = Uri.parse('${baseUrl}poll/$pollId'); // Adjust path as needed
```

## Testing

### Web Testing
Navigate to: `http://localhost:xxxx/share/poll/1` (adjust port and poll ID)

### Android Testing
```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://fanpollworld.com/share/poll/1" com.example.fanpoll
```

### iOS Testing
```bash
xcrun simctl openurl booted "https://fanpollworld.com/share/poll/1"
```

## Files Modified/Created

### Created:
- `lib/app/modules/shared_poll/views/shared_poll_view.dart`
- `lib/app/modules/shared_poll/controllers/shared_poll_controller.dart`
- `lib/app/modules/shared_poll/bindings/shared_poll_binding.dart`

### Modified:
- `lib/app/utills/url_handler_service.dart`
- `lib/app/utills/appServices.dart` (added `getPollById()`)
- `lib/app/routes/app_pages.dart` (added imports & route)
- `lib/app/routes/app_routes.dart` (added SHAREDPOLL route)
- `lib/app/modules/home/views/home_view.dart` (updated share button URL)
- `lib/main.dart` (added deep link setup)
- `android/app/src/main/AndroidManifest.xml` (added intent filters)
- `ios/Runner/Info.plist` (added URL scheme & Bonjour service)

## Troubleshooting

### Shared poll not loading
1. Check poll ID is valid
2. Verify API endpoint is correct in `getPollById()`
3. Check network tab for API errors

### Login dialog not appearing for guests
- Ensure `isGuest` parameter is correctly set
- Check if user token is being properly retrieved

### Deep link not triggering
- Android: Verify AndroidManifest.xml has correct host and pathPrefix
- iOS: Check Info.plist has CFBundleURLSchemes configured
- Web: Ensure URL contains `/share/poll/` path

## Notes
- The implementation handles both logged-in users and guests
- Guest users are shown a login dialog on actions
- Past polls show results but voting is disabled
- Active polls allow voting with real-time UI updates
