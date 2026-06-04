class RefundResponse {
  final String refundId;
  final String orderId;
  final String? status;
  final String? message;

  RefundResponse({
    required this.refundId,
    required this.orderId,
    this.status,
    this.message,
  });

  factory RefundResponse.fromJson(Map<String, dynamic> json) {
    return RefundResponse(
      refundId: json['refund_id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      status: json['status']?.toString(),
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refund_id': refundId,
      'order_id': orderId,
      if (status != null) 'status': status,
      if (message != null) 'message': message,
    };
  }
}
