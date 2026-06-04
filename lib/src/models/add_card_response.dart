class AddCardResponse {
  final String? redirectUrl;
  final String? status;
  final String? message;
  final Map<String, dynamic> rawData;

  AddCardResponse({
    this.redirectUrl,
    this.status,
    this.message,
    required this.rawData,
  });

  factory AddCardResponse.fromJson(Map<String, dynamic> json) {
    return AddCardResponse(
      redirectUrl: json['redirect_url']?.toString(),
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      rawData: json,
    );
  }
}
