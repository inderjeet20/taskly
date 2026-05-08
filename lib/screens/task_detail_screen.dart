import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskly/controllers/task_controller.dart';
import 'package:taskly/models/task_model.dart';
import 'package:taskly/utils/app_colors.dart';
import 'package:taskly/utils/app_formatters.dart';
import 'package:taskly/utils/app_routes.dart';
import 'package:taskly/widgets/custom_button.dart';
import 'package:taskly/widgets/glass_card.dart';

class TaskDetailScreen extends GetView<TaskController> {
  const TaskDetailScreen({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final liveTask = controller.findById(task.id) ?? task;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Task Details'),
          actions: [
            IconButton(
              onPressed: () =>
                  Get.toNamed(AppRoutes.addEditTask, arguments: liveTask),
              icon: const Icon(Icons.edit_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Icon(
                      liveTask.isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.play_circle_fill_rounded,
                      color: liveTask.isCompleted
                          ? AppColors.success
                          : AppColors.primary,
                      size: 42,
                    ),
                  ),
                ).animate().fadeIn(duration: 280.ms).scale(),
                const SizedBox(height: 22),
                Center(
                  child: Text(
                    liveTask.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      liveTask.category,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        child: _DetailInfo(
                          label: 'Due Date',
                          value: AppFormatters.formatDate(liveTask.date),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassCard(
                        child: _DetailInfo(
                          label: 'Time',
                          value: AppFormatters.formatTime(liveTask.date),
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 18),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        liveTask.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 160.ms),
                const SizedBox(height: 28),
                CustomButton(
                  text: liveTask.isCompleted
                      ? 'Mark as Pending'
                      : 'Mark as Completed',
                  onPressed: () => controller.toggleTaskStatus(liveTask),
                  color: liveTask.isCompleted
                      ? AppColors.textSecondary
                      : AppColors.primary,
                ).animate().fadeIn(delay: 220.ms),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    final shouldDelete = await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text('Delete Task?'),
                        content: const Text(
                          'This task will be permanently removed from Firestore.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Get.back(result: true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (shouldDelete == true) {
                      await controller.deleteTask(liveTask);
                      Get.back();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                  child: const Text('Delete Task'),
                ).animate().fadeIn(delay: 280.ms),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _DetailInfo extends StatelessWidget {
  const _DetailInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
