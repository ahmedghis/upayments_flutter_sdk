import '../api_client.dart';
import '../models/refund_request.dart';
import '../models/refund_response.dart';

class RefundService {
  final ApiClient client;

  RefundService(this.client);

  Future<RefundResponse> createRefund(RefundRequest request) async {
    final json = await client.postJson('/api/v1/create-refund', request.toJson());
    return RefundResponse.fromJson(json);
  }

  Future<RefundResponse> cancelRefund(String refundId) async {
    final json = await client.getJson('/api/v1/delete-refund',
        queryParameters: {'refund_id': refundId});
    return RefundResponse.fromJson(json);
  }

  Future<RefundResponse> checkRefund(String orderId) async {
    final json = await client.getJson('/api/v1/check-refund/$orderId');
    return RefundResponse.fromJson(json);
  }
}
