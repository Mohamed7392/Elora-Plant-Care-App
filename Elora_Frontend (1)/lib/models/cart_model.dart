class CartItem {
  final String plantId;
  final String name;
  final double price;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.plantId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  // لو هتستخدم Firestore
  factory CartItem.fromMap(Map<String, dynamic> map, String id) {
    return CartItem(
      plantId: id,
      name: map['name'] ?? '',
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] ?? 1,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}
