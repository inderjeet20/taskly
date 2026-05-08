import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskly/controllers/navigation_controller.dart';
import 'package:taskly/screens/all_tasks_screen.dart';
import 'package:taskly/screens/calendar_screen.dart';
import 'package:taskly/screens/dashboard_screen.dart';
import 'package:taskly/screens/profile_screen.dart';
import 'package:taskly/utils/app_colors.dart';
import 'package:taskly/utils/app_routes.dart';

class HomeScreen extends GetView<NavigationController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardScreen(),
      const AllTasksScreen(),
      const CalendarScreen(),
      const ProfileScreen(),
    ];

    return Obx(
      () => Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        floatingActionButton: AnimatedScale(
          scale: controller.currentIndex.value == 3 ? 0 : 1,
          duration: const Duration(milliseconds: 220),
          child: FloatingActionButton(
            elevation: 10,
            backgroundColor: AppColors.primary,
            onPressed: () => Get.toNamed(AppRoutes.addEditTask),
            child: const Icon(Icons.add_rounded, size: 28, color: Colors.white),
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 28,
                  offset: Offset(0, 18),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: CupertinoIcons.home,
                  activeIcon: CupertinoIcons.house_fill,
                  label: 'Home',
                  isActive: controller.currentIndex.value == 0,
                  onTap: () => controller.changeTab(0),
                ),
                _NavItem(
                  icon: CupertinoIcons.checkmark_square,
                  activeIcon: CupertinoIcons.checkmark_square_fill,
                  label: 'Tasks',
                  isActive: controller.currentIndex.value == 1,
                  onTap: () => controller.changeTab(1),
                ),
                _NavItem(
                  icon: CupertinoIcons.calendar,
                  activeIcon: CupertinoIcons.calendar_today,
                  label: 'Calendar',
                  isActive: controller.currentIndex.value == 2,
                  onTap: () => controller.changeTab(2),
                ),
                _NavItem(
                  icon: CupertinoIcons.person,
                  activeIcon: CupertinoIcons.person_fill,
                  label: 'Profile',
                  isActive: controller.currentIndex.value == 3,
                  onTap: () => controller.changeTab(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 20,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive ? AppColors.primary : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
