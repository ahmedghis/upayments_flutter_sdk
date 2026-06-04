import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:upayments_sdk/upayments_sdk.dart';

import 'services_test.mocks.dart';

@GenerateMocks([http.BaseClient])
void main() {
  const apiKey = 'jtest123';
  const baseUrl = 'https://sandbox.upayments.com';

  late MockBaseClient mockClient;
  late UPaymentsClient client;

  setUp(() {
    mockClient = MockBaseClient();
    client = UPaymentsClient(
      config: const UPaymentsConfig(apiKey: apiKey, isSandbox: true),
      httpClient: mockClient,
    );
  });

  http.StreamedResponse respond(int statusCode, Map<String, dynamic> body) {
    return http.StreamedResponse(
      Stream.fromIterable([utf8.encode(jsonEncode(body))]),
      statusCode,
      headers: {'content-type': 'application/json'},
    );
  }

  void stubSend(http.StreamedResponse Function(http.BaseRequest) handler) {
    when(mockClient.send(any)).thenAnswer((invocation) async {
      final request = invocation.positionalArguments[0] as http.BaseRequest;
      return handler(request);
    });
  }

  // ---------------------------------------------------------------------------
  // ChargeService
  // ---------------------------------------------------------------------------

  test('ChargeService creates a charge successfully', () async {
    stubSend((request) {
      expect(request.method, 'POST');
      expect(request.url.toString(), '$baseUrl/api/v1/charge');
      return respond(200, {
        'track_id': 'track_123',
        'link': 'https://checkout.example.com/session/track_123',
        'status': 'pending',
      });
    });

    final response = await client.charge.createCharge(
      ChargeRequest(
        amount: 1000,
        currency: 'USD',
        notificationUrl: 'https://example.com/webhook',
      ),
    );

    expect(response.trackId, 'track_123');
    expect(response.link, contains('checkout.example.com'));
  });

  // ---------------------------------------------------------------------------
  // PaymentStatusService
  // ---------------------------------------------------------------------------

  test('PaymentStatusService retrieves payment status', () async {
    stubSend((request) {
      expect(request.method, 'GET');
      expect(request.url.toString(), '$baseUrl/api/v1/get-payment-status/track_123');
      return respond(200, {
        'track_id': 'track_123',
        'status': 'paid',
        'paid_amount': 1000,
        'currency': 'USD',
      });
    });

    final status = await client.paymentStatus.getPaymentStatus('track_123');
    expect(status.status, 'paid');
    expect(status.paidAmount, 1000);
  });

  // ---------------------------------------------------------------------------
  // RefundService
  // ---------------------------------------------------------------------------

  test('RefundService creates a refund successfully', () async {
    stubSend((request) {
      expect(request.method, 'POST');
      expect(request.url.toString(), '$baseUrl/api/v1/create-refund');
      return respond(200, {
        'refund_id': 'refund_123',
        'order_id': 'order_123',
        'status': 'initiated',
      });
    });

    final refundResponse = await client.refund.createRefund(
      RefundRequest(
        orderId: 'order_123',
        amount: 1000,
        currency: 'USD',
      ),
    );

    expect(refundResponse.refundId, 'refund_123');
    expect(refundResponse.status, 'initiated');
  });

  test('RefundService cancels a refund successfully', () async {
    stubSend((request) {
      expect(request.method, 'GET');
      expect(request.url.toString(), contains('/api/v1/delete-refund'));
      expect(request.url.queryParameters['refund_id'], 'refund_123');
      return respond(200, {
        'refund_id': 'refund_123',
        'order_id': 'order_456',
        'status': 'cancelled',
      });
    });

    final result = await client.refund.cancelRefund('refund_123');
    expect(result.refundId, 'refund_123');
    expect(result.status, 'cancelled');
  });

  test('RefundService checks refund status by order ID', () async {
    stubSend((request) {
      expect(request.method, 'GET');
      expect(request.url.toString(), '$baseUrl/api/v1/check-refund/order_456');
      return respond(200, {
        'refund_id': 'refund_123',
        'order_id': 'order_456',
        'status': 'completed',
      });
    });

    final result = await client.refund.checkRefund('order_456');
    expect(result.orderId, 'order_456');
    expect(result.status, 'completed');
  });

  // ---------------------------------------------------------------------------
  // CardService
  // ---------------------------------------------------------------------------

  test('CardService creates a customer unique token', () async {
    stubSend((request) {
      expect(request.method, 'POST');
      expect(request.url.toString(), '$baseUrl/api/v1/create-customer-unique-token');
      return respond(200, {'token': 'tok_abc123'});
    });

    final token = await client.card.createCustomerUniqueToken('123456789');
    expect(token, 'tok_abc123');
  });

  test('CardService rejects tokens that fail the digits-only pattern', () async {
    expect(
      () => client.card.createCustomerUniqueToken('user_123_+9876'),
      throwsA(isA<ArgumentError>()),
    );
    expect(
      () => client.card.createCustomerUniqueToken('1234567'),
      throwsA(isA<ArgumentError>()),
    );
    expect(
      () => client.card.createCustomerUniqueToken('1234567890123456789'),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('CardService adds a card and returns typed response', () async {
    stubSend((request) {
      expect(request.method, 'POST');
      expect(request.url.toString(), '$baseUrl/api/v1/add-card');
      return respond(200, {
        'redirect_url': 'https://3ds.example.com/verify',
        'status': 'pending',
      });
    });

    final result = await client.card.addCard('123456789', {'cardNumber': '4111111111111111'});
    expect(result.redirectUrl, 'https://3ds.example.com/verify');
    expect(result.status, 'pending');
  });

  test('CardService retrieves saved cards for a customer', () async {
    stubSend((request) {
      expect(request.method, 'POST');
      expect(request.url.toString(), '$baseUrl/api/v1/retrieve-customer-cards');
      return respond(200, {
        'cards': [
          {
            'card_id': 'card_001',
            'brand': 'Visa',
            'last4': '4242',
            'expiry_month': 12,
            'expiry_year': 2027,
          }
        ]
      });
    });

    final cards = await client.card.retrieveCustomerCards('123456789');
    expect(cards, hasLength(1));
    expect(cards.first.brand, 'Visa');
    expect(cards.first.last4, '4242');
  });

  // ---------------------------------------------------------------------------
  // MerchantService
  // ---------------------------------------------------------------------------

  test('MerchantService returns payment button status', () async {
    stubSend((request) {
      expect(request.method, 'GET');
      expect(request.url.toString(), '$baseUrl/api/v1/check-payment-button-status');
      return respond(200, {
        'enabled': true,
        'available_methods': ['card', 'wallet'],
      });
    });

    final status = await client.merchant.checkPaymentButtonStatus();
    expect(status.enabled, isTrue);
    expect(status.availableMethods, contains('card'));
  });

  // ---------------------------------------------------------------------------
  // CurrencyService
  // ---------------------------------------------------------------------------

  test('CurrencyService returns currency rates', () async {
    stubSend((request) {
      expect(request.method, 'GET');
      expect(request.url.toString(), '$baseUrl/api/v1/get-currency-rate-list');
      return respond(200, {
        'rates': [
          {
            'base_currency': 'USD',
            'target_currency': 'EUR',
            'rate': 0.92,
          }
        ]
      });
    });

    final rates = await client.currency.getCurrencyRateList();
    expect(rates, hasLength(1));
    expect(rates.first.targetCurrency, 'EUR');
  });

  // ---------------------------------------------------------------------------
  // Error handling
  // ---------------------------------------------------------------------------

  test('throws UPaymentsUnauthenticatedException on 401', () async {
    stubSend((_) => respond(401, {'message': 'Unauthorized'}));

    expect(
      () => client.merchant.checkPaymentButtonStatus(),
      throwsA(isA<UPaymentsUnauthenticatedException>()),
    );
  });

  test('throws UPaymentsForbiddenException on 403', () async {
    stubSend((_) => respond(403, {'message': 'Forbidden'}));

    expect(
      () => client.merchant.checkPaymentButtonStatus(),
      throwsA(isA<UPaymentsForbiddenException>()),
    );
  });

  test('throws UPaymentsValidationException on 422', () async {
    stubSend((_) => respond(422, {'message': 'Validation failed'}));

    expect(
      () => client.charge.createCharge(
        ChargeRequest(
          amount: 1000,
          currency: 'USD',
          notificationUrl: 'https://example.com/webhook',
        ),
      ),
      throwsA(isA<UPaymentsValidationException>()),
    );
  });

  test('throws UPaymentsRateLimitException on 429', () async {
    stubSend((_) => respond(429, {'message': 'Too many requests'}));

    expect(
      () async => client.merchant.checkPaymentButtonStatus(),
      throwsA(isA<UPaymentsRateLimitException>()),
    );
  });
}
