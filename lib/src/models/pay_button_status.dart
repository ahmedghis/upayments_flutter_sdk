class PayButtonStatus {
  final bool enabled;
  final List<String> availableMethods;
  final String? message;

  PayButtonStatus({
    required this.enabled,
    this.availableMethods = const [],
    this.message,
  });

  factory PayButtonStatus.fromJson(Map<String, dynamic> json) {
    return PayButtonStatus(
      enabled: json['enabled'] == true,
      availableMethods: json['available_methods'] is List<dynamic>
          ? (json['available_methods'] as List<dynamic>)
              .map((item) => item.toString())
              .toList()
          : const [],
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'available_methods': availableMethods,
      if (message != null) 'message': message,
    };
  }
}
