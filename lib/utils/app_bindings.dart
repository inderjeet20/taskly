import 'package:get/get.dart';
import 'package:taskly/controllers/auth_controller.dart';
import 'package:taskly/controllers/navigation_controller.dart';
import 'package:taskly/controllers/quote_controller.dart';
import 'package:taskly/controllers/task_controller.dart';
import 'package:taskly/services/api_service.dart';
import 'package:taskly/services/auth_service.dart';
import 'package:taskly/services/task_service.dart';

class AppBindings extends Bindings {
  AppBindings({required this.firebaseEnabled});

  final bool firebaseEnabled;

  @override
  void dependencies() {
    Get.put(ApiService(), permanent: true);
    Get.put(NavigationController(), permanent: true);
    Get.put(
      QuoteController(apiService: Get.find<ApiService>()),
      permanent: true,
    );

    if (!firebaseEnabled) {
      return;
    }

    Get.put(AuthService(), permanent: true);
    Get.put(TaskService(), permanent: true);
    Get.put(
      AuthController(authService: Get.find<AuthService>()),
      permanent: true,
    );
    Get.put(
      TaskController(
        taskService: Get.find<TaskService>(),
        authController: Get.find<AuthController>(),
      ),
      permanent: true,
    );
  }
}
