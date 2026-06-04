class PaymentStatusResponse {
  final String trackId;
  final String? status;
  final int? paidAmount;
  final String? currency;
  final Map<String, dynamic>? rawData;

  PaymentStatusResponse({
    required this.trackId,
    this.status,
    this.paidAmount,
    this.currency,
    this.rawData,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      trackId: json['track_id']?.toString() ?? '',
      status: json['status']?.toString(),
      paidAmount: json['paid_amount'] is int
          ? json['paid_amount'] as int
          : int.tryParse(json['paid_amount']?.toString() ?? ''),
      currency: json['currency']?.toString(),
      rawData: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'track_id': trackId,
      if (status != null) 'status': status,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (currency != null) 'currency': currency,
    };
  }
}
