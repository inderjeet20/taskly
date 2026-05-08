import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskly/utils/app_colors.dart';

class AppSnackbar {
  static void success(String message) {
    _show(
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_rounded,
    );
  }

  static void undo({
    required String message,
    required VoidCallback onUndo,
  }) {
    _show(
      message: message,
      backgroundColor: Colors.black87,
      icon: Icons.info_outline_rounded,
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
          onUndo();
        },
        child: const Text(
          'UNDO',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static void error(String message) {
    _show(
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_rounded,
    );
  }

  static void info(String message) {
    _show(
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_rounded,
    );
  }

  static void _show({
    required String message,
    required Color backgroundColor,
    required IconData icon,
    TextButton? mainButton,
  }) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      borderRadius: 18,
      backgroundColor: backgroundColor.withValues(alpha: 0.95),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      mainButton: mainButton,
      titleText: const SizedBox.shrink(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      messageText: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
