import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskly/controllers/auth_controller.dart';
import 'package:taskly/controllers/task_controller.dart';
import 'package:taskly/utils/app_colors.dart';
import 'package:taskly/utils/app_formatters.dart';
import 'package:taskly/utils/app_validators.dart';
import 'package:taskly/widgets/glass_card.dart';

class ProfileScreen extends GetView<AuthController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return SafeArea(
      child: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 120),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF5F74FF),
                      Color(0xFF4256F6),
                      Color(0xFF2E46E6),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x334B5CFF),
                      blurRadius: 30,
                      offset: Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white.withValues(alpha: 0.28),
                      child: Text(
                        AppFormatters.initials(controller.displayName),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      controller.emailAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      child: _MiniStat(
                        label: 'Total',
                        value: taskController.totalTasks.toString(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassCard(
                      child: _MiniStat(
                        label: 'Completed',
                        value: taskController.completedTasks.toString(),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 80.ms),
              const SizedBox(height: 20),
              GlassCard(
                child: Column(
                  children: [
                    _ProfileRow(
                      icon: Icons.edit_outlined,
                      label: 'Edit Profile',
                      onTap: () => _showEditProfileDialog(context),
                    ),
                    _ProfileRow(
                      icon: Icons.auto_graph_rounded,
                      label: 'Productivity Summary',
                      subtitle:
                          '${taskController.pendingTasks} tasks still in progress',
                    ),
                    _ProfileRow(
                      icon: Icons.support_agent_rounded,
                      label: 'Help & Support',
                      subtitle: 'Assignment-ready architecture and UX',
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 140.ms),
              const SizedBox(height: 20),
              InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: controller.signOut,
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.logout_rounded, color: AppColors.error),
                      const SizedBox(width: 12),
                      Text(
                        'Log Out',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEditProfileDialog(BuildContext context) async {
    final nameController = TextEditingController(text: controller.displayName);
    final formKey = GlobalKey<FormState>();

    await Get.dialog<void>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profile',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: nameController,
                  validator: AppValidators.name,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your name',
                  ),
                ),
                const SizedBox(height: 22),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: Get.back,
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: controller.isProfileUpdating.value
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  await controller.updateProfileName(
                                    nameController.text,
                                  );
                                  Get.back();
                                },
                          child: controller.isProfileUpdating.value
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(label),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: onTap == null
          ? null
          : const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
            ),
      onTap: onTap,
    );
  }
}
