import 'package:flutter/material.dart';
import '../models/navigation_models.dart';

/// Service for handling navigation with data models and response handling
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Navigate to a screen with data model and get result back
  static Future<T?> navigateWithData<T extends NavigationData>({
    required BuildContext context,
    required Widget screen,
    T? data,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
        settings: RouteSettings(
          arguments: data,
        ),
      ),
    );

    if (result is T) {
      return result;
    }
    return null;
  }

  /// Navigate to a screen and get NavigationResult back
  static Future<NavigationResult<T>?> navigateForResult<T>({
    required BuildContext context,
    required Widget screen,
    NavigationData? data,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
        settings: RouteSettings(
          arguments: data,
        ),
      ),
    );

    if (result is NavigationResult<T>) {
      return result;
    }
    return null;
  }

  /// Navigate to a screen with data model (no result expected)
  static void navigateWithDataNoResult({
    required BuildContext context,
    required Widget screen,
    NavigationData? data,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
        settings: RouteSettings(
          arguments: data,
        ),
      ),
    );
  }

  /// Navigate and replace current screen
  static void navigateAndReplace({
    required BuildContext context,
    required Widget screen,
    NavigationData? data,
  }) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
        settings: RouteSettings(
          arguments: data,
        ),
      ),
    );
  }

  /// Navigate and remove all previous screens
  static void navigateAndRemoveUntil({
    required BuildContext context,
    required Widget screen,
    NavigationData? data,
    bool Function(Route<dynamic>)? predicate,
  }) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
        settings: RouteSettings(
          arguments: data,
        ),
      ),
      predicate ?? (route) => false,
    );
  }

  /// Navigate back with result
  static void navigateBack<T>({
    required BuildContext context,
    T? result,
  }) {
    Navigator.pop(context, result);
  }

  /// Navigate back with NavigationResult
  static void navigateBackWithResult<T>({
    required BuildContext context,
    required NavigationResult<T> result,
  }) {
    Navigator.pop(context, result);
  }

  /// Navigate back with success result
  static void navigateBackWithSuccess<T>({
    required BuildContext context,
    required T data,
    String? message,
  }) {
    Navigator.pop(
      context,
      NavigationResult.success(data, message: message),
    );
  }

  /// Navigate back with failure result
  static void navigateBackWithFailure({
    required BuildContext context,
    String? message,
  }) {
    Navigator.pop(
      context,
      NavigationResult.failure(message: message),
    );
  }

  /// Navigate back with cancellation
  static void navigateBackWithCancellation({
    required BuildContext context,
  }) {
    Navigator.pop(
      context,
      NavigationResult.cancelled(),
    );
  }

  /// Get navigation data from route settings
  static T? getNavigationData<T extends NavigationData>(BuildContext context) {
    final route = ModalRoute.of(context);
    final arguments = route?.settings.arguments;
    if (arguments is T) {
      return arguments;
    }
    return null;
  }

  /// Pop until specific route
  static void popUntil({
    required BuildContext context,
    required String routeName,
  }) {
    Navigator.popUntil(context, (route) => route.settings.name == routeName);
  }

  /// Pop multiple times
  static void popMultiple({
    required BuildContext context,
    required int count,
  }) {
    int popped = 0;
    Navigator.popUntil(context, (route) {
      if (popped < count) {
        popped++;
        return false;
      }
      return true;
    });
  }
}

