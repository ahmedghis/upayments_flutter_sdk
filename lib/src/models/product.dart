class Product {
  final String id;
  final String? name;
  final int? quantity;
  final int? price;

  Product({required this.id, this.name, this.quantity, this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString(),
      quantity: json['quantity'] is int
          ? json['quantity'] as int
          : int.tryParse(json['quantity']?.toString() ?? ''),
      price: json['price'] is int
          ? json['price'] as int
          : int.tryParse(json['price']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
    };
  }
}
