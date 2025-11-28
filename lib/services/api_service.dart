import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart' show TargetPlatform;
import 'package:package_info_plus/package_info_plus.dart';
import 'local_storage_service.dart';

class ApiService {
  static ApiService? _instance;
  late Dio _dio;
  final String baseUrl = 'https://reqres.in/api'; // Demo API
  
  // API Key Token - Change this to your actual API key
  static const String apiKeyToken = 'reqres-free-v1';

  ApiService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add token to headers if available
          final storage = await LocalStorageService.getInstance();
          final token = storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          // Add app version, platform, and API key token to all requests
          final packageInfo = await PackageInfo.fromPlatform();
          final appVersion = packageInfo.version;
          final buildNumber = packageInfo.buildNumber;
          final versionString = '$appVersion+$buildNumber';
          
          // Get platform name
          String platformName;
          if (kIsWeb) {
            platformName = 'web';
          } else {
            switch (defaultTargetPlatform) {
              case TargetPlatform.android:
                platformName = 'android';
                break;
              case TargetPlatform.iOS:
                platformName = 'ios';
                break;
              case TargetPlatform.windows:
                platformName = 'windows';
                break;
              case TargetPlatform.macOS:
                platformName = 'macos';
                break;
              case TargetPlatform.linux:
                platformName = 'linux';
                break;
              case TargetPlatform.fuchsia:
                platformName = 'fuchsia';
                break;
            }
          }
          
          // Add headers to all requests
          options.headers['X-App-Version'] = versionString;
          options.headers['X-Platform'] = platformName;
          options.headers['X-API-Key'] = apiKeyToken;
          
          // Add key token to data parameter for requests with body (POST, PUT, DELETE)
          if (options.data != null) {
            if (options.data is Map<String, dynamic>) {
              // Add key token to Map data
              (options.data as Map<String, dynamic>)['api_key'] = apiKeyToken;
            } else if (options.data is FormData) {
              // Add key token to FormData
              (options.data as FormData).fields.add(
                MapEntry('api_key', apiKeyToken),
              );
            }
          }
          
          // Add key token to query parameters for GET requests
          if (options.method == 'GET') {
            final queryParams = Map<String, dynamic>.from(options.queryParameters);
            queryParams['api_key'] = apiKeyToken;
            options.queryParameters = queryParams;
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          // Handle errors globally
          if (error.response?.statusCode == 401) {
            // Handle unauthorized - token expired
            // You can add logout logic here
          }
          return handler.next(error);
        },
      ),
    );
  }

  static ApiService getInstance() {
    _instance ??= ApiService._();
    return _instance!;
  }

  Dio get dio => _dio;

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }
}

