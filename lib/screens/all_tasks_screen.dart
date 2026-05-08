import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskly/controllers/task_controller.dart';
import 'package:taskly/models/task_model.dart';
import 'package:taskly/utils/app_colors.dart';
import 'package:taskly/utils/app_routes.dart';
import 'package:taskly/widgets/empty_state_widget.dart';
import 'package:taskly/widgets/loading_widget.dart';
import 'package:taskly/widgets/task_tile.dart';

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  String _filter = 'all';

  List<TaskModel> _applyFilter(List<TaskModel> tasks) {
    switch (_filter) {
      case 'pending':
        return tasks.where((task) => !task.isCompleted).toList();
      case 'completed':
        return tasks.where((task) => task.isCompleted).toList();
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return SafeArea(
      child: Obx(() {
        final filteredTasks = _applyFilter(taskController.tasks);

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'All Tasks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.toNamed(AppRoutes.addEditTask),
                    icon: const Icon(Icons.add_circle_outline_rounded),
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _filter == 'all',
                    onTap: () => setState(() => _filter = 'all'),
                  ),
                  _FilterChip(
                    label: 'Pending',
                    selected: _filter == 'pending',
                    onTap: () => setState(() => _filter = 'pending'),
                  ),
                  _FilterChip(
                    label: 'Completed',
                    selected: _filter == 'completed',
                    onTap: () => setState(() => _filter = 'completed'),
                  ),
                ],
              ).animate().fadeIn(delay: 90.ms),
              const SizedBox(height: 22),
              Expanded(
                child: taskController.isLoading.value
                    ? const LoadingWidget()
                    : filteredTasks.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.inbox_rounded,
                        title: 'Nothing here yet',
                        message:
                            'Your tasks will appear here once you add them.',
                        actionLabel: 'Add Task',
                        onAction: () => Get.toNamed(AppRoutes.addEditTask),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child:
                                TaskTile(
                                      task: task,
                                      onTap: () => Get.toNamed(
                                        AppRoutes.taskDetail,
                                        arguments: task,
                                      ),
                                      onToggle: () =>
                                          taskController.toggleTaskStatus(task),
                                      onMore: () => _showTaskOptions(task),
                                    )
                                    .animate()
                                    .fadeIn(
                                      delay: (index * 55).ms,
                                      duration: 260.ms,
                                    )
                                    .slideY(begin: 0.05, end: 0),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _showTaskOptions(TaskModel task) async {
    final taskController = Get.find<TaskController>();

    await Get.bottomSheet<void>(
      Container(
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
                  Get.back();
                  Get.toNamed(AppRoutes.addEditTask, arguments: task);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                ),
                title: const Text('Delete Task'),
                onTap: () async {
                  Get.back();
                  await taskController.deleteTask(task);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
          boxShadow: selected
              ? const []
              : const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: Offset(0, 8),
                  ),
                ],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
