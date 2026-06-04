class CurrencyRate {
  final String baseCurrency;
  final String targetCurrency;
  final double rate;

  CurrencyRate({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
  });

  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    return CurrencyRate(
      baseCurrency: json['base_currency']?.toString() ?? '',
      targetCurrency: json['target_currency']?.toString() ?? '',
      rate: json['rate'] is num
          ? (json['rate'] as num).toDouble()
          : double.tryParse(json['rate']?.toString() ?? '') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_currency': baseCurrency,
      'target_currency': targetCurrency,
      'rate': rate,
    };
  }
}
