import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/deep_link_service.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize deep link service
  final deepLinkService = DeepLinkService();
  deepLinkService.initialize();
  
  runApp(MyApp(deepLinkService: deepLinkService));
}

class MyApp extends StatefulWidget {
  final DeepLinkService deepLinkService;

  const MyApp({super.key, required this.deepLinkService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    
    // Set up deep link handler
    widget.deepLinkService.onRouteChanged = (String route, Map<String, String>? params) {
      _handleDeepLink(route, params);
    };
  }

  void _handleDeepLink(String route, Map<String, String>? params) {
    // Navigate based on the route
    switch (route) {
      case '/':
      case '/home':
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/',
          (route) => false,
        );
        break;
      case '/profile':
        navigatorKey.currentState?.pushNamed(
          '/profile',
          arguments: params?['userId'],
        );
        break;
      case '/products':
        navigatorKey.currentState?.pushNamed(
          '/products',
          arguments: {
            'categoryId': params?['categoryId'],
            'productId': params?['productId'],
          },
        );
        break;
      case '/settings':
        navigatorKey.currentState?.pushNamed('/settings');
        break;
      default:
        // Unknown route, navigate to home
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/',
          (route) => false,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Deep Link Demo App',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => const MainNavigationScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const MainNavigationScreen(initialIndex: 0),
          '/products': (context) => const MainNavigationScreen(
                initialIndex: 1,
              ),
          '/profile': (context) => const MainNavigationScreen(
                initialIndex: 2,
              ),
          '/settings': (context) => const MainNavigationScreen(initialIndex: 3),
        },
        initialRoute: '/',
      ),
    );
  }

  @override
  void dispose() {
    widget.deepLinkService.dispose();
    super.dispose();
  }
}
