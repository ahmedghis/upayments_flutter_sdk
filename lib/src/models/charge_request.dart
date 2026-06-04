import 'customer.dart';
import 'order.dart';
import 'product.dart';
import 'payment_gateway.dart';

class ChargeRequest {
  final String notificationUrl;
  final String? returnUrl;
  final String? cancelUrl;
  final Customer? customer;
  final Order? order;
  final List<Product>? products;
  final PaymentGateway? paymentGateway;
  final String? language;
  final String? referenceId;
  final String? customerExtraData;

  ChargeRequest({
    required this.notificationUrl,
    this.returnUrl,
    this.cancelUrl,
    this.customer,
    this.order,
    this.products,
    this.paymentGateway,
    this.language,
    this.referenceId,
    this.customerExtraData,
  });

  factory ChargeRequest.fromJson(Map<String, dynamic> json) {
    return ChargeRequest(
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
      language: json['language']?.toString(),
      referenceId: (json['reference'] as Map<String, dynamic>?)?['id']?.toString(),
      customerExtraData: json['customerExtraData']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (products != null)
        'products': products!.map((p) => p.toJson()).toList(),
      if (order != null) 'order': order!.toJson(),
      if (language != null) 'language': language,
      if (referenceId != null) 'reference': {'id': referenceId},
      if (customer != null) 'customer': customer!.toJson(),
      if (returnUrl != null) 'returnUrl': returnUrl,
      if (cancelUrl != null) 'cancelUrl': cancelUrl,
      'notificationUrl': notificationUrl,
      if (customerExtraData != null) 'customerExtraData': customerExtraData,
      if (paymentGateway != null) 'paymentGateway': paymentGateway!.toJson(),
    };
  }
}
