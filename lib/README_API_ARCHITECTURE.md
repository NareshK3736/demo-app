# API Architecture Documentation

This document describes the API architecture implementation using Dio, Provider, and Repository pattern.

## Architecture Overview

The app follows a clean architecture pattern with the following layers:

1. **Models** - Data models for API responses and entities
2. **Services** - Singleton services for API calls and local storage
3. **Repositories** - Business logic layer that handles API calls
4. **Providers** - State management using Provider pattern
5. **Screens** - UI layer that consumes providers

## File Structure

```
lib/
├── models/
│   ├── user_model.dart          # User data model
│   └── api_response.dart         # Generic API response wrapper
├── services/
│   ├── api_service.dart         # Singleton Dio API service
│   └── local_storage_service.dart # Local storage for token & user
├── repositories/
│   ├── auth_repository.dart      # Authentication repository
│   └── user_repository.dart      # User data repository
├── providers/
│   ├── auth_provider.dart        # Authentication state provider
│   └── user_provider.dart        # User data state provider
└── screens/
    ├── login_screen.dart         # Login/Register screen
    └── home_screen.dart          # Home screen with API demo
```

## Components

### 1. API Service (Singleton)

**Location:** `lib/services/api_service.dart`

- Singleton pattern ensures only one instance exists
- Uses Dio for HTTP requests
- Automatically adds authentication token to headers
- Base URL: `https://reqres.in/api` (demo API)
- Includes interceptors for request/response handling

**Usage:**
```dart
final apiService = ApiService.getInstance();
final response = await apiService.get('/users');
```

### 2. Local Storage Service

**Location:** `lib/services/local_storage_service.dart`

- Manages token and user data persistence
- Uses SharedPreferences for storage
- Singleton pattern with async initialization

**Methods:**
- `saveToken(String token)` - Save authentication token
- `getToken()` - Retrieve token
- `saveUser(UserModel user)` - Save user data
- `getUser()` - Retrieve user data
- `clearAuthData()` - Clear all auth data
- `isLoggedIn()` - Check if user is authenticated

### 3. Repository Pattern

**Location:** `lib/repositories/`

Repositories handle all API communication and business logic:

- **AuthRepository**: Login, register, logout operations
- **UserRepository**: Fetch user data operations

Each repository method returns `ApiResponse<T>` for consistent error handling.

### 4. Provider State Management

**Location:** `lib/providers/`

Providers manage application state and notify listeners of changes:

- **AuthProvider**: Manages authentication state, user session
- **UserProvider**: Manages user list and selected user state

**Usage in Widgets:**
```dart
// Using Consumer
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    return Text(authProvider.user?.email ?? 'Not logged in');
  },
)

// Using Provider.of
final authProvider = Provider.of<AuthProvider>(context, listen: false);
await authProvider.login(email, password);
```

## Demo API

The app uses **ReqRes API** (https://reqres.in) as a demo API:

- **Login:** `POST /api/login`
- **Register:** `POST /api/register`
- **Get Users:** `GET /api/users`
- **Get User:** `GET /api/users/{id}`

### Test Credentials

For login testing, you can use:
- Email: `eve.holt@reqres.in`
- Password: `cityslicka`

Or any email/password combination (the demo API accepts any valid email format).

## Data Flow

1. **User Action** → Screen calls Provider method
2. **Provider** → Calls Repository method
3. **Repository** → Uses ApiService to make HTTP request
4. **ApiService** → Adds auth token from LocalStorage
5. **Response** → Repository processes and returns ApiResponse
6. **Provider** → Updates state and notifies listeners
7. **Screen** → Rebuilds with new data

## Token Management

- Token is automatically added to all API requests via Dio interceptor
- Token is stored in SharedPreferences when user logs in
- Token is removed when user logs out
- On 401 errors, you can add logout logic in the interceptor

## Example Usage

### Login Flow

```dart
// In a widget
final authProvider = Provider.of<AuthProvider>(context, listen: false);
bool success = await authProvider.login('email@example.com', 'password');

if (success) {
  // Navigate to home
} else {
  // Show error: authProvider.errorMessage
}
```

### Fetching Users

```dart
// In a widget
final userProvider = Provider.of<UserProvider>(context, listen: false);
await userProvider.fetchUsers();

// Access users
final users = userProvider.users;
```

### Accessing Current User

```dart
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isAuthenticated) {
      return Text('Welcome ${authProvider.user!.fullName}');
    }
    return Text('Please login');
  },
)
```

## Error Handling

All API calls return `ApiResponse<T>` which includes:
- `success`: Boolean indicating success/failure
- `data`: Response data (if successful)
- `message`: Error message (if failed)
- `statusCode`: HTTP status code

## Future Enhancements

- Add refresh token mechanism
- Implement request retry logic
- Add request/response logging
- Implement offline caching
- Add API response caching

