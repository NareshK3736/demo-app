import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  
  List<UserModel> _users = [];
  UserModel? _selectedUser;
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get users => _users;
  UserModel? get selectedUser => _selectedUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUsers({int page = 1}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _userRepository.getUsers(page: page);
      
      if (response.success && response.data != null) {
        _users = response.data!;
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = response.message ?? 'Failed to fetch users';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUser(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _userRepository.getUser(userId);
      
      if (response.success && response.data != null) {
        _selectedUser = response.data!;
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = response.message ?? 'Failed to fetch user';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSelectedUser() {
    _selectedUser = null;
    notifyListeners();
  }
}

