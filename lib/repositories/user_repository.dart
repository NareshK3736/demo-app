import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService _apiService = ApiService.getInstance();

  // Get user by ID
  Future<ApiResponse<UserModel>> getUser(int userId) async {
    try {
      final response = await _apiService.get('/users/$userId');

      if (response.statusCode == 200) {
        final userData = response.data['data'] as Map<String, dynamic>;
        final user = UserModel.fromJson(userData);
        return ApiResponse.success(user, statusCode: response.statusCode);
      } else {
        return ApiResponse.error(
          'Failed to fetch user',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse.error(
          'Failed to fetch user',
          statusCode: e.response?.statusCode,
        );
      } else {
        return ApiResponse.error('Network error: ${e.message}');
      }
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  // Get list of users
  Future<ApiResponse<List<UserModel>>> getUsers({int page = 1}) async {
    try {
      final response = await _apiService.get(
        '/users',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        final users = data.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
        return ApiResponse.success(users, statusCode: response.statusCode);
      } else {
        return ApiResponse.error(
          'Failed to fetch users',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse.error(
          'Failed to fetch users',
          statusCode: e.response?.statusCode,
        );
      } else {
        return ApiResponse.error('Network error: ${e.message}');
      }
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }
}

