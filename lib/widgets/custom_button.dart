import 'package:flutter/material.dart';
import 'package:taskly/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.primary;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shadowColor: buttonColor.withValues(alpha: 0.32),
          elevation: 12,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: isLoading
              ? const SizedBox(
                  key: ValueKey('loader'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : Text(text, key: const ValueKey('text')),
        ),
      ),
    );
  }
}
