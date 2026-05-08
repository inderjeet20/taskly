import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskly/controllers/auth_controller.dart';
import 'package:taskly/utils/app_routes.dart';
import 'package:taskly/utils/app_snackbar.dart';
import 'package:taskly/utils/app_validators.dart';
import 'package:taskly/widgets/custom_button.dart';
import 'package:taskly/widgets/custom_text_field.dart';
import 'package:taskly/widgets/glass_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  bool _obscurePassword = true;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _authController.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 36),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.waving_hand_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ).animate().fadeIn(duration: 350.ms),
                const SizedBox(height: 26),
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineLarge,
                ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05, end: 0),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue managing your day with clarity.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 32),
                GlassCard(
                  padding: const EdgeInsets.all(22),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Email',
                          hintText: 'Enter your email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: AppValidators.email,
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          label: 'Password',
                          hintText: 'Enter your password',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: AppValidators.password,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              AppSnackbar.info(
                                'Password reset is easy to add later with Firebase Auth.',
                              );
                            },
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(
                          () => CustomButton(
                            text: 'Sign In',
                            onPressed: _submit,
                            isLoading: _authController.isLoginLoading.value,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Or continue with',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: const [
                            Expanded(
                              child: _SocialStubButton(
                                label: 'Google',
                                icon: Icons.g_mobiledata_rounded,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _SocialStubButton(
                                label: 'Apple',
                                icon: Icons.apple_rounded,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 240.ms).slideY(begin: 0.08, end: 0),
                const SizedBox(height: 40),
                Center(
                  child: TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.signup),
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                ).animate().fadeIn(delay: 320.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialStubButton extends StatelessWidget {
  const _SocialStubButton({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        AppSnackbar.info(
          '$label sign-in is intentionally left as a UI placeholder for this assignment.',
        );
      },
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
