import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskly/controllers/task_controller.dart';
import 'package:taskly/utils/app_colors.dart';
import 'package:taskly/utils/app_formatters.dart';
import 'package:taskly/utils/app_routes.dart';
import 'package:taskly/widgets/empty_state_widget.dart';
import 'package:taskly/widgets/glass_card.dart';
import 'package:taskly/widgets/task_tile.dart';

class CalendarScreen extends GetView<TaskController> {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        final selectedDate = controller.selectedCalendarDate.value;
        final tasks = controller.tasksForDate(selectedDate);

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 120),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calendar',
                style: Theme.of(context).textTheme.titleLarge,
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 18),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(
                      context,
                    ).colorScheme.copyWith(primary: AppColors.primary),
                  ),
                  child: CalendarDatePicker(
                    initialDate: selectedDate,
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2032),
                    onDateChanged: (date) {
                      controller.selectedCalendarDate.value = date;
                    },
                  ),
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: 24),
              Text(
                AppFormatters.dayHeader(selectedDate),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 14),
              if (tasks.isEmpty)
                EmptyStateWidget(
                  icon: Icons.calendar_today_rounded,
                  title: 'No tasks on this date',
                  message:
                      'Pick another day or add a new task to this schedule.',
                  actionLabel: 'Add Task',
                  onAction: () => Get.toNamed(AppRoutes.addEditTask),
                )
              else
                ...tasks.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child:
                        TaskTile(
                              task: entry.value,
                              onTap: () => Get.toNamed(
                                AppRoutes.taskDetail,
                                arguments: entry.value,
                              ),
                              onToggle: () =>
                                  controller.toggleTaskStatus(entry.value),
                              onMore: () => Get.toNamed(
                                AppRoutes.addEditTask,
                                arguments: entry.value,
                              ),
                            )
                            .animate()
                            .fadeIn(delay: (entry.key * 60).ms)
                            .slideY(begin: 0.06, end: 0),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
