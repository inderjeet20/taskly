import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskly/controllers/auth_controller.dart';
import 'package:taskly/utils/app_routes.dart';
import 'package:taskly/utils/app_validators.dart';
import 'package:taskly/widgets/custom_button.dart';
import 'package:taskly/widgets/custom_text_field.dart';
import 'package:taskly/widgets/glass_card.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  bool _obscurePassword = true;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _authController.signUp(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        Icons.rocket_launch_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                    ).animate().fadeIn(duration: 350.ms),
                    const SizedBox(height: 22),
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 6),
                    Text(
                      'Let’s get your productivity space set up beautifully.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 28),
                    GlassCard(
                      padding: const EdgeInsets.all(22),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'Full Name',
                              hintText: 'Enter your name',
                              controller: _nameController,
                              validator: AppValidators.name,
                            ),
                            const SizedBox(height: 18),
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
                              hintText: 'Create a password',
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
                            const SizedBox(height: 24),
                            Obx(
                              () => CustomButton(
                                text: 'Sign Up',
                                onPressed: _submit,
                                isLoading: _authController.isSignupLoading.value,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 240.ms).slideY(begin: 0.08, end: 0),
                    const SizedBox(height: 28),
                    Center(
                      child: TextButton(
                        onPressed: () => Get.offNamed(AppRoutes.login),
                        child: const Text('Already have an account? Sign In'),
                      ),
                    ).animate().fadeIn(delay: 340.ms),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
