# Deep Linking Setup Guide

This Flutter app is configured to handle deep links on both Android and iOS. When a user clicks a link:
- **If the app is installed**: The app opens and navigates to the appropriate screen
- **If the app is NOT installed**: The user is redirected to the app store

## Configuration

### Android Configuration

The Android manifest is already configured with:
- **App Links (HTTPS)**: `https://example.com/*`
- **Custom URL Scheme**: `demoapp://`

**Important**: Replace `example.com` in `android/app/src/main/AndroidManifest.xml` with your actual domain.

For App Links to work, you need to:
1. Host a `/.well-known/assetlinks.json` file on your domain
2. The file should contain your app's package name and SHA-256 fingerprint

Example `assetlinks.json`:
```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.dempapp.demoapp",
    "sha256_cert_fingerprints": ["YOUR_APP_SHA256_FINGERPRINT"]
  }
}]
```

### iOS Configuration

The iOS Info.plist is configured with:
- **Custom URL Scheme**: `demoapp://`
- **Universal Links**: `applinks:example.com`

**Important**: 
1. Replace `example.com` in `ios/Runner/Info.plist` with your actual domain
2. Configure the associated domain in Xcode: Runner → Signing & Capabilities → Add "Associated Domains" → Add `applinks:example.com`
3. Host an `apple-app-site-association` file on your domain at `https://example.com/.well-known/apple-app-site-association`

Example `apple-app-site-association`:
```json
{
  "applinks": {
    "apps": [],
    "details": [{
      "appID": "TEAM_ID.com.dempapp.demoapp",
      "paths": ["*"]
    }]
  }
}
```

## App Store URLs

Update the app store URLs in `lib/services/deep_link_service.dart`:
- `androidPackageName`: Your Android package name (currently `com.dempapp.demoapp`)
- `iosAppId`: Your iOS App Store ID (replace `YOUR_IOS_APP_ID`)

## Supported Routes

The app handles the following deep link routes:

- `/` or `/home` - Navigates to Home Screen
- `/profile?userId=123` - Navigates to Profile Screen with user ID
- `/products?categoryId=1&productId=2` - Navigates to Products Screen with category and product IDs
- `/settings` - Navigates to Settings Screen

## Testing Deep Links

### Android

**Custom URL Scheme:**
```bash
adb shell am start -W -a android.intent.action.VIEW -d "demoapp:///profile?userId=123" com.dempapp.demoapp
```

**App Links (HTTPS):**
```bash
adb shell am start -W -a android.intent.action.VIEW -d "https://example.com/profile?userId=123" com.dempapp.demoapp
```

### iOS

**Custom URL Scheme:**
```bash
xcrun simctl openurl booted "demoapp:///profile?userId=123"
```

**Universal Links:**
```bash
xcrun simctl openurl booted "https://example.com/profile?userId=123"
```

## Web Page for App Store Fallback

When a user clicks a link and the app is NOT installed, you need a web page that:
1. Attempts to open the app
2. If it fails (timeout), redirects to the app store

See `web/fallback.html` for an example implementation.

## Usage Example

1. User clicks a link: `https://example.com/products?categoryId=1&productId=2`
2. If app is installed: App opens and navigates to Products Screen
3. If app is NOT installed: Browser opens, JavaScript detects app is not installed, redirects to app store

