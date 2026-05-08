import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taskly/models/quote_model.dart';
import 'package:taskly/utils/app_constants.dart';

class ApiService {
  Future<QuoteModel> fetchDailyQuote() async {
    try {
      final response = await http
          .get(Uri.parse(AppConstants.quoteUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        return QuoteModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }

      return AppConstants.fallbackQuote;
    } on TimeoutException {
      return AppConstants.fallbackQuote;
    } catch (_) {
      return AppConstants.fallbackQuote;
    }
  }
}
