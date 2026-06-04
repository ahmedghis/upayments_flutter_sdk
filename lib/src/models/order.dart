import 'product.dart';

class Order {
  final String id;
  final int? amount;
  final String? currency;
  final List<Product>? products;

  Order({required this.id, this.amount, this.currency, this.products});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '',
      amount: json['amount'] is int ? json['amount'] as int : int.tryParse(json['amount']?.toString() ?? ''),
      currency: json['currency']?.toString(),
      products: json['products'] != null
          ? (json['products'] as List<dynamic>)
              .map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (products != null)
        'products': products!.map((product) => product.toJson()).toList(),
    };
  }
}
