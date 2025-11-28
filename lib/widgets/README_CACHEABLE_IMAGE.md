# Cacheable Image Widget

A reusable widget for displaying cached images from URLs with automatic caching, placeholder, and error handling.

## Features

- ✅ Automatic image caching
- ✅ Placeholder while loading
- ✅ Error handling with fallback widget
- ✅ Fade-in/fade-out animations
- ✅ Support for circular and rounded images
- ✅ Specialized avatar widget with initials fallback
- ✅ Customizable headers for authenticated requests

## Usage

### Basic Usage

```dart
import 'package:demoapp/widgets/cacheable_image.dart';

CacheableImage(
  imageUrl: 'https://example.com/image.jpg',
  width: 200,
  height: 200,
)
```

### Circular Image (Avatar)

```dart
CacheableImage.circle(
  imageUrl: 'https://example.com/avatar.jpg',
  radius: 50,
)
```

### Rounded Rectangle Image

```dart
CacheableImage.rounded(
  imageUrl: 'https://example.com/image.jpg',
  width: 200,
  height: 200,
  borderRadius: 12.0,
)
```

### With Custom Placeholder and Error Widget

```dart
CacheableImage(
  imageUrl: 'https://example.com/image.jpg',
  width: 200,
  height: 200,
  placeholder: Container(
    color: Colors.grey[300],
    child: Center(child: CircularProgressIndicator()),
  ),
  errorWidget: Icon(Icons.error, size: 50),
)
```

### With HTTP Headers (for authenticated requests)

```dart
CacheableImage(
  imageUrl: 'https://example.com/protected-image.jpg',
  width: 200,
  height: 200,
  httpHeaders: {
    'Authorization': 'Bearer your-token',
    'X-API-Key': 'your-api-key',
  },
)
```

### Cacheable Avatar Widget

The `CacheableAvatar` widget is specifically designed for user avatars with automatic fallback to initials:

```dart
CacheableAvatar(
  imageUrl: 'https://example.com/avatar.jpg',
  radius: 30,
  name: 'John Doe', // Shows "JD" if image fails to load
  backgroundColor: Colors.blue,
  textColor: Colors.white,
)
```

## Properties

### CacheableImage

| Property | Type | Description |
|----------|------|-------------|
| `imageUrl` | `String` | **Required.** The URL of the image to load |
| `width` | `double?` | Width of the image |
| `height` | `double?` | Height of the image |
| `fit` | `BoxFit` | How the image should be fitted (default: `BoxFit.cover`) |
| `placeholder` | `Widget?` | Widget to show while loading |
| `errorWidget` | `Widget?` | Widget to show on error |
| `fadeInDuration` | `Duration?` | Duration of fade-in animation |
| `fadeOutDuration` | `Duration?` | Duration of fade-out animation |
| `color` | `Color?` | Color to blend with the image |
| `colorBlendMode` | `BlendMode?` | Blend mode for color blending |
| `borderRadius` | `BorderRadius?` | Border radius for rounded corners |
| `shape` | `BoxShape` | Shape of the image container (default: `BoxShape.rectangle`) |
| `httpHeaders` | `Map<String, String>?` | HTTP headers for the request |

### CacheableAvatar

| Property | Type | Description |
|----------|------|-------------|
| `imageUrl` | `String?` | URL of the avatar image |
| `radius` | `double` | **Required.** Radius of the circular avatar |
| `name` | `String?` | Name to show initials if image fails |
| `backgroundColor` | `Color?` | Background color for placeholder/error |
| `textColor` | `Color?` | Text color for initials |
| `httpHeaders` | `Map<String, String>?` | HTTP headers for the request |

## Examples in the App

The widget is already being used in:
- `lib/screens/home_screen.dart` - For displaying user avatars and profile images

## Benefits

1. **Performance**: Images are cached locally, reducing network requests
2. **User Experience**: Smooth loading with placeholders and error handling
3. **Memory Efficient**: Automatic cache management
4. **Offline Support**: Cached images work offline
5. **Easy to Use**: Simple API with sensible defaults

