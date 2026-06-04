import '../api_client.dart';
import '../models/payment_status_response.dart';

class PaymentStatusService {
  final ApiClient client;

  PaymentStatusService(this.client);

  Future<PaymentStatusResponse> getPaymentStatus(String trackId) async {
    final json = await client.getJson('/api/v1/get-payment-status/$trackId');
    return PaymentStatusResponse.fromJson(json);
  }
}
