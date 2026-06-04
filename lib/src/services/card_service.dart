import '../api_client.dart';
import '../models/add_card_response.dart';
import '../models/saved_card.dart';

class CardService {
  final ApiClient client;

  CardService(this.client);

  static final _tokenPattern = RegExp(r'^[0-9]{8,18}$');

  Future<String> createCustomerUniqueToken(String customerUniqueToken) async {
    if (!_tokenPattern.hasMatch(customerUniqueToken)) {
      throw ArgumentError(
          'customerUniqueToken must be a numeric string between 8 and 18 digits.');
    }
    final json = await client.postJson('/api/v1/create-customer-unique-token',
        {'customerUniqueToken': customerUniqueToken});
    return json['token']?.toString() ?? '';
  }

  Future<AddCardResponse> addCard(
      String customerUniqueToken, Map<String, dynamic> payload) async {
    final body = {
      'customerUniqueToken': customerUniqueToken,
      ...payload,
    };
    final json = await client.postJson('/api/v1/add-card', body);
    return AddCardResponse.fromJson(json);
  }

  Future<List<SavedCard>> retrieveCustomerCards(
      String customerUniqueToken) async {
    final json = await client.postJson('/api/v1/retrieve-customer-cards',
        {'customerUniqueToken': customerUniqueToken});
    final cards = <SavedCard>[];
    if (json['cards'] is List<dynamic>) {
      cards.addAll((json['cards'] as List<dynamic>)
          .map((item) => SavedCard.fromJson(item as Map<String, dynamic>)));
    }
    return cards;
  }
}
