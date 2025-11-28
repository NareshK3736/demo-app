import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/cacheable_image.dart';
import '../utils/dialog_utility.dart';
import '../models/navigation_models.dart';
import '../services/navigation_service.dart';
import 'profile_screen.dart';
import 'products_screen.dart';
import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import 'image_gallery_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.blue,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isAuthenticated) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                  },
                  tooltip: 'Logout',
                );
              }
              return IconButton(
                icon: const Icon(Icons.login),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                tooltip: 'Login',
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (!authProvider.isAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.home,
                    size: 100,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to Home Screen',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'User Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (authProvider.user != null) ...[
                          Text('Name: ${authProvider.user!.fullName}'),
                          const SizedBox(height: 8),
                          Text('Email: ${authProvider.user!.email}'),
                          if (authProvider.user!.avatar != null) ...[
                            const SizedBox(height: 8),
                            CacheableImage(
                              imageUrl: authProvider.user!.avatar!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              shape: BoxShape.circle,
                              errorWidget: const Icon(Icons.person, size: 100),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: userProvider.isLoading
                              ? null
                              : () {
                                  userProvider.fetchUsers();
                                },
                          child: const Text('Fetch Users from API'),
                        ),
                        const SizedBox(height: 16),
                        if (userProvider.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (userProvider.errorMessage != null)
                          Card(
                            color: Colors.red.shade50,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                userProvider.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          )
                        else if (userProvider.users.isNotEmpty) ...[
                          const Text(
                            'Users List:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...userProvider.users.map((user) => Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CacheableAvatar(
                                    imageUrl: user.avatar,
                                    radius: 25,
                                    name: user.fullName,
                                  ),
                                  title: Text(user.fullName),
                                  subtitle: Text(user.email),
                                ),
                              )),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Navigation Examples:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Navigate with data model and get result back
                    final userData = UserNavigationData(
                      userId: 'user_123',
                      userName: 'John Doe',
                      userEmail: 'john@example.com',
                    );

                    final result = await NavigationService.navigateForResult<UserNavigationData>(
                      context: context,
                      screen: const ProfileScreen(),
                      data: userData,
                    );

                    if (result != null && mounted) {
                      if (result.success && result.data != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result.message ?? 'Profile updated: ${result.data!.userName}',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('Profile (with Data & Result)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Navigate to edit profile and get updated data back
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
                        DialogUtility.showSuccessDialog(
                          context: context,
                          message: 'Profile updated: ${result.data!.userName}',
                        );
                      } else if (!result.success && result.message != 'Cancelled') {
                        DialogUtility.showErrorDialog(
                          context: context,
                          message: result.message ?? 'Failed to update profile',
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile (Get Result)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Navigate with product data
                    final productData = ProductNavigationData(
                      productId: 'prod_001',
                      productName: 'Sample Product',
                      categoryId: 'cat_001',
                      price: 99.99,
                    );

                    final result = await NavigationService.navigateForResult<ProductNavigationData>(
                      context: context,
                      screen: const ProductsScreen(),
                      data: productData,
                    );

                    if (result != null && mounted) {
                      if (result.success && result.data != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Selected: ${result.data!.productName} - \$${result.data!.price}',
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('Products (with Data)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Navigate with settings data and get result
                    final settingsData = SettingsNavigationData(
                      theme: 'Dark',
                      language: 'English',
                    );

                    final result = await NavigationService.navigateForResult<SettingsNavigationData>(
                      context: context,
                      screen: const SettingsScreen(),
                      data: settingsData,
                    );

                    if (result != null && mounted) {
                      if (result.success && result.data != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Settings saved: ${result.data!.theme} theme, ${result.data!.language} language',
                            ),
                            backgroundColor: Colors.purple,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings (with Data & Result)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Simple navigation without data
                    NavigationService.navigateWithDataNoResult(
                      context: context,
                      screen: const ProfileScreen(),
                    );
                  },
                  child: const Text('Simple Navigation (No Data)'),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Image Gallery:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImageGalleryScreen(
                          title: 'Image Gallery',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Open Image Gallery'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Dialog Examples:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        DialogUtility.showSuccessDialog(
                          context: context,
                          message: 'Operation completed successfully!',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Success Dialog'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        DialogUtility.showErrorDialog(
                          context: context,
                          message: 'Something went wrong!',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Error Dialog'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final confirmed = await DialogUtility.showConfirmationDialog(
                          context: context,
                          title: 'Delete Item',
                          message: 'Are you sure you want to delete this item?',
                          confirmText: 'Delete',
                          cancelText: 'Cancel',
                          isDestructive: true,
                        );
                        if (confirmed && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Item deleted')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Confirm Dialog'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        DialogUtility.showSingleButtonDialog(
                          context: context,
                          title: 'Custom Dialog',
                          message: 'This is a custom dialog with rounded corners!',
                          image: const Icon(
                            Icons.info,
                            color: Colors.blue,
                            size: 64,
                          ),
                          borderRadius: 20.0,
                        );
                      },
                      child: const Text('Custom Dialog'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        DialogUtility.showLoadingDialog(
                          context: context,
                          message: 'Loading data...',
                        );
                        // Simulate async operation
                        Future.delayed(const Duration(seconds: 2), () {
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            DialogUtility.showSuccessDialog(
                              context: context,
                              message: 'Data loaded successfully!',
                            );
                          }
                        });
                      },
                      child: const Text('Loading Dialog'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

