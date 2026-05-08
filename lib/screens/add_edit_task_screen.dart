import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskly/controllers/task_controller.dart';
import 'package:taskly/models/task_model.dart';
import 'package:taskly/utils/app_constants.dart';
import 'package:taskly/utils/app_formatters.dart';
import 'package:taskly/utils/app_routes.dart';
import 'package:taskly/utils/app_snackbar.dart';
import 'package:taskly/utils/app_validators.dart';
import 'package:taskly/widgets/custom_button.dart';
import 'package:taskly/widgets/custom_text_field.dart';
import 'package:taskly/widgets/glass_card.dart';

class AddEditTaskScreen extends StatefulWidget {
  const AddEditTaskScreen({super.key, this.task});

  final TaskModel? task;

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final TaskController _taskController = Get.find<TaskController>();

  late DateTime _selectedDateTime;
  late String _selectedCategory;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController.text = task?.title ?? '';
    _descriptionController.text = task?.description ?? '';
    _selectedDateTime =
        task?.date ?? DateTime.now().add(const Duration(hours: 1));
    _selectedCategory = task?.category ?? AppConstants.taskCategories.first;
    _syncDateTimeControllers();
  }

  void _syncDateTimeControllers() {
    _dateController.text = AppFormatters.formatDate(_selectedDateTime);
    _timeController.text = AppFormatters.formatTime(_selectedDateTime);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );

    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
        _syncDateTimeControllers();
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
        _syncDateTimeControllers();
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isEditing) {
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Update Task?'),
          content: const Text('Are you sure you want to save these changes?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Update'),
            ),
          ],
        ),
      );

      if (confirm != true) {
        return;
      }
    }

    final savedTask = await _taskController.saveTask(
      existingTask: widget.task,
      title: _titleController.text,
      description: _descriptionController.text,
      date: _selectedDateTime,
      category: _selectedCategory,
    );

    if (savedTask == null) {
      return;
    }

    if (_isEditing) {
      AppSnackbar.success('Task updated successfully');
      Get.back();
      return;
    }

    final action = await Get.dialog<String>(
      _TaskCreatedDialog(task: savedTask),
      barrierDismissible: true,
    );

    if (!mounted) {
      return;
    }

    if (action == 'view') {
      Get.offNamed(AppRoutes.taskDetail, arguments: savedTask);
      return;
    }

    Get.back();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Task' : 'Add New Task')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Form(
            key: _formKey,
            child: GlassCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    label: 'Task Title',
                    hintText: 'Enter task title',
                    controller: _titleController,
                    validator: AppValidators.taskTitle,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    label: 'Description',
                    hintText: 'Enter task description',
                    controller: _descriptionController,
                    maxLines: 5,
                    validator: AppValidators.description,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: AppConstants.taskCategories
                        .map(
                          (category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Select category',
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Due Date',
                          hintText: 'Select date',
                          controller: _dateController,
                          readOnly: true,
                          onTap: _pickDate,
                          suffixIcon: const Icon(CupertinoIcons.calendar),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'Time',
                          hintText: 'Select time',
                          controller: _timeController,
                          readOnly: true,
                          onTap: _pickTime,
                          suffixIcon: const Icon(CupertinoIcons.clock),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Obx(
                    () => CustomButton(
                      text: _isEditing ? 'Update Task' : 'Add Task',
                      onPressed: _submit,
                      isLoading: _taskController.isSaving.value,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.04, end: 0),
          ),
        ),
      ),
    );
  }
}

class _TaskCreatedDialog extends StatelessWidget {
  const _TaskCreatedDialog({required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF69D892), Color(0xFF34C759)],
                ),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(height: 18),
            Text('Task Added!', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text(
              'Your task has been added successfully.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'View Task',
              onPressed: () => Get.back(result: 'view'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Get.back(result: 'continue'),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
