enum PaymentGatewaySrc {
  whitelabel,
  inline,
  redirect,
}

class PaymentGateway {
  final PaymentGatewaySrc src;
  final String? gateway;

  PaymentGateway({required this.src, this.gateway});

  factory PaymentGateway.fromJson(Map<String, dynamic> json) {
    final rawSrc = json['src']?.toString();
    final src = PaymentGatewaySrc.values.firstWhere(
      (value) => value.name == rawSrc,
      orElse: () => PaymentGatewaySrc.inline,
    );
    return PaymentGateway(
      src: src,
      gateway: json['gateway']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'src': src.name,
      if (gateway != null) 'gateway': gateway,
    };
  }
}
