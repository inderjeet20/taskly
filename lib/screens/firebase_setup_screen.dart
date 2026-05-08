import 'package:flutter/material.dart';
import 'package:taskly/utils/app_colors.dart';
import 'package:taskly/widgets/glass_card.dart';

class FirebaseSetupScreen extends StatelessWidget {
  const FirebaseSetupScreen({super.key, this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.cloud_sync_rounded,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Firebase Setup Needed',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Add your Firebase platform configuration files, then rerun the app.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  const Text('1. Add `android/app/google-services.json`'),
                  const SizedBox(height: 6),
                  const Text('2. Add `ios/Runner/GoogleService-Info.plist`'),
                  const SizedBox(height: 6),
                  const Text(
                    '3. Run `flutterfire configure` or connect native Firebase settings',
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 18),
                    Text(
                      errorMessage!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.error),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
