# UPayments SDK

A Flutter SDK package for the UPayments Gateway API (UInterfaceV2).

## Package Setup

Update the root package dependencies by running:

```bash
flutter pub get
```

Then use the client from `package:upayments_sdk/upayments_sdk.dart`.

## Example App

The `example/` folder contains a sample checkout flow demonstrating:

- charge creation via `ChargeService`
- navigation to the hosted payment page
- handling `returnUrl` and `cancelUrl`
- reading the returned `track_id`

Run the example app with:

```bash
cd example
flutter pub get
flutter run
```

## Quick Start

```dart
import 'package:upayments_sdk/upayments_sdk.dart';

final client = UPaymentsClient(
  config: const UPaymentsConfig(
    apiKey: 'jtest123',
    isSandbox: true,
  ),
);

final charge = await client.charge.createCharge(
  ChargeRequest(
    amount: 1000,
    currency: 'USD',
    notificationUrl: 'https://your-backend.example.com/webhook',
    returnUrl: 'https://your-site.example.com/return',
    cancelUrl: 'https://your-site.example.com/cancel',
    customer: Customer(
      name: 'Jane Doe',
      email: 'jane@example.com',
      phone: '+1234567890',
    ),
  ),
);

final paymentPage = UPaymentsCheckoutPage(
  link: charge.link,
  returnUrl: 'https://your-site.example.com/return',
  cancelUrl: 'https://your-site.example.com/cancel',
  onNavigationFinished: (result) {
    print('Checkout completed: ${result.trackId}');
  },
);
```

## Whitelabel vs Non-whitelabel

### Non-whitelabel

Use the standard checkout flow without a `paymentGateway` object:

```dart
final request = ChargeRequest(
  amount: 1000,
  currency: 'USD',
  notificationUrl: 'https://your-backend.example.com/webhook',
  returnUrl: 'https://your-site.example.com/return',
  cancelUrl: 'https://your-site.example.com/cancel',
);
```

### Whitelabel

Whitelabel mode requires activation by a UPayments Account Manager.
Include the optional `paymentGateway` object in `ChargeRequest`.

```dart
final request = ChargeRequest(
  amount: 1200,
  currency: 'USD',
  notificationUrl: 'https://your-backend.example.com/webhook',
  returnUrl: 'https://your-site.example.com/return',
  cancelUrl: 'https://your-site.example.com/cancel',
  paymentGateway: PaymentGateway(
    src: PaymentGatewaySrc.whitelabel,
    gateway: 'custom',
  ),
);
```

## Customer Unique Token Security

`customerUniqueToken` must be a numeric string between 8 and 18 digits. It should be non-predictable and is best derived from a combination of your internal user ID and phone number digits.
For example:

- `123451234567890` (user ID `12345` + phone digits `1234567890`)
- `987651472583690` (user ID `98765` + phone digits `1472583690`)

The SDK validates the token against the pattern `^[0-9]{8,18}$` before sending it to the API.

## Supported Services

- `ChargeService` for `POST /api/v1/charge`
- `PaymentStatusService` for `GET /api/v1/get-payment-status/{track_id}`
- `RefundService` for `POST /api/v1/create-refund`, `GET /api/v1/delete-refund`, and `GET /api/v1/check-refund/{order_id}`
- `CardService` for `POST /api/v1/create-customer-unique-token`, `POST /api/v1/add-card`, and `POST /api/v1/retrieve-customer-cards`
- `MerchantService` for `GET /api/v1/check-payment-button-status`
- `CurrencyService` for `GET /api/v1/get-currency-rate-list`

## Test Credentials

Use the following sandbox test credentials:

- API key: `jtest123`
- API token: `e66a94d579cf75fba327ff716ad68c53aae11528`

## Error Handling

The SDK throws typed exceptions for HTTP error responses:

- `UPaymentsUnauthenticatedException` for 401
- `UPaymentsForbiddenException` for 403
- `UPaymentsValidationException` for 422
- `UPaymentsRateLimitException` for 429

## Running Tests

From the package root:

```bash
flutter test
```
