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
  }) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 18,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      titleText: const SizedBox.shrink(),
      messageText: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
