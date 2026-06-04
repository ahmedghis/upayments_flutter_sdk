import 'package:http/http.dart' as http;

import 'api_client.dart';
import 'config.dart';
import 'services/card_service.dart';
import 'services/charge_service.dart';
import 'services/currency_service.dart';
import 'services/merchant_service.dart';
import 'services/payment_status_service.dart';
import 'services/refund_service.dart';

class UPaymentsClient {
  final ApiClient apiClient;
  late final ChargeService charge;
  late final PaymentStatusService paymentStatus;
  late final RefundService refund;
  late final CardService card;
  late final MerchantService merchant;
  late final CurrencyService currency;

  UPaymentsClient({required UPaymentsConfig config, http.Client? httpClient})
      : apiClient = ApiClient(config, httpClient) {
    charge = ChargeService(apiClient);
    paymentStatus = PaymentStatusService(apiClient);
    refund = RefundService(apiClient);
    card = CardService(apiClient);
    merchant = MerchantService(apiClient);
    currency = CurrencyService(apiClient);
  }
}
