import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskly/controllers/auth_controller.dart';
import 'package:taskly/utils/app_colors.dart';
import 'package:taskly/utils/app_routes.dart';
import 'package:taskly/widgets/custom_button.dart';
import 'package:taskly/widgets/glass_card.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.wait([
      _authController.ensureInitialized(),
      Future<void>.delayed(const Duration(milliseconds: 1400)),
    ]);

    if (!mounted) {
      return;
    }

    final route = _authController.isLoggedIn ? AppRoutes.home : AppRoutes.login;
    Get.offAllNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF9FBFF), Color(0xFFF2F5FF), Color(0xFFF8FAFF)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              children: [
                const Spacer(),
                GlassCard(
                      padding: const EdgeInsets.all(22),
                      radius: 30,
                      child: const Icon(
                        Icons.task_alt_rounded,
                        size: 56,
                        color: AppColors.primary,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 450.ms)
                    .scale(
                      begin: const Offset(0.92, 0.92),
                      curve: Curves.easeOutBack,
                    ),
                const SizedBox(height: 28),
                Text(
                  'Taskly',
                  style: Theme.of(context).textTheme.headlineLarge,
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.22, end: 0),
                const SizedBox(height: 12),
                Text(
                  'Organize your tasks.\nSimplify your day.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 320.ms),
                const Spacer(),
                CustomButton(
                  text: 'Preparing Workspace',
                  onPressed: () {},
                  isLoading: true,
                ).animate().fadeIn(delay: 480.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
