import 'package:flutter/material.dart';

/// Utility class for showing custom dialogs with rounded corners
class DialogUtility {
  /// Shows a single button dialog
  static Future<void> showSingleButtonDialog({
    required BuildContext context,
    String? title,
    String? message,
    String buttonText = 'OK',
    VoidCallback? onButtonPressed,
    Widget? image,
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
    Color? buttonColor,
    Color? buttonTextColor,
    double borderRadius = 16.0,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => _CustomDialog(
        title: title,
        message: message,
        image: image,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        messageColor: messageColor,
        borderRadius: borderRadius,
        buttons: [
          _DialogButton(
            text: buttonText,
            onPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
            color: buttonColor,
            textColor: buttonTextColor,
          ),
        ],
      ),
    );
  }

  /// Shows a double button dialog (e.g., Cancel/Confirm)
  static Future<void> showDoubleButtonDialog({
    required BuildContext context,
    String? title,
    String? message,
    String primaryButtonText = 'OK',
    String secondaryButtonText = 'Cancel',
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    Widget? image,
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
    Color? primaryButtonColor,
    Color? primaryButtonTextColor,
    Color? secondaryButtonColor,
    Color? secondaryButtonTextColor,
    double borderRadius = 16.0,
    bool barrierDismissible = true,
    bool isDestructive = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => _CustomDialog(
        title: title,
        message: message,
        image: image,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        messageColor: messageColor,
        borderRadius: borderRadius,
        buttons: [
          _DialogButton(
            text: secondaryButtonText,
            onPressed: onSecondaryPressed ?? () => Navigator.of(context).pop(),
            color: secondaryButtonColor,
            textColor: secondaryButtonTextColor,
            isOutlined: true,
          ),
          const SizedBox(width: 12),
          _DialogButton(
            text: primaryButtonText,
            onPressed: onPrimaryPressed ?? () => Navigator.of(context).pop(),
            color: primaryButtonColor ??
                (isDestructive ? Colors.red : Theme.of(context).primaryColor),
            textColor: primaryButtonTextColor,
          ),
        ],
      ),
    );
  }

  /// Shows a custom dialog with full control
  static Future<void> showCustomDialog({
    required BuildContext context,
    String? title,
    String? message,
    List<Widget>? buttons,
    Widget? image,
    Widget? customContent,
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
    double borderRadius = 16.0,
    bool barrierDismissible = true,
    EdgeInsets? padding,
    double? width,
    double? maxHeight,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => _CustomDialog(
        title: title,
        message: message,
        image: image,
        customContent: customContent,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        messageColor: messageColor,
        borderRadius: borderRadius,
        buttons: buttons,
        padding: padding,
        width: width,
        maxHeight: maxHeight,
      ),
    );
  }

  /// Shows a success dialog
  static Future<void> showSuccessDialog({
    required BuildContext context,
    String? title,
    String message = 'Operation completed successfully!',
    String buttonText = 'OK',
    VoidCallback? onButtonPressed,
    double borderRadius = 16.0,
  }) {
    return showSingleButtonDialog(
      context: context,
      title: title ?? 'Success',
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      image: const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 64,
      ),
      buttonColor: Colors.green,
    );
  }

  /// Shows an error dialog
  static Future<void> showErrorDialog({
    required BuildContext context,
    String? title,
    String message = 'An error occurred!',
    String buttonText = 'OK',
    VoidCallback? onButtonPressed,
    double borderRadius = 16.0,
  }) {
    return showSingleButtonDialog(
      context: context,
      title: title ?? 'Error',
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      image: const Icon(
        Icons.error,
        color: Colors.red,
        size: 64,
      ),
      buttonColor: Colors.red,
    );
  }

  /// Shows a warning dialog
  static Future<void> showWarningDialog({
    required BuildContext context,
    String? title,
    String message = 'Please be careful!',
    String primaryButtonText = 'Continue',
    String secondaryButtonText = 'Cancel',
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    double borderRadius = 16.0,
  }) {
    return showDoubleButtonDialog(
      context: context,
      title: title ?? 'Warning',
      message: message,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: onSecondaryPressed,
      image: const Icon(
        Icons.warning,
        color: Colors.orange,
        size: 64,
      ),
      primaryButtonColor: Colors.orange,
    );
  }

  /// Shows a confirmation dialog
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    String? title,
    String message = 'Are you sure?',
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Widget? image,
    bool isDestructive = false,
    double borderRadius = 16.0,
  }) async {
    bool confirmed = false;
    await showDoubleButtonDialog(
      context: context,
      title: title ?? 'Confirm',
      message: message,
      primaryButtonText: confirmText,
      secondaryButtonText: cancelText,
      image: image,
      isDestructive: isDestructive,
      onPrimaryPressed: () {
        confirmed = true;
        Navigator.of(context).pop();
      },
      onSecondaryPressed: () {
        confirmed = false;
        Navigator.of(context).pop();
      },
      borderRadius: borderRadius,
    );
    return confirmed;
  }

  /// Shows a loading dialog
  static Future<void> showLoadingDialog({
    required BuildContext context,
    String message = 'Please wait...',
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => PopScope(
        canPop: barrierDismissible,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal custom dialog widget
class _CustomDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? image;
  final Widget? customContent;
  final List<Widget>? buttons;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? messageColor;
  final double borderRadius;
  final EdgeInsets? padding;
  final double? width;
  final double? maxHeight;

  const _CustomDialog({
    this.title,
    this.message,
    this.image,
    this.customContent,
    this.buttons,
    this.backgroundColor,
    this.titleColor,
    this.messageColor,
    this.borderRadius = 16.0,
    this.padding,
    this.width,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      backgroundColor: backgroundColor ??
          theme.dialogTheme.backgroundColor ??
          theme.colorScheme.surface,
      child: Container(
        width: width,
        constraints: maxHeight != null
            ? BoxConstraints(maxHeight: maxHeight!)
            : null,
        padding: padding ?? const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            if (image != null) ...[
              image!,
              const SizedBox(height: 16),
            ],

            // Title
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? theme.textTheme.titleLarge?.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],

            // Message
            if (message != null) ...[
              Text(
                message!,
                style: TextStyle(
                  fontSize: 16,
                  color: messageColor ?? theme.textTheme.bodyMedium?.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],

            // Custom Content
            if (customContent != null) ...[
              customContent!,
              const SizedBox(height: 24),
            ],

            // Buttons
            if (buttons != null && buttons!.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: buttons!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Internal dialog button widget
class _DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final bool isOutlined;

  const _DialogButton({
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        foregroundColor: textColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text),
    );
  }
}

