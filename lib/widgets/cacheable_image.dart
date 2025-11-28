import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A reusable widget for displaying cached images from URLs
/// with placeholder, error handling, and loading states
class CacheableImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration? fadeInDuration;
  final Duration? fadeOutDuration;
  final Color? color;
  final BlendMode? colorBlendMode;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final Map<String, String>? httpHeaders;

  const CacheableImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration,
    this.fadeOutDuration,
    this.color,
    this.colorBlendMode,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.httpHeaders,
  });

  /// Creates a circular cacheable image (useful for avatars)
  factory CacheableImage.circle({
    Key? key,
    required String imageUrl,
    required double radius,
    Widget? placeholder,
    Widget? errorWidget,
    Map<String, String>? httpHeaders,
  }) {
    return CacheableImage(
      key: key,
      imageUrl: imageUrl,
      width: radius * 2,
      height: radius * 2,
      shape: BoxShape.circle,
      fit: BoxFit.cover,
      placeholder: placeholder,
      errorWidget: errorWidget,
      httpHeaders: httpHeaders,
    );
  }

  /// Creates a rounded rectangle cacheable image
  factory CacheableImage.rounded({
    Key? key,
    required String imageUrl,
    double? width,
    double? height,
    double borderRadius = 8.0,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    Map<String, String>? httpHeaders,
  }) {
    return CacheableImage(
      key: key,
      imageUrl: imageUrl,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(borderRadius),
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
      httpHeaders: httpHeaders,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: httpHeaders,
      placeholder: (context, url) => placeholder ?? _defaultPlaceholder(),
      errorWidget: (context, url, error) => errorWidget ?? _defaultErrorWidget(),
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 100),
      color: color,
      colorBlendMode: colorBlendMode,
    );

    // Apply border radius if provided
    if (borderRadius != null && shape == BoxShape.rectangle) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    } else if (shape == BoxShape.circle) {
      imageWidget = ClipOval(child: imageWidget);
    }

    return imageWidget;
  }

  Widget _defaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _defaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(
        Icons.broken_image,
        size: (width != null && height != null)
            ? (width! < height! ? width! * 0.5 : height! * 0.5)
            : 48,
        color: Colors.grey[400],
      ),
    );
  }
}

/// A specialized widget for avatar images with caching
class CacheableAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final String? name;
  final Color? backgroundColor;
  final Color? textColor;
  final Map<String, String>? httpHeaders;

  const CacheableAvatar({
    super.key,
    this.imageUrl,
    required this.radius,
    this.name,
    this.backgroundColor,
    this.textColor,
    this.httpHeaders,
  });

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CacheableImage.circle(
        imageUrl: imageUrl!,
        radius: radius,
        httpHeaders: httpHeaders,
        placeholder: Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? Colors.grey[300],
          ),
          child: Center(
            child: name != null
                ? Text(
                    _getInitials(name),
                    style: TextStyle(
                      color: textColor ?? Colors.grey[700],
                      fontSize: radius * 0.6,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? Colors.grey[300],
          ),
          child: Center(
            child: name != null
                ? Text(
                    _getInitials(name),
                    style: TextStyle(
                      color: textColor ?? Colors.grey[700],
                      fontSize: radius * 0.6,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: radius,
                    color: textColor ?? Colors.grey[600],
                  ),
          ),
        ),
      );
    }

    // Fallback when no image URL
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Colors.grey[300],
      ),
      child: Center(
        child: name != null
            ? Text(
                _getInitials(name),
                style: TextStyle(
                  color: textColor ?? Colors.grey[700],
                  fontSize: radius * 0.6,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Icon(
                Icons.person,
                size: radius,
                color: textColor ?? Colors.grey[600],
              ),
      ),
    );
  }
}

