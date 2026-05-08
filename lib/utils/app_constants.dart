import 'package:taskly/models/quote_model.dart';

class AppConstants {
  static const String appName = 'Taskly';
  static const String usersCollection = 'users';
  static const String tasksCollection = 'tasks';
  static const String quoteUrl = 'https://zenquotes.io/api/random';

  static const List<String> taskCategories = [
    'Design',
    'Development',
    'Research',
    'Testing',
    'Meetings',
    'Personal',
    'General',
  ];

  static const QuoteModel fallbackQuote = QuoteModel(
    content: 'Small steps every day build remarkable results over time.',
    author: 'Taskly',
  );
}
