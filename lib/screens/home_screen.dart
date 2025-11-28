import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/cacheable_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: const Text('Go to Profile'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/products');
                  },
                  child: const Text('Go to Products'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: const Text('Go to Settings'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

