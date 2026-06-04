import '../api_client.dart';
import '../models/currency_rate.dart';

class CurrencyService {
  final ApiClient client;

  CurrencyService(this.client);

  Future<List<CurrencyRate>> getCurrencyRateList() async {
    final json = await client.getJson('/api/v1/get-currency-rate-list');
    final rates = <CurrencyRate>[];
    if (json['rates'] is List<dynamic>) {
      rates.addAll((json['rates'] as List<dynamic>)
          .map((item) => CurrencyRate.fromJson(item as Map<String, dynamic>)));
    }
    return rates;
  }
}
