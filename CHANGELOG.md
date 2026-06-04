## 1.1.0

- **Breaking**: `ChargeRequest` no longer takes top-level `amount`/`currency`; use `Order(id, currency, amount)` instead.
- **Breaking**: `Product` fields updated: `name` and `price` (double) are now required; `id` removed; `description` added.
- **Breaking**: `Customer.phone` renamed to `Customer.mobile`; `Customer.uniqueId` added.
- **Breaking**: `Order.products` removed; pass products directly on `ChargeRequest`.
- `Order` gains optional `reference` and `description` fields; `amount` type changed to `double`.
- `ChargeRequest` gains optional `language`, `referenceId`, and `customerExtraData` fields.
- `ChargeRequest.customerUniqueToken` removed; set `Customer.uniqueId` instead.
- All requests now include `Accept: application/json` header.

## 1.0.0

- Initial release.
- Charge creation, payment status, refunds, saved cards, merchant status, and currency rates.
- `UPaymentsCheckoutPage` WebView widget for hosted payment flow.
