import 'package:taskly/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:taskly/screens/add_edit_task_screen.dart';
import 'package:taskly/screens/firebase_setup_screen.dart';
import 'package:taskly/screens/home_screen.dart';
import 'package:taskly/screens/login_screen.dart';
import 'package:taskly/screens/signup_screen.dart';
import 'package:taskly/screens/splash_screen.dart';
import 'package:taskly/screens/task_detail_screen.dart';
import 'package:taskly/utils/app_bindings.dart';
import 'package:taskly/utils/app_constants.dart';
import 'package:taskly/utils/app_routes.dart';
import 'package:taskly/utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  bool firebaseReady = true;
  String? firebaseError;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    firebaseReady = false;
    firebaseError = error.toString();
  }

  runApp(TasklyApp(firebaseReady: firebaseReady, firebaseError: firebaseError));
}

class TasklyApp extends StatelessWidget {
  const TasklyApp({super.key, required this.firebaseReady, this.firebaseError});

  final bool firebaseReady;
  final String? firebaseError;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialBinding: AppBindings(firebaseEnabled: firebaseReady),
          getPages: [
            GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
            GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
            GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),
            GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
            GetPage(
              name: AppRoutes.addEditTask,
              page: () => AddEditTaskScreen(task: Get.arguments as dynamic),
            ),
            GetPage(
              name: AppRoutes.taskDetail,
              page: () => TaskDetailScreen(task: Get.arguments as dynamic),
            ),
          ],
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 320),
          home: firebaseReady
              ? const SplashScreen()
              : FirebaseSetupScreen(errorMessage: firebaseError),
        );
      },
    );
  }
}
