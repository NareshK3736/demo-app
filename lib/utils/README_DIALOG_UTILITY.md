# Dialog Utility

A comprehensive utility class for showing custom dialogs with rounded corners, optional title, message, buttons, and images.

## Features

- ✅ Single button dialogs
- ✅ Double button dialogs (e.g., Cancel/Confirm)
- ✅ Custom dialogs with full control
- ✅ Rounded corners (customizable)
- ✅ Optional title, message, image, and buttons
- ✅ Pre-built dialogs: Success, Error, Warning, Confirmation, Loading
- ✅ Fully customizable colors and styling
- ✅ Support for custom content

## Usage Examples

### Single Button Dialog

```dart
import 'package:demoapp/utils/dialog_utility.dart';

DialogUtility.showSingleButtonDialog(
  context: context,
  title: 'Information',
  message: 'This is a single button dialog',
  buttonText: 'OK',
  onButtonPressed: () {
    // Handle button press
    Navigator.of(context).pop();
  },
);
```

### Double Button Dialog

```dart
DialogUtility.showDoubleButtonDialog(
  context: context,
  title: 'Confirm Action',
  message: 'Are you sure you want to proceed?',
  primaryButtonText: 'Confirm',
  secondaryButtonText: 'Cancel',
  onPrimaryPressed: () {
    // Handle confirm action
    Navigator.of(context).pop();
  },
  onSecondaryPressed: () {
    // Handle cancel action
    Navigator.of(context).pop();
  },
);
```

### Dialog with Image

```dart
DialogUtility.showSingleButtonDialog(
  context: context,
  title: 'Success',
  message: 'Operation completed successfully!',
  image: Icon(
    Icons.check_circle,
    color: Colors.green,
    size: 64,
  ),
  buttonText: 'OK',
);
```

### Success Dialog (Pre-built)

```dart
DialogUtility.showSuccessDialog(
  context: context,
  title: 'Success',
  message: 'Your changes have been saved!',
  buttonText: 'OK',
);
```

### Error Dialog (Pre-built)

```dart
DialogUtility.showErrorDialog(
  context: context,
  title: 'Error',
  message: 'Something went wrong. Please try again.',
  buttonText: 'OK',
);
```

### Warning Dialog (Pre-built)

```dart
DialogUtility.showWarningDialog(
  context: context,
  title: 'Warning',
  message: 'This action cannot be undone.',
  primaryButtonText: 'Continue',
  secondaryButtonText: 'Cancel',
  onPrimaryPressed: () {
    // Handle continue
    Navigator.of(context).pop();
  },
);
```

### Confirmation Dialog (Returns boolean)

```dart
final confirmed = await DialogUtility.showConfirmationDialog(
  context: context,
  title: 'Delete Item',
  message: 'Are you sure you want to delete this item?',
  confirmText: 'Delete',
  cancelText: 'Cancel',
  isDestructive: true, // Makes confirm button red
);

if (confirmed) {
  // User confirmed
  print('User confirmed deletion');
} else {
  // User cancelled
  print('User cancelled');
}
```

### Loading Dialog

```dart
// Show loading
DialogUtility.showLoadingDialog(
  context: context,
  message: 'Loading...',
);

// Hide loading (after async operation)
Navigator.of(context).pop();
```

### Custom Dialog

```dart
DialogUtility.showCustomDialog(
  context: context,
  title: 'Custom Dialog',
  message: 'This is a fully customizable dialog',
  image: Image.network('https://example.com/image.jpg'),
  customContent: Column(
    children: [
      TextField(
        decoration: InputDecoration(labelText: 'Enter text'),
      ),
      // Add more custom widgets
    ],
  ),
  buttons: [
    TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text('Cancel'),
    ),
    ElevatedButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text('Submit'),
    ),
  ],
  borderRadius: 20.0,
  width: 400,
);
```

### Dialog with Custom Colors

```dart
DialogUtility.showSingleButtonDialog(
  context: context,
  title: 'Custom Styled',
  message: 'This dialog has custom colors',
  backgroundColor: Colors.blue.shade50,
  titleColor: Colors.blue.shade900,
  messageColor: Colors.blue.shade700,
  buttonColor: Colors.blue,
  buttonTextColor: Colors.white,
  borderRadius: 24.0,
);
```

## API Reference

### showSingleButtonDialog

Shows a dialog with a single button.

| Parameter | Type | Description |
|-----------|------|-------------|
| `context` | `BuildContext` | **Required.** Build context |
| `title` | `String?` | Dialog title |
| `message` | `String?` | Dialog message |
| `buttonText` | `String` | Button text (default: 'OK') |
| `onButtonPressed` | `VoidCallback?` | Button press handler |
| `image` | `Widget?` | Optional image widget |
| `backgroundColor` | `Color?` | Dialog background color |
| `titleColor` | `Color?` | Title text color |
| `messageColor` | `Color?` | Message text color |
| `buttonColor` | `Color?` | Button background color |
| `buttonTextColor` | `Color?` | Button text color |
| `borderRadius` | `double` | Border radius (default: 16.0) |
| `barrierDismissible` | `bool` | Can dismiss by tapping outside (default: true) |

### showDoubleButtonDialog

Shows a dialog with two buttons.

| Parameter | Type | Description |
|-----------|------|-------------|
| `context` | `BuildContext` | **Required.** Build context |
| `title` | `String?` | Dialog title |
| `message` | `String?` | Dialog message |
| `primaryButtonText` | `String` | Primary button text (default: 'OK') |
| `secondaryButtonText` | `String` | Secondary button text (default: 'Cancel') |
| `onPrimaryPressed` | `VoidCallback?` | Primary button handler |
| `onSecondaryPressed` | `VoidCallback?` | Secondary button handler |
| `image` | `Widget?` | Optional image widget |
| `isDestructive` | `bool` | Make primary button red (default: false) |
| `borderRadius` | `double` | Border radius (default: 16.0) |
| `barrierDismissible` | `bool` | Can dismiss by tapping outside (default: true) |

### showConfirmationDialog

Shows a confirmation dialog and returns a boolean.

| Parameter | Type | Description |
|-----------|------|-------------|
| `context` | `BuildContext` | **Required.** Build context |
| `title` | `String?` | Dialog title |
| `message` | `String` | Dialog message (default: 'Are you sure?') |
| `confirmText` | `String` | Confirm button text (default: 'Confirm') |
| `cancelText` | `String` | Cancel button text (default: 'Cancel') |
| `image` | `Widget?` | Optional image widget |
| `isDestructive` | `bool` | Make confirm button red (default: false) |
| `borderRadius` | `double` | Border radius (default: 16.0) |

**Returns:** `Future<bool>` - `true` if confirmed, `false` if cancelled

### showLoadingDialog

Shows a loading dialog with spinner.

| Parameter | Type | Description |
|-----------|------|-------------|
| `context` | `BuildContext` | **Required.** Build context |
| `message` | `String` | Loading message (default: 'Please wait...') |
| `barrierDismissible` | `bool` | Can dismiss by tapping outside (default: false) |

## Best Practices

1. **Use pre-built dialogs** for common cases (success, error, warning)
2. **Use confirmation dialogs** for destructive actions
3. **Set `barrierDismissible: false`** for loading dialogs
4. **Use `isDestructive: true`** for dangerous actions
5. **Customize colors** to match your app theme
6. **Always handle button callbacks** to close the dialog

## Examples in the App

The dialog utility can be used throughout the app for:
- Success/error messages
- Confirmation dialogs
- Loading indicators
- Custom forms and inputs
- Image previews
- And more!

