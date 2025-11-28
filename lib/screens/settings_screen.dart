import 'package:flutter/material.dart';
import '../models/navigation_models.dart';
import '../services/navigation_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsNavigationData? _settingsData;
  String _selectedTheme = 'Light';
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    // Get data from route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = NavigationService.getNavigationData<SettingsNavigationData>(context);
      if (data != null) {
        setState(() {
          _settingsData = data;
          _selectedTheme = data.theme ?? 'Light';
          _selectedLanguage = data.language ?? 'English';
        });
      }
    });
  }

  void _saveSettings() {
    final updatedSettings = SettingsNavigationData(
      theme: _selectedTheme,
      language: _selectedLanguage,
      preferences: {
        'notifications': true,
        'autoSave': true,
      },
    );

    NavigationService.navigateBackWithSuccess(
      context: context,
      data: updatedSettings,
      message: 'Settings saved successfully',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screen'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
            tooltip: 'Save Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.settings,
              size: 100,
              color: Colors.purple,
            ),
            const SizedBox(height: 20),
            const Text(
              'Settings Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (_settingsData != null) ...[
              Card(
                color: Colors.purple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Received Settings:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_settingsData!.theme != null)
                        Text('Theme: ${_settingsData!.theme}'),
                      if (_settingsData!.language != null)
                        Text('Language: ${_settingsData!.language}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Theme',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...['Light', 'Dark', 'System'].map((theme) {
                      return RadioListTile<String>(
                        title: Text(theme),
                        value: theme,
                        groupValue: _selectedTheme,
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value!;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...['English', 'Spanish', 'French'].map((language) {
                      return RadioListTile<String>(
                        title: Text(language),
                        value: language,
                        groupValue: _selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value!;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.purple,
              ),
              child: const Text('Save Settings'),
            ),
            const SizedBox(height: 12),
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

