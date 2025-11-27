import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  
  // Callback for handling navigation
  Function(String route, Map<String, String>? params)? onRouteChanged;

  // App store URLs - Replace with your actual app store URLs
  static const String androidPackageName = 'com.dempapp.demoapp';
  static const String iosAppId = 'YOUR_IOS_APP_ID'; // Replace with your actual iOS App ID
  
  static const String androidStoreUrl = 'https://play.google.com/store/apps/details?id=$androidPackageName';
  static const String iosStoreUrl = 'https://apps.apple.com/app/id$iosAppId';

  /// Initialize deep link listening
  void initialize() {
    // Listen to all incoming links
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleDeepLink(uri);
      },
      onError: (err) {
        debugPrint('Deep link error: $err');
      },
    );

    // Handle initial link (when app is opened from a link)
    _appLinks.getInitialLink().then((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });
  }

  /// Handle incoming deep link
  void _handleDeepLink(Uri uri) {
    debugPrint('Received deep link: $uri');
    
    // Extract route and parameters
    final String path = uri.path;
    final Map<String, String> params = uri.queryParameters;
    
    // Navigate based on the route
    if (onRouteChanged != null) {
      onRouteChanged!(path, params);
    }
  }

  /// Check if app can handle the URL and open app store if not
  Future<void> handleUniversalLink(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      
      // Try to launch the app with the URL
      // If app is installed, it will open; if not, it will fail
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // If launch failed, redirect to app store
        await _redirectToStore();
      }
    } catch (e) {
      debugPrint('Error handling universal link: $e');
      // On error, redirect to app store
      await _redirectToStore();
    }
  }

  /// Redirect to appropriate app store based on platform
  Future<void> _redirectToStore() async {
    final Uri storeUrl = Uri.parse(
      defaultTargetPlatform == TargetPlatform.android
          ? androidStoreUrl
          : iosStoreUrl,
    );

    try {
      await launchUrl(storeUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error opening app store: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
  }
}

