import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskly/controllers/auth_controller.dart';
import 'package:taskly/controllers/navigation_controller.dart';
import 'package:taskly/controllers/quote_controller.dart';
import 'package:taskly/controllers/task_controller.dart';
import 'package:taskly/models/task_model.dart';
import 'package:taskly/utils/app_colors.dart';
import 'package:taskly/utils/app_formatters.dart';
import 'package:taskly/utils/app_routes.dart';
import 'package:taskly/widgets/empty_state_widget.dart';
import 'package:taskly/widgets/loading_widget.dart';
import 'package:taskly/widgets/quote_card.dart';
import 'package:taskly/widgets/stats_card.dart';
import 'package:taskly/widgets/task_tile.dart';

class DashboardScreen extends GetView<TaskController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final quoteController = Get.find<QuoteController>();
    final navigationController = Get.find<NavigationController>();

    return SafeArea(
      child: Obx(
        () => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await quoteController.loadQuote();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppFormatters.greeting(),
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                authController.displayName,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineLarge,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 18,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              AppFormatters.initials(
                                authController.displayName,
                              ),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(height: 24),
                    Row(
                          children: [
                            Expanded(
                              child: StatsCard(
                                value: controller.totalTasks.toString(),
                                label: 'Total Tasks',
                                accent: AppColors.primary,
                                subtitle: 'Keep building momentum',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: StatsCard(
                                value: controller.completedTasks.toString(),
                                label: 'Completed',
                                accent: AppColors.success,
                                subtitle: 'Great progress today',
                              ),
                            ),
                          ],
                        )
                        .animate()
                        .fadeIn(delay: 80.ms)
                        .slideY(begin: 0.05, end: 0),
                    const SizedBox(height: 16),
                    QuoteCard(
                          quote: quoteController.quote.value,
                          isLoading: quoteController.isLoading.value,
                          onRefresh: quoteController.loadQuote,
                        )
                        .animate()
                        .fadeIn(delay: 140.ms)
                        .slideY(begin: 0.06, end: 0),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Text(
                          "Today's Tasks",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => navigationController.changeTab(1),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (controller.isLoading.value)
                      const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: LoadingWidget(),
                      )
                    else if (controller.todayTasks.isEmpty)
                      EmptyStateWidget(
                        icon: Icons.event_available_rounded,
                        title: 'Your day is clear',
                        message:
                            'Add a task to start building a focused schedule.',
                        actionLabel: 'Create Task',
                        onAction: () => Get.toNamed(AppRoutes.addEditTask),
                      )
                    else
                      ...controller.todayTasks
                          .take(4)
                          .toList()
                          .asMap()
                          .entries
                          .map(
                            (entry) =>
                                Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 14,
                                      ),
                                      child: _DashboardTaskCard(
                                        task: entry.value,
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(delay: (180 + entry.key * 70).ms)
                                    .slideY(begin: 0.08, end: 0),
                          ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardTaskCard extends StatelessWidget {
  const _DashboardTaskCard({required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return TaskTile(
      task: task,
      showDate: false,
      onTap: () => Get.toNamed(AppRoutes.taskDetail, arguments: task),
      onToggle: () => taskController.toggleTaskStatus(task),
      onMore: () => _showTaskOptions(context, task),
    );
  }

  Future<void> _showTaskOptions(BuildContext context, TaskModel task) async {
    final taskController = Get.find<TaskController>();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_rounded),
                  title: const Text('Edit Task'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.toNamed(AppRoutes.addEditTask, arguments: task);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded),
                  title: const Text('Delete Task'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await taskController.deleteTask(task);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
