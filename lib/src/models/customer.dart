class Customer {
  final String? uniqueId;
  final String? name;
  final String? email;
  final String? mobile;

  Customer({this.uniqueId, this.name, this.email, this.mobile});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      uniqueId: json['uniqueId']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      mobile: json['mobile']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (uniqueId != null) 'uniqueId': uniqueId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (mobile != null) 'mobile': mobile,
    };
  }
}
