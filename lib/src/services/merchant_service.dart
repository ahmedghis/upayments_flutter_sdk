import '../api_client.dart';
import '../models/pay_button_status.dart';

class MerchantService {
  final ApiClient client;

  MerchantService(this.client);

  Future<PayButtonStatus> checkPaymentButtonStatus() async {
    final json = await client.getJson('/api/v1/check-payment-button-status');
    return PayButtonStatus.fromJson(json);
  }
}
