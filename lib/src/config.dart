class UPaymentsConfig {
  final String apiKey;
  final bool isSandbox;

  const UPaymentsConfig({required this.apiKey, this.isSandbox = false});

  String get baseUrl => isSandbox
      ? 'https://sandbox.upayments.com'
      : 'https://api.upayments.com';
}
