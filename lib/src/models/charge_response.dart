class ChargeResponse {
  final String trackId;
  final String link;
  final String? status;
  final String? message;
  final String? returnUrl;
  final String? cancelUrl;

  ChargeResponse({
    required this.trackId,
    required this.link,
    this.status,
    this.message,
    this.returnUrl,
    this.cancelUrl,
  });

  factory ChargeResponse.fromJson(Map<String, dynamic> json) {
    return ChargeResponse(
      trackId: json['track_id']?.toString() ?? '',
      link: json['link']?.toString() ?? '',
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      returnUrl: json['returnUrl']?.toString(),
      cancelUrl: json['cancelUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'track_id': trackId,
      'link': link,
      if (status != null) 'status': status,
      if (message != null) 'message': message,
      if (returnUrl != null) 'returnUrl': returnUrl,
      if (cancelUrl != null) 'cancelUrl': cancelUrl,
    };
  }
}
