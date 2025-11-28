import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class LocalStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  static LocalStorageService? _instance;
  SharedPreferences? _prefs;

  LocalStorageService._();

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService._();
    _instance!._prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Token methods
  Future<void> saveToken(String token) async {
    await _prefs?.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs?.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs?.remove(_tokenKey);
  }

  // User methods
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs?.setString(_userKey, userJson);
  }

  UserModel? getUser() {
    final userJson = _prefs?.getString(_userKey);
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  Future<void> removeUser() async {
    await _prefs?.remove(_userKey);
  }

  // Clear all auth data
  Future<void> clearAuthData() async {
    await removeToken();
    await removeUser();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return getToken() != null && getUser() != null;
  }
}

