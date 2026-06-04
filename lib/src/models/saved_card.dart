class SavedCard {
  final String cardId;
  final String? brand;
  final String? last4;
  final int? expiryMonth;
  final int? expiryYear;

  SavedCard({
    required this.cardId,
    this.brand,
    this.last4,
    this.expiryMonth,
    this.expiryYear,
  });

  factory SavedCard.fromJson(Map<String, dynamic> json) {
    return SavedCard(
      cardId: json['card_id']?.toString() ?? '',
      brand: json['brand']?.toString(),
      last4: json['last4']?.toString(),
      expiryMonth: json['expiry_month'] is int
          ? json['expiry_month'] as int
          : int.tryParse(json['expiry_month']?.toString() ?? ''),
      expiryYear: json['expiry_year'] is int
          ? json['expiry_year'] as int
          : int.tryParse(json['expiry_year']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card_id': cardId,
      if (brand != null) 'brand': brand,
      if (last4 != null) 'last4': last4,
      if (expiryMonth != null) 'expiry_month': expiryMonth,
      if (expiryYear != null) 'expiry_year': expiryYear,
    };
  }
}
