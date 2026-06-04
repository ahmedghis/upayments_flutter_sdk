import 'customer.dart';
import 'order.dart';
import 'product.dart';
import 'payment_gateway.dart';

class ChargeRequest {
  final int amount;
  final String currency;
  final String notificationUrl;
  final String? returnUrl;
  final String? cancelUrl;
  final Customer? customer;
  final Order? order;
  final List<Product>? products;
  final PaymentGateway? paymentGateway;
  final String? customerUniqueToken;

  ChargeRequest({
    required this.amount,
    required this.currency,
    required this.notificationUrl,
    this.returnUrl,
    this.cancelUrl,
    this.customer,
    this.order,
    this.products,
    this.paymentGateway,
    this.customerUniqueToken,
  });

  factory ChargeRequest.fromJson(Map<String, dynamic> json) {
    return ChargeRequest(
      amount: json['amount'] as int,
      currency: json['currency']?.toString() ?? '',
      notificationUrl: json['notificationUrl']?.toString() ?? '',
      returnUrl: json['returnUrl']?.toString(),
      cancelUrl: json['cancelUrl']?.toString(),
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      order: json['order'] != null
          ? Order.fromJson(json['order'] as Map<String, dynamic>)
          : null,
      products: json['products'] != null
          ? (json['products'] as List<dynamic>)
              .map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      paymentGateway: json['paymentGateway'] != null
          ? PaymentGateway.fromJson(json['paymentGateway'] as Map<String, dynamic>)
          : null,
      customerUniqueToken: json['customerUniqueToken']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'notificationUrl': notificationUrl,
      if (returnUrl != null) 'returnUrl': returnUrl,
      if (cancelUrl != null) 'cancelUrl': cancelUrl,
      if (customer != null) 'customer': customer!.toJson(),
      if (order != null) 'order': order!.toJson(),
      if (products != null)
        'products': products!.map((product) => product.toJson()).toList(),
      if (paymentGateway != null) 'paymentGateway': paymentGateway!.toJson(),
      if (customerUniqueToken != null)
        'customerUniqueToken': customerUniqueToken,
    };
  }
}
