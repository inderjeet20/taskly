import 'package:get/get.dart';
import 'package:taskly/models/quote_model.dart';
import 'package:taskly/services/api_service.dart';
import 'package:taskly/utils/app_constants.dart';

class QuoteController extends GetxController {
  QuoteController({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;

  final quote = Rx<QuoteModel>(AppConstants.fallbackQuote);
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuote();
  }

  Future<void> loadQuote() async {
    try {
      isLoading.value = true;
      quote.value = await _apiService.fetchDailyQuote();
    } finally {
      isLoading.value = false;
    }
  }
}
