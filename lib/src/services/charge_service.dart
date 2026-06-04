import '../api_client.dart';
import '../models/charge_request.dart';
import '../models/charge_response.dart';

class ChargeService {
  final ApiClient client;

  ChargeService(this.client);

  Future<ChargeResponse> createCharge(ChargeRequest request) async {
    if (request.notificationUrl.isEmpty) {
      throw ArgumentError('notificationUrl is required for charge creation.');
    }
    final payload = request.toJson();
    payload['plugin'] = {'src': 'flutter-sdk'};
    final json = await client.postJson('/api/v1/charge', payload);
    return ChargeResponse.fromJson(json);
  }
}
