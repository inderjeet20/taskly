class AppValidators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name.';
    }
    if (value.trim().length < 2) {
      return 'Name should be at least 2 characters.';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email.';
    }
    final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password.';
    }
    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  static String? taskTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a task title.';
    }
    if (value.trim().length < 3) {
      return 'Task title should be at least 3 characters.';
    }
    return null;
  }

  static String? description(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please add a short description.';
    }
    if (value.trim().length < 8) {
      return 'Description should be a bit more descriptive.';
    }
    return null;
  }
}
