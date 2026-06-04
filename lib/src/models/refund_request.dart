class RefundRequest {
  final String orderId;
  final int amount;
  final String currency;
  final String? reason;

  RefundRequest({
    required this.orderId,
    required this.amount,
    required this.currency,
    this.reason,
  });

  factory RefundRequest.fromJson(Map<String, dynamic> json) {
    return RefundRequest(
      orderId: json['orderId']?.toString() ?? '',
      amount: json['amount'] is int
          ? json['amount'] as int
          : int.tryParse(json['amount']?.toString() ?? '') ?? 0,
      currency: json['currency']?.toString() ?? '',
      reason: json['reason']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'amount': amount,
      'currency': currency,
      if (reason != null) 'reason': reason,
    };
  }
}
