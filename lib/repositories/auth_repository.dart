import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService.getInstance();

  // Login
  Future<ApiResponse<LoginResponse>> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token'] as String;
        
        // For demo API, we need to fetch user separately
        // In real app, user data might come with login response
        final userResponse = await _apiService.get('/users/2');
        final userData = userResponse.data['data'] as Map<String, dynamic>;
        final user = UserModel.fromJson(userData);

        final loginResponse = LoginResponse(token: token, user: user);

        // Save to local storage
        final storage = await LocalStorageService.getInstance();
        await storage.saveToken(token);
        await storage.saveUser(user);

        return ApiResponse.success(loginResponse, statusCode: response.statusCode);
      } else {
        return ApiResponse.error(
          'Login failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data['error'] as String? ?? 'Login failed';
        return ApiResponse.error(
          errorMessage,
          statusCode: e.response?.statusCode,
        );
      } else {
        return ApiResponse.error('Network error: ${e.message}');
      }
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  // Register
  Future<ApiResponse<LoginResponse>> register(
    String email,
    String password,
  ) async {
    try {
      final response = await _apiService.post(
        '/register',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['token'] as String;
        
        // For demo API, create a mock user
        final user = UserModel(
          id: response.data['id'] as int? ?? 0,
          email: email,
          firstName: email.split('@')[0],
          lastName: '',
        );

        final loginResponse = LoginResponse(token: token, user: user);

        // Save to local storage
        final storage = await LocalStorageService.getInstance();
        await storage.saveToken(token);
        await storage.saveUser(user);

        return ApiResponse.success(loginResponse, statusCode: response.statusCode);
      } else {
        return ApiResponse.error(
          'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data['error'] as String? ?? 'Registration failed';
        return ApiResponse.error(
          errorMessage,
          statusCode: e.response?.statusCode,
        );
      } else {
        return ApiResponse.error('Network error: ${e.message}');
      }
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    final storage = await LocalStorageService.getInstance();
    await storage.clearAuthData();
  }

  // Get current user from storage
  Future<UserModel?> getCurrentUser() async {
    final storage = await LocalStorageService.getInstance();
    return storage.getUser();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final storage = await LocalStorageService.getInstance();
    return storage.isLoggedIn();
  }
}

