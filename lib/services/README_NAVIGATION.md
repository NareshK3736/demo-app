# Navigation Service

A comprehensive navigation service for handling navigation between screens with data models, getting responses back, and updating previous screens.

## Features

- ✅ Pass data models between screens
- ✅ Get responses back from navigated screens
- ✅ Update previous screens with returned data
- ✅ Type-safe navigation with generics
- ✅ NavigationResult for structured responses
- ✅ Multiple navigation patterns (push, replace, removeUntil)
- ✅ Easy data extraction from route arguments

## Navigation Models

### UserNavigationData
For passing user information between screens.

```dart
UserNavigationData(
  userId: 'user_123',
  userName: 'John Doe',
  userEmail: 'john@example.com',
  extraData: {'phone': '123-456-7890'},
)
```

### ProductNavigationData
For passing product information between screens.

```dart
ProductNavigationData(
  productId: 'prod_001',
  productName: 'Sample Product',
  categoryId: 'cat_001',
  price: 99.99,
)
```

### SettingsNavigationData
For passing settings information between screens.

```dart
SettingsNavigationData(
  theme: 'Dark',
  language: 'English',
  preferences: {'notifications': true},
)
```

### NavigationResult<T>
Generic result model for returning data from screens.

```dart
NavigationResult.success(data, message: 'Success message')
NavigationResult.failure(message: 'Error message')
NavigationResult.cancelled()
```

## Usage Examples

### 1. Navigate with Data and Get Result

```dart
// Navigate to a screen with data
final userData = UserNavigationData(
  userId: 'user_123',
  userName: 'John Doe',
);

final result = await NavigationService.navigateForResult<UserNavigationData>(
  context: context,
  screen: const ProfileScreen(),
  data: userData,
);

// Handle result
if (result != null && result.success) {
  print('Updated user: ${result.data!.userName}');
}
```

### 2. Navigate and Get Response Back

```dart
// Navigate to edit screen
final result = await NavigationService.navigateForResult<UserNavigationData>(
  context: context,
  screen: const EditProfileScreen(),
  data: existingUserData,
);

// Update previous screen with result
if (result != null && result.success && result.data != null) {
  setState(() {
    _userData = result.data;
  });
  
  // Show success message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(result.message ?? 'Updated successfully')),
  );
}
```

### 3. Return Data from Screen

```dart
// In the navigated screen (e.g., EditProfileScreen)
void _saveProfile() {
  final updatedData = UserNavigationData(
    userId: 'user_123',
    userName: _nameController.text,
    userEmail: _emailController.text,
  );

  // Return success result
  NavigationService.navigateBackWithSuccess(
    context: context,
    data: updatedData,
    message: 'Profile updated successfully',
  );
}

// Or return failure
void _cancel() {
  NavigationService.navigateBackWithFailure(
    context: context,
    message: 'Operation cancelled',
  );
}
```

### 4. Get Navigation Data in Screen

```dart
class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  UserNavigationData? _userData;

  @override
  void initState() {
    super.initState();
    // Get data from route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = NavigationService.getNavigationData<UserNavigationData>(context);
      if (data != null) {
        setState(() {
          _userData = data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use _userData
    return Scaffold(/* ... */);
  }
}
```

### 5. Navigate Without Result

```dart
// Simple navigation with data (no result expected)
NavigationService.navigateWithDataNoResult(
  context: context,
  screen: const ProfileScreen(),
  data: userData,
);
```

### 6. Navigate and Replace

```dart
// Replace current screen
NavigationService.navigateAndReplace(
  context: context,
  screen: const HomeScreen(),
  data: userData,
);
```

### 7. Navigate and Remove All Previous

```dart
// Navigate and remove all previous screens
NavigationService.navigateAndRemoveUntil(
  context: context,
  screen: const HomeScreen(),
  data: userData,
);
```

### 8. Navigate Back with Result

```dart
// Return data when going back
NavigationService.navigateBack(
  context: context,
  result: myData,
);

// Or with NavigationResult
NavigationService.navigateBackWithResult(
  context: context,
  result: NavigationResult.success(myData),
);
```

## Complete Example: Edit Profile Flow

### Home Screen (Navigating)
```dart
ElevatedButton(
  onPressed: () async {
    final userData = UserNavigationData(
      userId: 'user_123',
      userName: 'John Doe',
      userEmail: 'john@example.com',
    );

    final result = await NavigationService.navigateForResult<UserNavigationData>(
      context: context,
      screen: const EditProfileScreen(),
      data: userData,
    );

    if (result != null && mounted) {
      if (result.success && result.data != null) {
        setState(() {
          _userData = result.data;
        });
        DialogUtility.showSuccessDialog(
          context: context,
          message: result.message ?? 'Profile updated',
        );
      }
    }
  },
  child: Text('Edit Profile'),
)
```

### Edit Profile Screen (Returning Data)
```dart
void _saveProfile() {
  if (_formKey.currentState!.validate()) {
    final updatedData = UserNavigationData(
      userId: _receivedData?.userId ?? 'unknown',
      userName: _nameController.text,
      userEmail: _emailController.text,
    );

    NavigationService.navigateBackWithSuccess(
      context: context,
      data: updatedData,
      message: 'Profile updated successfully',
    );
  }
}
```

## Navigation Patterns

### Pattern 1: Pass Data → Edit → Return Updated Data
1. Navigate with initial data
2. Edit data in new screen
3. Return updated data
4. Update previous screen with returned data

### Pattern 2: Pass Data → Select → Return Selection
1. Navigate with list data
2. User selects an item
3. Return selected item
4. Update previous screen with selection

### Pattern 3: Pass Data → Configure → Return Settings
1. Navigate with current settings
2. User modifies settings
3. Return updated settings
4. Apply settings in previous screen

## Best Practices

1. **Always check if result is not null** before using it
2. **Check `mounted` before updating state** after async operations
3. **Use NavigationResult** for structured responses
4. **Handle cancellation** (when user presses back)
5. **Use type-safe generics** for better code safety
6. **Extract data in initState** using `addPostFrameCallback`
7. **Show feedback** to users when data is updated

## API Reference

### NavigationService Methods

| Method | Description |
|--------|-------------|
| `navigateForResult<T>()` | Navigate and get NavigationResult back |
| `navigateWithDataNoResult()` | Navigate with data (no result) |
| `navigateAndReplace()` | Replace current screen |
| `navigateAndRemoveUntil()` | Remove all previous screens |
| `navigateBack()` | Go back with optional result |
| `navigateBackWithSuccess()` | Go back with success result |
| `navigateBackWithFailure()` | Go back with failure result |
| `navigateBackWithCancellation()` | Go back with cancellation |
| `getNavigationData<T>()` | Extract data from route arguments |

## Examples in the App

- **Profile Screen**: Receives UserNavigationData, navigates to EditProfileScreen, gets updated data back
- **Products Screen**: Receives ProductNavigationData, returns selected product
- **Settings Screen**: Receives SettingsNavigationData, returns updated settings
- **Home Screen**: Demonstrates all navigation patterns with examples

