/// Base class for navigation data models
abstract class NavigationData {
  const NavigationData();
}

/// Model for passing user data between screens
class UserNavigationData extends NavigationData {
  final String userId;
  final String? userName;
  final String? userEmail;
  final Map<String, dynamic>? extraData;

  const UserNavigationData({
    required this.userId,
    this.userName,
    this.userEmail,
    this.extraData,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'extraData': extraData,
    };
  }

  factory UserNavigationData.fromJson(Map<String, dynamic> json) {
    return UserNavigationData(
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      userEmail: json['userEmail'] as String?,
      extraData: json['extraData'] as Map<String, dynamic>?,
    );
  }
}

/// Model for passing product data between screens
class ProductNavigationData extends NavigationData {
  final String productId;
  final String? productName;
  final String? categoryId;
  final double? price;
  final Map<String, dynamic>? extraData;

  const ProductNavigationData({
    required this.productId,
    this.productName,
    this.categoryId,
    this.price,
    this.extraData,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'categoryId': categoryId,
      'price': price,
      'extraData': extraData,
    };
  }

  factory ProductNavigationData.fromJson(Map<String, dynamic> json) {
    return ProductNavigationData(
      productId: json['productId'] as String,
      productName: json['productName'] as String?,
      categoryId: json['categoryId'] as String?,
      price: json['price'] as double?,
      extraData: json['extraData'] as Map<String, dynamic>?,
    );
  }
}

/// Model for passing settings data between screens
class SettingsNavigationData extends NavigationData {
  final String? theme;
  final String? language;
  final Map<String, dynamic>? preferences;
  final Map<String, dynamic>? extraData;

  const SettingsNavigationData({
    this.theme,
    this.language,
    this.preferences,
    this.extraData,
  });

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'language': language,
      'preferences': preferences,
      'extraData': extraData,
    };
  }

  factory SettingsNavigationData.fromJson(Map<String, dynamic> json) {
    return SettingsNavigationData(
      theme: json['theme'] as String?,
      language: json['language'] as String?,
      preferences: json['preferences'] as Map<String, dynamic>?,
      extraData: json['extraData'] as Map<String, dynamic>?,
    );
  }
}

/// Generic result model for returning data from screens
class NavigationResult<T> {
  final bool success;
  final T? data;
  final String? message;
  final Map<String, dynamic>? extraData;

  const NavigationResult({
    required this.success,
    this.data,
    this.message,
    this.extraData,
  });

  factory NavigationResult.success(T data, {String? message, Map<String, dynamic>? extraData}) {
    return NavigationResult(
      success: true,
      data: data,
      message: message,
      extraData: extraData,
    );
  }

  factory NavigationResult.failure({String? message, Map<String, dynamic>? extraData}) {
    return NavigationResult(
      success: false,
      message: message,
      extraData: extraData,
    );
  }

  factory NavigationResult.cancelled() {
    return const NavigationResult(success: false, message: 'Cancelled');
  }
}

