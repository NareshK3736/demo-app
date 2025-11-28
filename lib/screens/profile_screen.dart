import 'package:flutter/material.dart';
import '../models/navigation_models.dart';
import '../services/navigation_service.dart';
import '../utils/dialog_utility.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserNavigationData? _userData;
  String? _displayMessage;

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
      } else if (widget.userId != null) {
        // Fallback to userId if provided
        setState(() {
          _userData = UserNavigationData(userId: widget.userId!);
        });
      }
    });
  }

  Future<void> _navigateToEditProfile() async {
    // Pass user data to edit screen
    final result = await NavigationService.navigateForResult<UserNavigationData>(
      context: context,
      screen: const EditProfileScreen(),
      data: _userData,
    );

    // Handle result from edit screen
    if (result != null && mounted) {
      if (result.success && result.data != null) {
        setState(() {
          _userData = result.data;
          _displayMessage = result.message ?? 'Profile updated successfully';
        });

        // Show success dialog
        DialogUtility.showSuccessDialog(
          context: context,
          message: _displayMessage!,
        );
      } else if (!result.success) {
        if (result.message != 'Cancelled') {
          DialogUtility.showErrorDialog(
            context: context,
            message: result.message ?? 'Failed to update profile',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.person,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Profile Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (_userData != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User Information:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(label: 'User ID', value: _userData!.userId),
                      if (_userData!.userName != null)
                        _InfoRow(label: 'Name', value: _userData!.userName!),
                      if (_userData!.userEmail != null)
                        _InfoRow(label: 'Email', value: _userData!.userEmail!),
                      if (_userData!.extraData != null &&
                          _userData!.extraData!['phone'] != null)
                        _InfoRow(
                          label: 'Phone',
                          value: _userData!.extraData!['phone'],
                        ),
                    ],
                  ),
                ),
              ),
            ] else if (widget.userId != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('User ID: ${widget.userId}'),
                ),
              ),
            ],
            if (_displayMessage != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _displayMessage!,
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _navigateToEditProfile,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                NavigationService.navigateBack(context: context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

