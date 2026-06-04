class Order {
  final String id;
  final String? reference;
  final String? description;
  final String? currency;
  final double? amount;

  Order({
    required this.id,
    this.reference,
    this.description,
    this.currency,
    this.amount,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '',
      reference: json['reference']?.toString(),
      description: json['description']?.toString(),
      currency: json['currency']?.toString(),
      amount: json['amount'] is num
          ? (json['amount'] as num).toDouble()
          : double.tryParse(json['amount']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (reference != null) 'reference': reference,
      if (description != null) 'description': description,
      if (currency != null) 'currency': currency,
      if (amount != null) 'amount': amount,
    };
  }
}
