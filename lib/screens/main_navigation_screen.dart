import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'products_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        
        final navigator = Navigator.of(context);
        final route = ModalRoute.of(context);
        final isRootRoute = route?.settings.name == '/' || route?.isFirst == true;
        
        // First priority: If there are child routes (like EditProfileScreen), pop them
        if (navigator.canPop()) {
          // Check if we're at root - if yes, the pop is for a child screen
          // If no, the pop might be for MainNavigationScreen itself
          if (isRootRoute) {
            // We're at root, so canPop means there's a child screen - pop it
            navigator.pop();
            return;
          } else {
            // We're not at root, so canPop might mean MainNavigationScreen can be popped
            // But first check if there's a child screen by trying to pop
            // If it's a child screen, it will pop. If it's MainNavigationScreen, we handle below
            navigator.pop();
            return;
          }
        }
        
        // Second priority: If we're at root and not on home tab, switch to home tab
        if (isRootRoute && _currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return;
        }
        
        // Third priority: If we're not at root (MainNavigationScreen was pushed), pop it
        if (!isRootRoute) {
          navigator.pop();
          return;
        }
        
        // Last resort: On home tab at root - allow pop (might exit app)
        navigator.pop();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            HomeScreen(),
            ProductsScreen(),
            ProfileScreen(),
            SettingsScreen(),
          ],
        ),
      bottomNavigationBar: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Hide bottom nav if not authenticated
          if (!authProvider.isAuthenticated) {
            return const SizedBox.shrink();
          }

          // Using BottomNavigationBar for better visibility and customization
          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          );
        },
      ),
      ),
    );
  }
}

